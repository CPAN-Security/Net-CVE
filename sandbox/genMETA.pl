#!/pro/bin/perl

use 5.014002;
use warnings;

use Getopt::Long qw(:config bundling nopermute);
GetOptions (
    "c|check"		=> \ my $check,
    "u|update!"		=> \ my $update,
    "v|verbose:1"	=> \(my $opt_v = 0),
    ) or die "usage: $0 [--check]\n";

use lib "sandbox";
use genMETA;
my $meta = genMETA->new (
    from    => "lib/Net/CVE.pm",
    verbose => $opt_v,
    );

$meta->from_data (<DATA>);
$meta->security_md ($update);
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
    HTTP::Tiny:          0.025
    Data::Dumper:        0
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
    Data::Dumper:        2.189
    HTTP::Tiny:          0.090
    IO::Socket::SSL:     2.089
    JSON::MaybeXS:       1.004008
test_recommends:
    Test::More:          1.302207
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
