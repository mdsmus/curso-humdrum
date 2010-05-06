#!/usr/bin/python

import re
from collections import defaultdict

note = re.compile("([a-gA-G]+)([n#-]*)")

def all_notes(file):
    with open(file) as f:
        tmp = []
        for line in f:
            if not line.startswith("!") and not line.startswith("=") and not line.startswith("*"):
                for item in line.split('\t'):
                    match = note.search(item)
                    if match:
                        n = match.group(1)
                        acc = match.group(2)
                        tmp.append("".join(set(n.lower())) + acc.replace("n", ""))
        return tmp


def count_notes(list_of_notes):
    dic = defaultdict(int)

    for item in list_of_notes:
        dic[item] += 1

    return dic


def print_count(file):
    dic = count_notes(all_notes(file))
    tmp = dic.items()
    tmp.sort(key=lambda x: x[1])
    print tmp


print_count("wtc-1/wtc1f01.krn")
