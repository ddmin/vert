# format diacritic marks

import re

# Diacritic Reference
# \ - grave
# / - acute
# ^ - circumflex
# ~ - tilde
# : - umlaut
# ? - cedilla

ACCENTS = {
            '/': {
                'A': 'Á',
                'E': 'É',
                'I': 'Í',
                'O': 'Ó',
                'U': 'Ú',
                'Y': 'Ý',
                'a': 'á',
                'e': 'é',
                'i': 'í',
                'o': 'ó',
                'u': 'ú',
                'y': 'ý',
            },
            ':': {
                'A': 'Ä',
                'E': 'Ë',
                'I': 'Ï',
                'O': 'Ö',
                'U': 'Ü',
                'Y': 'Ÿ',
                'a': 'ä',
                'e': 'ë',
                'i': 'ï',
                'o': 'ö',
                'u': 'ü',
                'y': 'ÿ',
            },
            ')': {'C': 'Ç', 'c': 'ç'},
            '`': {
                'A': 'À',
                'E': 'È',
                'I': 'Ì',
                'O': 'Ò',
                'U': 'Ù',
                'a': 'à',
                'e': 'è',
                'i': 'ì',
                'o': 'ò',
                'u': 'ù',
            },
            '^': {
                'A': 'Â',
                'E': 'Ê',
                'I': 'Î',
                'O': 'Ô',
                'U': 'Û',
                'a': 'â',
                'e': 'ê',
                'i': 'î',
                'o': 'ô',
                'u': 'û',
            },
            '~': {'A': 'Ã', 'N': 'Ñ', 'O': 'Õ', 'a': 'ã', 'n': 'ñ', 'o': 'õ'},
        }

def diacritic(word):
    if len(word.split(' ')) > 1:
        return ' '.join(list(map(lambda x: diacritic(x), word.split(' '))))

    r = re.findall(r'([`/^~:)])(.)', word)

    for pattern in r:
        if ACCENTS[pattern[0]].get(pattern[1]):
            word = re.sub('\\' + ''.join(pattern), ACCENTS[pattern[0]][pattern[1]], word)

    return word

def main():
    while True:
        word = input('> ')
        print(diacritic(word))
        print()

if __name__ == '__main__':
    main()
