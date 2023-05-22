#!/usr/bin/perl

use 5.014002;
use warnings;

eval "use Test::PAUSE::Permissions";
 
BEGIN { $ENV{RELEASE_TESTING} = 1; }

all_permissions_ok ("HMBRAND");
