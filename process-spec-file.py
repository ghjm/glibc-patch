#!/bin/env python
import re

with open('SPECS/glibc.spec', 'r') as f:
    lines = [line.strip() for line in f]

# Change version number
re1 = re.compile('^\%define glibcrelease (\d+)\%\{\?dist\}')
for i in range(len(lines)):
    line = lines[i]
    m = re1.match(line)
    if m:
        lines[i] = '%define glibcrelease ' + m.groups()[0] + 'ghjm1' + \
            '%{?dist}'
        break

# Add patch
re2 = re.compile('^Patch(\d+)\:')
lpline = 0
lpnum = 0
for i in range(len(lines)):
    line = lines[i]
    m = re2.match(line)
    if m:
        lpline = i
        lpnum = int(m.groups()[0])
lines.insert(lpline+1, 'Patch' + str(lpnum+1) + ': ' +
        'glibc-Revert-elf-Correct-absolute-SHN_ABS-symbol-run-time.patch')

with open('SPECS/glibc.spec', 'w') as f:
    for line in lines:
        print >>f, line
