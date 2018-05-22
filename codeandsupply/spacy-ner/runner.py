import spacy
from pathlib import Path
import random
import plac

res = []
with open('gina_haspel.txt') as gh:
    line = True
    while line:
        line = gh.readline()
        res.append(line)

@plac.annotations(model_name=("Load model", "option", "m", Path), sentence=("a sentent", "option", "s", str))
def run(model_name=Path('./gina_haspel'), sentence=None):
    nlp = spacy.load(model_name)

    if sentence is not None:
        j = nlp(sentence)
        print(sentence)
        for ent in j.ents:
            print(f'{ent.label_} : {ent.text}')
    else:
        random.shuffle(res)
        for line in res[0:5]:
            j = nlp(line)
            print(line)
            for ent in j.ents:
                print(f'{ent.label_} : {ent.text}')


if __name__ == '__main__':
    plac.call(run)

