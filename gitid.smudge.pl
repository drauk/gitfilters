#! /usr/bin/perl
# gitfilters/gitid.smudge.pl   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# This script expands the embedded keyword $Id$ for Git.
# This is the version for Git-style times.
# Usage: gitid.smudge.pl %f

# Example output:
# $Id: gitfilters/README 79b816d 2017-09-16 19:03:55 +1000 Alan U. Kennington $

my $n_args = $#ARGV + 1;
if ($n_args != 1) {
    print STDERR "Usage: $0 %f\n";
    exit(1);
    }
# The file to be filtered.
my $f = $ARGV[0];
# print "f = $f\n";

# This script is apparently called from the top working directory.
# So for git log, use the full relative path $f of the file %f.
my $cmd = "git log --pretty=format:\"%h %ai %an\" -1 -- $f";
# print "cmd = \"$cmd\"\n";

my $x = `$cmd`;
# print "x = \"$x\"\n";

# Use the tail of the path because "/" is forbidden in "s///".
# my @names = split /\//, $f;
# my $n_names = $#names;
# my $t = $names[$n_names];
# # print "names[$n_names] = \"$t\"\n";

# Substitute \/ for / so that the sed s-pattern will be correct.
my $z = $f;
$z =~ s/\//\\\//g;
$z =~ s/\$/\\\$/g;
# print "z = \"$z\"\n";

$cmd = "sed 's/\\\$Id\\\$/\$Id: $z $x \$/g'";
# print "cmd = \"$cmd\"\n";

system($cmd);

__END__
