import pandas as pd

dataDF = pd.read_json('./datasrc/locResults.json')

dT = dataDF.transpose()

print(dT.head(100))