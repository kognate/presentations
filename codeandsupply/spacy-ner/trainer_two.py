import spacy
from spacy.matcher import PhraseMatcher
from app import url_to_string
import plac
from pathlib import Path
import random

import hashlib
import json

label = 'CIADIR'

nlp = spacy.blank('en')
if 'ner' not in nlp.pipe_names:
    ner = nlp.create_pipe('ner')
    nlp.add_pipe(ner)
else:
    ner = nlp.get_pipe('ner')

ner.add_label(label)


mnlp = spacy.load('en')

matcher = PhraseMatcher(mnlp.vocab)
for i in ['Gina Haspel', 'Gina', 'Haspel',]:
    matcher.add(label, None, mnlp(i))

res = []
to_train_ents = []
with open('gina_haspel.txt') as gh:
    line = True
    while line:
        line = gh.readline()
        matches = matcher(mnlp(line))
        for i in matches:
            res.append((i[1], i[2], label))
        to_train_ents.append((line, res))

@plac.annotations(
    new_model_name=("New model name for model meta.", "option", "nm", str),
    output_dir=("Optional output directory", "option", "o", Path))
def train(new_model_name='be_best', output_dir=None):

    optimizer = nlp.begin_training()

    other_pipes = [pipe for pipe in nlp.pipe_names if pipe != 'ner']
    with nlp.disable_pipes(*other_pipes):  # only train NER
        for itn in range(25):
            losses = {}
            random.shuffle(to_train_ents)
            for item in to_train_ents:
                nlp.update([item[0]], [item[1]], sgd=optimizer, drop=0.40,
                           losses=losses)
            print(losses)


    if output_dir is None:
        output_dir = "./gina_haspel"


    output_dir = Path(output_dir)
    if not output_dir.exists():
        output_dir.mkdir()

    nlp.meta['name'] = new_model_name
    nlp.to_disk(output_dir)


    test_text = to_train_ents[0][0]
    doc = nlp(test_text)
    print("Entities in '%s'" % test_text)
    for ent in doc.ents:
        print(ent.label_, ent.text)


if __name__ == '__main__':
    plac.call(train)

