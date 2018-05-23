
import spacy
nlp = spacy.load('en')
doc = nlp("Hello everyone, I've some good news to give you")
cleaned = [y for y
           in doc
           if not y.is_stop and y.pos_ != 'PUNCT']
raw = [(x.lemma_, x.pos_) for x in cleaned]
print(raw)
raw
