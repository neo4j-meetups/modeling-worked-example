
# look at this one later - can probably blog it
# http://stackoverflow.com/questions/20953594/barplot-in-r-ggplot-with-multiple-factors
byYearMon = joinedDF %>% 
  mutate(yearmon = as.Date(as.yearmon(joinDate))) %>% 
  count(yearmon) %>% 
  mutate(year = format(yearmon, "%Y"))

ggplot(aes(x = yearmon, y = n, label = n), data = byYearMon) + 
  geom_bar(stat = "identity", fill = "Dark Blue") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_date(labels = date_format("%B"), breaks = "1 month") +
  facet_wrap(~ year) +
  ggtitle("Number of new members by month/year")