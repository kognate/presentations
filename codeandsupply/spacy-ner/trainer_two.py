import spacy
from spacy.matcher import PhraseMatcher
import plac
from pathlib import Path
import random

def offseter(lbl, doc, matchitem):
    o_one = len(str(doc[0:matchitem[1]]))
    o_two = o_one + len(str(doc[matchitem[1]:matchitem[2]]))
    return (o_one, o_two, lbl)
    
label = 'CIADIR'

nlp = spacy.load('en')
if 'ner' not in nlp.pipe_names:
    ner = nlp.create_pipe('ner')
    nlp.add_pipe(ner)
else:
    ner = nlp.get_pipe('ner')

ner.add_label(label)

matcher = PhraseMatcher(nlp.vocab)
for i in ['Gina Haspel', 'Gina', 'Haspel',]:
    matcher.add(label, None, nlp(i))

res = []
to_train_ents = []
with open('gina_haspel.txt') as gh:
    line = True
    while line:
        line = gh.readline()
        mnlp_line = nlp(line)
        matches = matcher(mnlp_line)
        res = [offseter(label, mnlp_line, x) for x in matches]
        to_train_ents.append((line, dict(entities=res)))

@plac.annotations(
    new_model_name=("New model name for model meta.", "option", "nm", str),
    output_dir=("Optional output directory", "option", "o", Path))
def train(new_model_name='gina', output_dir=None):

    optimizer = nlp.begin_training()

    other_pipes = [pipe for pipe in nlp.pipe_names if pipe != 'ner']
    with nlp.disable_pipes(*other_pipes):  # only train NER
        for itn in range(20):
            losses = {}
            random.shuffle(to_train_ents)
            for item in to_train_ents:
                nlp.update([item[0]], [item[1]], sgd=optimizer, drop=0.35,
                           losses=losses)
            print(losses)


    if output_dir is None:
        output_dir = "./gina_haspel"


    noutput_dir = Path(output_dir)
    if not noutput_dir.exists():
        noutput_dir.mkdir()

    nlp.meta['name'] = new_model_name
    nlp.to_disk(output_dir)


    random.shuffle(to_train_ents)

    test_text = to_train_ents[0][0]
    doc = nlp(test_text)
    print("Entities in '%s'" % test_text)
    for ent in doc.ents:
        print(ent.label_, ent.text)


if __name__ == '__main__':
    plac.call(train)

