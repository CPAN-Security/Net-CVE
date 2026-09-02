requires   "Carp";
requires   "Data::Dumper";
requires   "HTTP::Tiny"               => "0.025";
requires   "IO::Socket::SSL"          => "1.42";
requires   "JSON::MaybeXS"            => "1.004005";
requires   "List::Util";

recommends "Data::Dumper"             => "2.192";
recommends "Data::Peek"               => "0.54";
recommends "HTTP::Tiny"               => "0.096";
recommends "IO::Socket::SSL"          => "2.099";
recommends "JSON::MaybeXS"            => "1.004008";

on "configure" => sub {
    requires   "ExtUtils::MakeMaker";

    recommends "ExtUtils::MakeMaker"      => "7.22";

    suggests   "ExtUtils::MakeMaker"      => "7.78";
    };

on "test" => sub {
    requires   "Test::More"               => "0.90";
    requires   "Test::Warnings";

    recommends "Test::More"               => "1.302224";
    };
