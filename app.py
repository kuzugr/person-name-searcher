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

    uniq_person_names = list(set(person_names))
    #  NOTE: ユニークにした後さらに苗字のみなどの重複を省く
    #  例： ["田中太郎", "田中"]があった場合、"田中"は削除する
    delete_names = []
    for person_name in uniq_person_names:
        for target_name in list(set(uniq_person_names) - set([person_name])):
            if person_name in target_name:
                delete_names.append(person_name)
                break

    not_duplicate_person_names = list(set(uniq_person_names) - set(delete_names))

    return { 'persons': not_duplicate_person_names }
