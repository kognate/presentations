
import spacy
nlp = spacy.load('en')
to_analyze = ('Hello Code & Supply, '
              'my name is Josh and tonight '
              'we\'re in Pittsburgh')
doc = nlp(to_analyze)
ents = [(x.text, x.label_)
        for x in doc.ents] 
print(ents)
ents
