#! /usr/bin/csh -f
# gitfilters/akfilter.smudge.csh   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# Add Git keyword expansions.

set n = $#argv
if ($n != 1) then
    echo $0 " requires 1 argument"
    exit(1)
    endif
set f = $1
# echo `pwd` >> ~/tmp/gittrace.txt
# echo f = $f >> ~/tmp/gittrace.txt

# This script is apparently called from the top working directory.
# So for git log, use the full relative path $f of the file %f.
set x = `git log --pretty=format:"%h %ai %an" -1 -- $f`
# echo x = $x >> ~/tmp/gittrace.txt

# Use the tail of the path because "/" is forbidden in "s///".
# set t = $f:t

# Substitute \/ for / so that the sed s-pattern will be correct.
set z = `echo $f | sed 's/\//\\\//g'`
sed 's/\$Id\$/$Id: '"$z $x"' $/g'
