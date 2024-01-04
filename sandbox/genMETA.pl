#!/pro/bin/perl

use 5.014002;
use warnings;

use Getopt::Long qw(:config bundling nopermute);
my $check = 0;
my $opt_v = 0;
GetOptions (
    "c|check"		=> \$check,
    "v|verbose:1"	=> \$opt_v,
    ) or die "usage: $0 [--check]\n";

use lib "sandbox";
use genMETA;
my $meta = genMETA->new (
    from    => "lib/Net/CVE.pm",
    verbose => $opt_v,
    );

$meta->from_data (<DATA>);
$meta->gen_cpanfile ();

if ($check) {
    $meta->check_encoding ();
    $meta->check_required ();
    $meta->check_minimum ([ "lib", "scripts" ]);
    $meta->done_testing ();
    }
elsif ($opt_v) {
    $meta->print_yaml ();
    }
else {
    $meta->fix_meta ();
    }

__END__
--- #YAML:1.0
name:                    Net-CVE
version:                 VERSION
abstract:                Fetch CVE information from cve.org
license:                 perl
author:
    - H.Merijn Brand <hmbrand@cpan.org>
generated_by:            Author
distribution_type:       module
provides:
    Net::CVE:
        file:            lib/Net/CVE.pm
        version:         VERSION
requires:
    perl:                5.014002
    Carp:                0
    HTTP::Tiny:          0.009
    IO::Socket::SSL:     1.42
    JSON::MaybeXS:       1.004005
    List::Util:          0
configure_requires:
    ExtUtils::MakeMaker: 0
build_requires:
    perl:                5.014002
test_requires:
    Test::More:          0.90
    Test::Warnings:      0
configure_recommends:
    ExtUtils::MakeMaker: 7.22
recommends:
    Data::Peek:          0.52
    HTTP::Tiny:          0.088
    IO::Socket::SSL:     2.084
test_recommends:
    Test::More:          1.302198
configure_suggests:
    ExtUtils::MakeMaker: 7.70
resources:
    license:             http://dev.perl.org/licenses/
    repository:          https://github.com/CPAN-Security/Net-CVE
    bugtracker:          https://github.com/CPAN-Security/Net-CVE/issues
    IRC:                 irc://irc.perl.org/#metacpan
meta-spec:
    version:             1.4
    url:                 http://module-build.sourceforge.net/META-spec-v1.4.html
