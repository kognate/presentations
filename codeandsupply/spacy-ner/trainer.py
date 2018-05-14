import spacy
from spacy.matcher import PhraseMatcher
from app import url_to_string
import plac
from pathlib import Path
import random

import hashlib

label = 'WH_PROGRAM'

nlp = spacy.blank('en')
if 'ner' not in nlp.pipe_names:
    ner = nlp.create_pipe('ner')
    nlp.add_pipe(ner)
else:
    ner = nlp.get_pipe('ner')

ner.add_label(label)


mnlp = spacy.load('en')

matcher = PhraseMatcher(mnlp.vocab)
for i in ['Be Best', 'be best', 'bebest', 'BE BEST', 'be ebst']:
    matcher.add('BEBEST', None, mnlp(i))

to_train_ents = []

training_urls = [
    'https://www.newyorker.com/culture/culture-desk/the-childlike-strangeness-of-melania-trumps-be-best-campaign',
    'https://www.theguardian.com/us-news/2018/may/08/be-best-melania-trump-initiative-grammatical-flaw',
    'https://www.cnn.com/2018/05/07/politics/melania-trump-unveils-platform-be-best/index.html',
    'https://news.ycombinator.com/',
    'https://www.cnn.com/2018/05/11/politics/headlines-this-week-melania-trump-be-best-john-mccain-analysis/index.html',
    'https://abcnews.go.com/Entertainment/snl-targets-melania-trumps-best-campaign-calls-sexy/story?id=55126322',
    'http://www.latimes.com/opinion/op-ed/la-oe-riley-be-best-melania-trump-20180511-story.html',
    'http://nymag.com/daily/intelligencer/2018/05/donald-trump-fits-perfectly-into-melanias-be-best-initiative.html',
    'https://www.snopes.com/fact-check/did-melania-trump-plagiarize-pamphlet/',
    'https://www.townandcountrymag.com/society/politics/a20508248/melania-trump-be-best-campaign-booklet-copied-obama/',
    'https://www.npr.org/2018/05/07/609180852/first-lady-melania-trump-unveils-be-best-campaign-focusing-on-children',
    'https://www.huffingtonpost.com/entry/chuck-schumer-donald-trump-melania-be-best_us_5af545ffe4b032b10bf940b3',
    'https://www.thedailybeast.com/jimmy-kimmel-mocks-melania-trumps-be-best-campaign',
    'http://thehill.com/homenews/administration/386641-melania-be-best-campaign-booklet-copies-from-obama-era-ftc-brochure',
    'https://slate.com/human-interest/2018/05/melanias-be-best-campaign-sure-sounds-like-a-direct-rebuke-to-her-husband.html',
    'http://www.businessinsider.com/melania-trump-be-best-campaign-details-2018-5',
    'http://www.bbc.com/news/world-us-canada-44034723',
    'http://www.latimes.com/opinion/la-ol-enter-the-fray-melania-s-be-best-campaign-1525727262-htmlstory.html',
    'http://www.msnbc.com/rachel-maddow-show/melania-trumps-be-best-materials-become-latest-white-house-misstep',
    'https://www.refinery29.com/2018/05/198573/melania-trump-be-best-criticism',
    'https://en.wikipedia.org/wiki/Be_Best',
    'https://www.whitehouse.gov/bebest/']

for u in training_urls:
    md = hashlib.md5()
    md.update(u.encode('ascii'))
    p = Path('.', md.hexdigest())
    bb = ""

    if p.exists():
        print("from cache: {}".format(u))
        with open(p) as f:
            bb = f.read()
    else:
        print("fetching {}".format(u))
        bb = url_to_string(u)
        with open(p, 'w') as f:
            f.write(bb)
    doc = mnlp(bb.encode('ascii', errors='replace').decode("ascii"))
    res = []
    matches = matcher(doc)
    for i in matches:
        res.append((i[1], i[2], label))
    to_train_ents.append((bb, dict(entities=res)))


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


    test_text = 'who created the be best program at the whitehouse?'
    doc = nlp(test_text)
    print("Entities in '%s'" % test_text)
    for ent in doc.ents:
        print(ent.label_, ent.text)


if __name__ == '__main__':
    plac.call(train)

