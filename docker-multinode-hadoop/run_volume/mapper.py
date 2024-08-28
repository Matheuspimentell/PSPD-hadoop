#!/usr/bin/python3

import sys

for linha in sys.stdin:
    linha = linha.strip()
    palavras = linha.split()
    for count in palavras:
        print(("%s\t%s") % (count, 1))
