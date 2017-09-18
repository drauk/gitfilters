#! /usr/bin/perl
# gitfilters/svnid.clean.pl   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# This script de-expands the embedded keyword $Id$ for Git.
# This is the version for Subversion-style times.
# Usage: svnid.clean.pl

# Example input:
# $Id: gitfilters/README 79b816d 2017-09-16 10:03:55Z Alan U. Kennington $

# "sed -r" uses extended regular expressions.
my $cmd = "sed -r 's/\\\$Id: .*[0-9]{2}:[0-9]{2}:[0-9]{2}Z .* \\\$/\$Id\$/g'";
# print "cmd = \"$cmd\"\n";

system($cmd);

__END__
