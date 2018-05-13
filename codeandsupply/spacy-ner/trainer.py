import spacy
from spacy.matcher import PhraseMatcher
from app import url_to_string
import plac
from pathlib import Path
import random

label = 'WH_PROGRAM'

nlp = spacy.load('en')
ner = nlp.get_pipe('ner')
ner.add_label(label)

def on_match(matcher, doc, id, matches):
    # I do stuff on each match
    pass

matcher = PhraseMatcher(nlp.vocab)
for i in ['BE BEST', 'Be Best', 'bebest', 'be best', 'be ebst']:
    matcher.add('BEBEST', on_match, nlp(i))



to_train_ents = []

training_urls = [
    'https://www.newyorker.com/culture/culture-desk/the-childlike-strangeness-of-melania-trumps-be-best-campaign',
    'https://www.whitehouse.gov/bebest/']

for u in training_urls:
    bb = url_to_string(u)
    doc = nlp(bb.encode('ascii', errors='replace').decode("ascii"))
    for sent in doc.sents:
        sent_text = sent.string.strip()
        matches = matcher(nlp(sent_text))
        if len(matches) > 0:
            print(sent_text)
        for i in matches:
            to_train_ents.append((sent_text, dict(entities=[(i[1], i[2], label)])))

@plac.annotations(
    new_model_name=("New model name for model meta.", "option", "nm", str),
    output_dir=("Optional output directory", "option", "o", Path))
def train(new_model_name='be_best', output_dir=None):

    optimizer = nlp.entity.create_optimizer()

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
        output_dir = "./be_best"


    output_dir = Path(output_dir)
    if not output_dir.exists():
        output_dir.mkdir()

    nlp.meta['name'] = new_model_name
    nlp.to_disk(output_dir)

if __name__ == '__main__':
    plac.call(train)

