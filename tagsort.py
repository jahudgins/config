import sys

with open(sys.argv[1], 'rt', encoding='latin-1') as f:
    lines = f.readlines()

lines.sort()

with open(sys.argv[2], 'wt', encoding='latin-1') as f:
    for line in lines:
        f.write(line)


