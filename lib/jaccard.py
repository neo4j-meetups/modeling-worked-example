import numpy as np
from sklearn.metrics import jaccard_similarity_score

y_pred = [0, 2, 1, 3]
y_true = [0, 1, 2, 3]

print jaccard_similarity_score(y_true, y_pred)
print jaccard_similarity_score(y_true, y_pred, normalize=False)
