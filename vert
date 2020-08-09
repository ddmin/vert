#!/usr/bin/python3

# vert: conjugation practice tool

# system
import sys

# webscraping
import requests
from bs4 import BeautifulSoup

# A E S T H E T I C
from rich import print as rprint
from rich.console import Console
from rich.table import Table

names = [
            'Présent',
            'Imparfait',
            'Futur',
            'Passé Composé',
            'Plus que Parfait',
            'Futur Antérieur',
            'Subjonctif Présent',
            'Subjonctif Passé',
            'Conditionnel Présent',
            'Conditionnel Passé'
        ]

pronoun = [
            'Je',
            'Tu',
            'Il/Elle/On',
            'Nous',
            'Vous',
            'Ils/Elles'
        ]

colors = [
            '#ff0000',
            '#ffa500',
            '#ffff00',
            '#90ee90',
            '#00ff00',
            '#add8e6',
            '#87ceeb',
            '#ffc0cb',
            '#ee82ee',
            '#ffffff'
        ]

def get_infinitive(verb):
    link = f'https://conjugator.reverso.net/conjugation-french-verb-{verb}.html'
    r = requests.get(link).text
    soup = BeautifulSoup(r, 'lxml')
    infinitive = soup.find('a', {'class': 'targetted-word-transl'}).text

    return infinitive, soup

def get_conj(verb, soup):
    soup = soup.find('div', {'id': 'ch_divSimple'})
    blue = soup.find_all('div', {'class': 'blue-box-wrap'})

    tenses = [
                'Indicatif Présent',
                'Indicatif Imparfait',
                'Indicatif Futur',
                'Indicatif Passé composé',
                'Indicatif Plus-que-parfait',
                'Indicatif Futur antérieur',
                'Subjonctif Présent',
                'Subjonctif Passé',
                'Conditionnel Présent',
                'Conditionnel Passé première forme'
            ]

    verbs = {}

    count = 0
    for x in blue:
        if x['mobile-title'] in tenses:

            a = x.find_all('i')
            a = list(filter(lambda x: x.text != 'que ', a))
            a = list(filter(lambda x: x.text != "qu'", a))
            a = list(filter(lambda x: x['class'] != ['graytxt'], a))
            a = list(map(lambda x: x.text, a))

            if len(a) == 12:
                temp = []
                for i in range(6):
                    temp.append(a[2*i] + a[2*i + 1])
                a = temp

            elif len(a) == 16:
                temp = []
                for i in range(8):
                    temp.append(a[2*i] + a[2*i + 1])
                temp.pop(7)
                temp.pop(3)
                temp[2] += '(e)'
                temp[-1] = temp[-1][:-1] + '(e)s'
                a = temp

            elif len(a) == 28:
                temp = []
                for i in range(6, 14):
                    temp.append(a[2*i] + a[2*i + 1])
                temp.pop(7)
                temp.pop(3)
                temp[2] += '(e)'
                temp[-1] = temp[-1][:-1] + '(e)s'
                a = temp

            y = names[count]

            verbs[y] = {pronoun[i]: a[i] for i in range(6)}
            count += 1

    return verbs

def format_table(verb, conj):
    table = Table(title = f'{verb} Conjugation')

    table.add_column('', style='magenta')

    for n, c in zip(names, colors):
        table.add_column(n, justify='left', style=c)

    for p in pronoun:
        table.add_row(p, conj[names[0]][p], conj[names[1]][p], conj[names[2]][p], conj[names[3]][p], conj[names[4]][p], conj[names[5]][p], conj[names[6]][p], conj[names[7]][p], conj[names[8]][p], conj[names[9]][p])

    console = Console()
    console.print(table)

def info():
        rprint('[#90ee90]vert[/#90ee90]: french conjugation terminal utility\n')
        rprint('usage: [#90ee90]vert[/#90ee90] [#ffc0cb][-c] \[verb][/#ffc0cb] [#87ceeb][-q] \[list][/#87ceeb] [-h]\n')
        rprint('-h           : display this message and exit')
        rprint('[#ffc0cb]-c[/#ffc0cb]           : conjugation mode')
        rprint('    verb     : verb to conjugate')
        rprint('[#87ceeb]-q[/#87ceeb]           : quiz mode')
        rprint('    list     : list to use for quiz')

def main():
    if len(sys.argv) < 3:
        info()
        sys.exit()

    elif '-h' in sys.argv:
        info()
        sys.exit()

    elif '-q' in sys.argv:
        lst = sys.argv[sys.argv.index('-q') + 1]
        print('Quiz Mode')
        print(lst)

    elif '-c' in sys.argv:
        verb = sys.argv[sys.argv.index('-c') + 1]
        inf, soup = get_infinitive(verb)

        # can't be bothered to handle this exceptions
        if inf == 'falloir':
            table = Table(title = f'{inf} Conjugation')

            table.add_column('', style='magenta')

            for n, c in zip(names, colors):
                table.add_column(n, justify='left', style=c)

            table.add_row('Il', 'faut', 'fallait', 'faudra', 'a fallu', 'avait fallu', 'aura fallu', 'faille', 'ait fallu', 'faudrait', 'aurait fallu')

            console = Console()
            console.print(table)
            sys.exit()

        conj = get_conj(verb, soup)

        # so many exceptions
        if inf  == 'pouvoir':
            conj['Présent'] = {'Je': 'peux', 'Tu': 'peux', 'Il/Elle/On': 'peut', 'Nous': 'pouvons', 'Vous': 'pouvez', 'Ils/Elles': 'peuvent'}

        format_table(inf, conj)

    else:
        info()
        sys.exit()

if __name__ == '__main__':
    main()
