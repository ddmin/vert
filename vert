#!/usr/bin/python3

# vert: conjugation practice tool

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


def get_conj(verb):
    link = f'https://conjugator.reverso.net/conjugation-french-verb-{verb}.html'
    r = requests.get(link).text
    soup = BeautifulSoup(r, 'lxml')

    infinitive = soup.find('a', {'class': 'targetted-word-transl'}).text

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

    return infinitive, verbs

def format_table(verb, conj):
    table = Table(title = f'{verb} Conjugation')

    table.add_column('', style='cyan')

    colors = [
                '#ff0000',
                '#ffa500',
                '#ffff00',
                '#90ee90',
                '#00ff00',
                '#87ceeb',
                '#ffc0cb',
                '#ee82ee',
                '#a52a2a',
                '#ffffff'
            ]

    for n, c in zip(names, colors):
        table.add_column(n, justify='left', style=c)

    for p in pronoun:
        table.add_row(p, conj[names[0]][p], conj[names[1]][p], conj[names[2]][p], conj[names[3]][p], conj[names[4]][p], conj[names[5]][p], conj[names[6]][p], conj[names[7]][p], conj[names[8]][p], conj[names[9]][p])

    console = Console()
    console.print(table)

def main():
    print('Enter verb:')
    verb = input('> ')

    inf, conj = get_conj(verb)
    format_table(inf, conj)

if __name__ == '__main__':
    main()
