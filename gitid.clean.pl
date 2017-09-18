#! /usr/bin/perl
# gitfilters/gitid.clean.pl   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# This script de-expands the embedded keyword $Id$ for Git.
# This is the version for Git-style times.
# Usage: gitid.clean.pl

# Example input:
# $Id: gitfilters/README 79b816d 2017-09-16 19:03:55 +1000 Alan U. Kennington $

# "sed -r" uses extended regular expressions.
my $cmd = "sed -r " .
 "'s/\\\$Id: .*[0-9]{2}:[0-9]{2}:[0-9]{2} *[-+][0-9]{4} .* \\\$/\$Id\$/g'";
# print "cmd = \"$cmd\"\n";

system($cmd);

__END__
