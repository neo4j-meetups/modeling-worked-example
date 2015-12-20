import csv

def find_matching_index(pair, dups):
    return [index
            for index, dup in enumerate(dups)
            if pair[0] in dup or pair[1] in dup]
dups = []

with open("neo4j-community-2.3.1/data/import/duplicates.csv", "r") as duplicates_file:
    reader = csv.reader(duplicates_file, delimiter = ",")

    for row in reader:
        pair = (row[1], row[2])
        matching_index = find_matching_index(pair, dups)

        print pair, matching_index

        if len(matching_index) == 0:
            dups.append(set([pair[0], pair[1]]))
        elif len(matching_index) == 1:
            index = matching_index[0]
            matching_dup = dups[index]
            dups.pop(index)
            dups.insert(index, matching_dup.union([pair[0], pair[1]]))
        else:
            index1, index2 = matching_index
            dup1 = dups[index1]
            dup2 = dups[index2]

            dups.pop(index1)
            dups.pop(index2 - 1)
            dups.append(dup1.union(dup2))

print dups

with open("data/dups.csv", "w") as dups_file:

    writer = csv.writer(dups_file, delimiter = ",")

    for dup in dups:
        writer.writerow([";".join(dup)])

# 23526916  23772223
