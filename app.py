import hug
import spacy

@hug.post('/persons')
def hello(text: hug.types.text):
    nlp = spacy.load('ja_ginza')
    doc = nlp(text)

    person_names = []
    tags = []

    person_names_index = 0
    tags_index = 0

    for sent in doc.sents:
        for token in sent:
            tags.append(token.tag_)
            tags_index += 1
            if not '人名' in token.tag_:
                continue

            if person_names == []:
                person_names.append(token.orth_)
            elif '人名' in tags[tags_index - 2]:
                person_names[person_names_index] += token.orth_
            else:
                person_names_index += 1
                person_names.append(token.orth_)

    return person_names
