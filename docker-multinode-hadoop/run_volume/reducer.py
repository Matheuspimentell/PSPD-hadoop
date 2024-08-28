#!/usr/bin/python3

import sys

palavra_anterior = None
count_anterior = 0
palavra = None

total_palavras = 0

for linha in sys.stdin:
    linha = linha.strip()  # Remove espaços em branco
    palavra, count = linha.split("\t", 1)  # Pega o que foi passado pelo mapper.py
    # Tenta converter o count string para um inteiro
    try:
        count = int(count)
    except ValueError:  # Se o valor de count não for int ignora e continua
        continue

    total_palavras += count

    if palavra == palavra_anterior:  # Este if só funciona p entradas ordenadas
        count_anterior += count  # (No Hadoop o shuffler faz esse trabalho)
    else:
        if palavra_anterior:
            print(
                ("%s\t%s") % (palavra_anterior, count_anterior)
            )  # Escreve o resultado na saída
        count_anterior = count
        palavra_anterior = palavra

if palavra == palavra_anterior:
    print(("%s\t%s") % (palavra_anterior, count_anterior))

print("Total de palavras processadas: %s" % total_palavras)
