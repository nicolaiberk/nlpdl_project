# -*- coding: utf-8 -*-
"""BaselineModel.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1NaC33hh6HwDQlNXCIVqRCMLenjd_Vhi9
"""

# upload press releases beforehand

!pip install -Uqq fastbook
import fastbook
fastbook.setup_book()

from fastbook import *
from fastai.text.all import *
import pandas as pd

df = pd.read_csv('germanyPPRs.csv', error_bad_lines=False, engine="python")

# split off test set here

dls = TextDataLoaders.from_df(df, text_col = 'text', label_col = 'label')

dls = TextDataLoaders.from_df(df, text_col = 'text', label_col = 'label') # for some reason this doesn't really work on the full data yet

learn = text_classifier_learner(dls, AWD_LSTM, drop_mult=0.5, metrics=accuracy) # train model
learn.fine_tune(4, 1e-2)

learn.predict('Ausländer haben in diesem Land nichts verloren!') # Interesting - says Union atm

learn.predict('Ausländer haben in diesem Land nichts verloren! Die erneuten Übergriffe durch Migranten zeigen, dass die Intergrationspolitik der Bundesregierung gescheitert ist. Multikulti ist am Ende. Deshalb: Abschiebung jetzt!') 
# this predicts union atm, not so convincing i think
