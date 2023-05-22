#!/usr/bin/perl

use 5.014002;
use warnings;

use Test::More;
use Test::Warnings;

use Net::CVE;

my $v = $Net::CVE::VERSION or BAIL_OUT ("Net::CVE does not return a VERSION");

ok  ($v,			"Net::CVE-$v");

ok  (my $cr = Net::CVE->new,	"New reporter");
isa_ok ($cr, "Net::CVE",	"Of class Net::CVE");

done_testing;
