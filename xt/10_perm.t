#!/usr/bin/perl

use 5.014002;
use warnings;
use Test::More;

BEGIN { $ENV{RELEASE_TESTING} = 1; }

eval "use Test::PAUSE::Permissions" if $ENV{RELEASE_TESTING};

plan skip_all => "Test::PAUSE::Permissions required for this test" if $@;

all_permissions_ok ("HMBRAND");

done_testing;
