def find_matching_index(pair, dups):
    return [index
            for index, dup in enumerate(dups)
            if pair[0] in dup or pair[1] in dup]

def extract_groups(items):
    dups = []
    for pair in items:
        matching_index = find_matching_index(pair, dups)

        if len(matching_index) == 0:
            dups.append(set([pair[0], pair[1]]))
        elif len(matching_index) == 1:
            index = matching_index[0]
            matching_dup = dups[index]
            dups.pop(index)
            dups.append(matching_dup.union([pair[0], pair[1]]))
        else:
            index1, index2 = matching_index
            dup1 = dups[index1]
            dup2 = dups[index2]

            dups.pop(index1)
            dups.pop(index2 - 1)
            dups.append(dup1.union(dup2))
    return dups

test_cases = [
    [ ("A", "B"), ("B", "C"), ("C", "D"), ("E", "F"), ("F", "G") ],
    [ ("A", "B"), ("B", "C"), ("C", "D"), ("E", "F"), ("F", "G"), ("G", "A"), ("G", "Z"), ("B", "D") ],
    [ ("A", "B"), ("B", "C"), ("C", "E"), ("E", "A") ],
    [ ("A", "B"), ("C", "D"), ("F", "G"), ("H", "I"), ("J", "A") ]
]

for test_case in test_cases:
    print extract_groups(test_case)
