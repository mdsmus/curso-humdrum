#!/usr/bin/python

import re
from collections import defaultdict


def parse_file(file):
    with open(file) as f:
        tmp = []
        for line in f:
            if not line.startswith("!") or not line.startswith("=") or not line.startswith("*"):
                tmp.append([item.strip('\n') for item in line.split('\t')])
        return tmp


def all_notes(filename):
    full = parse_file(filename)
    note = re.compile("([a-gA-G]+)([n#-]*)")
    tmp = []
    
    for line in full:
        for i in line:
            if i != ".":
                match = note.search(i)
                if match:
                    n = match.group(1)
                    acc = match.group(2)
                    if n != "r":
                        tmp.append("".join(set(n.lower())) + acc.replace("n", ""))
    tmp.sort()
    return tmp


def count_notes(list_of_notes):
    dic = defaultdict(int)

    for item in list_of_notes:
        dic[item] += 1

    return dic


dic = count_notes(all_notes("wtc-1/wtc1f01.krn"))
lst = [(dic[key], key) for key in dic]
lst.sort(key=lambda x: x[0])

