import flask
import spacy
import json
from pathlib import Path

nlp = spacy.load('en')

app = flask.Flask(__name__)

@app.route('/ents')
def get_ents():
    data = flask.request.args.get('fragment')
    is_custom = flask.request.args.get('custom')
    if is_custom is not None:
        nlp = spacy.load(Path('./gina_haspel'))
    doc = nlp(data)
    print(doc)
    tuples = [(str(x), x.label_)
              for x
              in doc.ents]
    return  flask.jsonify(dict(tuples))

@app.route('/stemmer')
def stemmer():
    data = flask.request.args.get('source')
    doc = nlp(data)
    raw = [(x.lemma_, x.pos_) for x in [y
                    for y
                    in doc
                    if not y.is_stop and y.pos_ != 'PUNCT']]
    return  flask.jsonify(dict(raw))

