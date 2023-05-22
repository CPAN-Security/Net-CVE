#!/usr/bin/perl

use 5.014002;
use warnings;
use Test::More;

eval "use Test::Pod::Links";
plan skip_all => "Test::Pod::Links required for testing POD Links" if $@;
eval {
    no warnings "redefine";
    no warnings "once";
    *Test::XTFiles::all_files = sub { sort glob "lib/Net/*.pm"; };
    };
Test::Pod::Links->new->all_pod_files_ok;
