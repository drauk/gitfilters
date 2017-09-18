#! /usr/bin/csh -f
# gitfilters/akfilter.clean.csh   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# Remove Git keyword expansions.

# "sed -r" or "sed --regexp-extended" uses extended regular expressions.
sed -r 's/\$Id: .*[0-9]{2}:[0-9]{2}:[0-9]{2} *[-+][0-9]{4} .* \$/$Id$/g'
