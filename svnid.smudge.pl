#! /usr/bin/perl
# gitfilters/svnid.smudge.pl   2017-9-18   Alan U. Kennington.
# (No keyword expansion here because of chicken-and-egg situation.)
# This script expands the embedded keyword $Id$ for Git.
# This is the version for Subversion-style times.
# Usage: svnid.smudge.pl %f

# Example output:
# $Id: gitfilters/README 79b816d 2017-09-16 10:03:55Z Alan U. Kennington $

my $trace_loc2utc = 0;

#------------------------------------------------------------------------------
# Convert a local date/time string to UTC with a Z.
#------------------------------------------------------------------------------
#-------------------#
#   localtime2utc   #
#-------------------#
sub localtime2utc {
    my ($localtime) = @_;
    if ($trace_loc2utc >= 10) {
        print "localtime2utc: input = \"$localtime\"\n";
        }
    # Should check here that the local time string is valid.
    # ....

    # Convert the time from Git-style to Subversion style.
    # Do it the hard way because Perl data-time parsing functions are scarce.
    my ($date, $time, $zone) = split / /, $localtime;
    if ($trace_loc2utc >= 10) {
        print "(date, time, zone) = (\"$date\", \"$time\", \"$zone\")\n";
        }
    my ($yr, $mo, $da) = split /-/, $date;
    if ($trace_loc2utc >= 10) {
        print "(year, month, day) = (\"$yr\", \"$mo\", \"$da\")\n";
        }
    my ($hr, $mi, $se) = split /:/, $time;
    if ($trace_loc2utc >= 10) {
        print "(hour, minute, second) = (\"$hr\", \"$mi\", \"$se\")\n";
        }
    my $zo = $zone + 0;
    if ($trace_loc2utc >= 10) {
        print "zone integer = $zo\n";
        }
    my $zonesign = 1;
    if ($zo < 0) {
        $zonesign = -1;
        $zo = -$zo;
        }
    if ($trace_loc2utc >= 10) {
        print "zone sign/value = $zonesign/$zo\n";
        }
    my $zhour = int($zo/100);
    my $zmin = $zo - $zhour * 100;
    if ($trace_loc2utc >= 10) {
        print "zone sign/hour/min = $zonesign/$zhour/$zmin\n";
        }
    # Assume the Gregorian calendar for all time!
    my @mdays = (
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
        );
    # my @mdays_leap = (
    #     31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    #     );
    # Correction for leap years. Assume positive year!
    my $leap = 0;
    if (($yr % 4) == 0) {
        $leap = 1;
        if (($yr % 100) == 0) {
            $leap = 0;
            if (($yr % 400) == 0) {
                $leap = 1;
                }
            }
        }
    $mdays[1] += $leap;
    if ($trace_loc2utc >= 10) {
        print "leap = $leap\n";
        }
    if ($zonesign < 0 && ($zhour > 0 || $zmin > 0)) {
        # Advance the zone hours and minutes to UTC.
        $hr += $zhour;
        $mi += $zmin;
        # Normalise the time and date.
        if ($mi >= 60) {
            $mi -= 60;
            $hr += 1;
            }
        if ($hr >= 24) {
            $hr -= 24;
            $da += 1;
            if ($da > $mdays[$mo - 1]) {
                $da -= $mdays[$mo - 1];
                $mo += 1;
                if ($mo > 12) {
                    $mo -= 12;
                    $yr += 1;
                    }
                }
            }
        }
    if ($zonesign > 0 && ($zhour > 0 || $zmin > 0)) {
        # Reverse the zone hours and minutes to UTC.
        $hr -= $zhour;
        $mi -= $zmin;
        # Normalise the time and date.
        if ($mi < 0) {
            $hr -= 1;
            $mi += 60;
            }
        if ($hr < 0) {
            $da -= 1;
            $hr += 24;
            if ($da <= 0) {
                $mo -= 1;
                if ($mo <= 0) {
                    $mo += 12;
                    $yr -= 1;
                    }
                $da += $mdays[$mo - 1];
                }
            }
        }
    if ($trace_loc2utc >= 10) {
        print "(year, month, day) = (\"$yr\", \"$mo\", \"$da\")\n";
        print "(hour, minute, second) = (\"$hr\", \"$mi\", \"$se\")\n";
        }
    return sprintf("%04u-%02u-%02u %02u:%02u:%02uZ",
        $yr, $mo, $da, $hr, $mi, $se);
    } # End of function localtime2utc.

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
my $cmd_h = "git log --pretty=format:\"%h\" -1 -- $f";
my $cmd_ai = "git log --pretty=format:\"%ai\" -1 -- $f";
my $cmd_an = "git log --pretty=format:\"%an\" -1 -- $f";

# print "cmd = \"$cmd\"\n";

my $x_h = `$cmd_h`;
my $x_ai = `$cmd_ai`;
my $x_an = `$cmd_an`;

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

# $z2 = "$z\$$z";
# print "z2 = \"$z2\"\n";
# $z2 =~ s/\$/\\\$/g;
# print "z2 = \"$z2\"\n";

#------------------------------------------------------------------------------
# Convert the timestamp from Git to Subversion style.
# my $testdate = "2000-01-01 03:05:34 +1030";
# my $testutc = localtime2utc($testdate);
# print "testdate = \"$testdate\"\n";
# print "testutc  = \"$testutc\"\n";

my $utctime = localtime2utc($x_ai);
# print "utctime = \"$utctime\"\n";

my $x = "$x_h $utctime $x_an";
# print "x = \"$x\"\n";

# Apply the hash/datetime/author string to the standard input.
$cmd = "sed 's/\\\$Id\\\$/\$Id: $z $x \$/g'";
# print "cmd = \"$cmd\"\n";

system($cmd);

__END__
