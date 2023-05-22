#!/usr/bin/perl

use 5.014002;
use warnings;
use Test::More;

eval "use Test::MinimumVersion";
if ($@) {
    print "1..0 # Test::MinimumVersion required for compatability tests\n";
    exit 0;
    }

all_minimum_version_ok ("5.014.002", { paths => [
    glob ("t/*"), glob ("xt/*"), glob ("lib/Net/*"), glob ("*.PL"),
    ]});

done_testing ();
