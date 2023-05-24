#!/usr/bin/perl

use 5.014002;
use warnings;

use Test::More;
use Test::Warnings;

use Net::CVE;

my $bad = "XYZ-2-BAZ";
my @w;

local $SIG{__WARN__} = sub { push @w => @_ };

my $r = Net::CVE->new->get ($bad);
is_deeply ($r->data, {}, "Bad CVE");
is_deeply ($r->diag, {
    status => -1,
    reason => "Invalid CVE format: '$bad'",
    action => "get",
    url    => undef,
    usage  => 'get ("CVE-2022-26928")',
    }, "Got diagnostics");

# TODO: autodiag
#is (scalar @w, 1,	"Got warning");
#is ($w[0], "Invalid CVE format: '$bad' - expected format CVE-2023-12345\n", "Error");

eval { Net::CVE->new->get ($0) };
like ($@, qr{^malformed JSON}, "$0 is not valid JSON");

done_testing;
