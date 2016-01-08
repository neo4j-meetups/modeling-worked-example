library(RNeo4j)
library(ggplot2)
library(zoo)
library(dplyr)
library(pscl)
library(ROCR)
library(caret)

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "medium")

query = "
          MATCH (member:Member) 

          WITH member ORDER BY tofloat(member.id) * rand() LIMIT 10
          MATCH (member)-[membership:MEMBER_OF]->(group:Group)-[:HOSTED_EVENT]-(event)
          WHERE event.time < timestamp() AND event.time > membership.joined
          OPTIONAL MATCH (member)-[:FRIENDS]->(:Member)-[friendRSVP:RSVP_YES]->(event:Event)

          WITH member,group, event, COUNT(friendRSVP) AS friendsRSVPs
          OPTIONAL MATCH (member)-[rsvp:RSVPD]->(event:Event)
          OPTIONAL MATCH (member)-[yesRSVP:RSVPD {response: 'yes'}]->(otherEvent)<-[:HOSTED_EVENT]-(group)
          WHERE otherEvent.time < event.time
          
          WITH member, event, COUNT(yesRSVP) AS previousYesRSVPs, friendsRSVPs, rsvp
          OPTIONAL MATCH (member)-[:INTERESTED_IN]->(t)<-[:HAS_TOPIC]-()-[:HOSTED_EVENT]->(event)

          RETURN event.id, friendsRSVPs, previousYesRSVPs, COUNT(t) AS topics, rsvp.response AS response
          ORDER BY friendsRSVPs DESC
         "

df = cypher(graph, query)

df = df %>% mutate(attended = ifelse(is.na(response), 0, ifelse(response == "yes", 1, 0)))

attended = as.factor((df %>% dplyr::select(attended))$attended)
upSampledDf = upSample(df %>% dplyr::select(-attended), attended)
upSampledDf$attended = as.numeric(as.character(upSampledDf$Class))

rand <- sample(nrow(upSampledDf))
upSampledDf[rand, ]

train <- upSampledDf[rand, ][1:2500,]
test <- upSampledDf[rand, ][2501:3082,]

model = glm(formula = attended ~ previousYesRSVPs + friendsRSVPs + topics, family = binomial(link = "logit"), 
    data = train)

summary(model)

anova(model, test="Chisq")

pR2(model)

fitted.results <- predict(model,newdata=test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)

misClasificError <- mean(fitted.results != test$attended)
print(paste('Accuracy',1-misClasificError))

p <- predict(model, newdata=test, type="response")
pr <- prediction(p, test$attended)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

myDf = data.frame(friendsRSVPs = c(1, 0, 5), previousYesRSVPs = c(1, 10, 0), topics = c(5, 2, 3))
predict(model, newdata=myDf, type="response")