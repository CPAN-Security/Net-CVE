# NAME

Net::CVE - Fetch CVE (Common Vulnerabilities and Exposures) information from cve.org

# SYNOPSIS

    use Net::CVE;

    my $cr = Net::CVE->new ();

    $cr->get ("CVE-2022-26928");
    my $full_report = $cr->data;
    my $summary     = $cr->summary;

    $cr->diag;

    use Data::Peek;
    DDumper $cr->summary ("CVE-2022-26928");

# DESCRIPTION

This module provides a Perl interface to retrieve information from the
[CVE database](https://www.cve.org/Downloads) provided by [https://cve.org](https://cve.org)
based on a CVE tag.

# METHODS

## new

    my $reporter = CVE->new (
        url  => "https://cveawg.mitre.org/api/cve",
        ua   => undef,
        lang => "en",
        );

Instantiates a new object. All attributes are optional.

- url

    Base url for REST API

- ua

    User agent. Needs to know about `->get`. Defaults to [HTTP::Tiny](https://metacpan.org/pod/HTTP%3A%3ATiny).
    Initialized on first use.

        my $reporter = CVE->new (ua => HTTP::Tiny->new);

    Other agents not yet tested, so they might fail.

- lang

    Set preferred language for ["summary"](#summary). Defaults to `en`.

    If the preferred language is present in descriptions use that. If it is not, use
    `en`. If that is also not present, use the first language found.

## get

    $reporter->get ("CVE-2022-26928");
    $reporter->get ("2022-26928");
    $reporter->get ("Files/CVE-2022-26928.json");

Fetches the CVE data for a given tag. On success stores the results internally.
Returns the object. The leading `CVE-` is optional.

If the argument is a non-empty file, that is parsed instead of fetching the
information from the internet.

The decoded information is stored internally and will be re-used for other
methods.

`get` returns the object and allows to omit a call to `new` which will be
implicit but does not allow attributes

    my $reporter = Net::CVE->get ("2022-26928");

is a shortcut to

    my $reporter = Net::CVE->new->get ("2022-26928");

## data

    my $info = $reporter->data;

Returns the data structure from the last successful fetch, `undef` if none.

Giving an argument enables you to skip the ["get"](#get) call, which is implicit, so

    my $info = $reporter->data ("CVE-2022-26928");

is identical to

    my $info = $reporter->get ("CVE-2022-26928")->data;

or

    $reporter->get ("CVE-2022-26928");
    my $info = $reporter->data;

or even, without an object

    my $info = Net::CVE->data ("CVE-2022-26928");

## summary

    my $info = $reporter->summary;
    my $info = $reporter->summary ("CVE-2022-26928");

Returns a hashref with basic information from the last successful fetch,
`undef` if none.

Giving an argument enables you to skip the ["get"](#get) call, which is implicit, so

    my $info = $reporter->summary ("CVE-2022-26928");

is identical to

    my $info = $reporter->get ("CVE-2022-26928")->summary;

or

    $reporter->get ("CVE-2022-26928");
    my $info = $reporter->summary;

or even, without an object

    my $info = Net::CVE->summary ("CVE-2022-26928");

The returned hash looks somewhat like this

    { date        => "2022-09-13T18:41:25",
      description => "Windows Photo Import API Elevation of Privilege Vulnerability",
      id          => "CVE-2022-26928",
      problem     => "Elevation of Privilege",
      score       => "7",
      severity    => "high",
      status       => "PUBLISHED",
      vendor      => [ "Microsoft" ]
      platforms   => [ "32-bit Systems",
          "ARM64-based Systems",
          "x64-based Systems",
          ],
      product     => [
          "Windows 10 Version 1507",
          "Windows 10 Version 1607",
          "Windows 10 Version 1809",
          "Windows 10 Version 20H2",
          "Windows 10 Version 21H1",
          "Windows 10 Version 21H2",
          "Windows 11 version 21H2",
          "Windows Server 2016",
          "Windows Server 2019",
          "Windows Server 2022",
          ],
      }

As this is work in progress, likely to be changed

## status

    my $status = $reporter->status;

Returns the status of the CVE, most likely `PUBLISHED`.

## vendor

    my @vendor  = $reporter->vendor;
    my $vendors = $reporter->vendor;

Returns the list of vendors for the affected parts of the CVE. In scalar
context a string where the (sorted) list of unique vendors is joined by
`, ` in list context the (sorted) list itself.

## product

    my @product  = $reporter->product;
    my $products = $reporter->product;

Returns the list of products for the affected parts of the CVE. In scalar
context a string where the (sorted) list of unique products is joined by
`, ` in list context the (sorted) list itself.

## platforms

    my @platform  = $reporter->platforms;
    my $platforms = $reporter->platforms;

Returns the list of platforms for the affected parts of the CVE. In scalar
context a string where the (sorted) list of unique platforms is joined by
`, ` in list context the (sorted) list itself.

## diag

    $reporter->diag;
    my $diag = $reporter->diag;

If an error occurred, returns information about the error. In void context
prints the diagnostics using `warn`. The diagnostics - if any - will be
returned in a hashref with the following fields:

- status

    Status code

- reason

    Failure reason

- action

    Tag of where the failure occurred

- source

    The URL or filename leading to the failure

- usage

    Help message

Only the `action` field is guaranteed to be set, all others are optional.

# BUGS

None so far

# TODO

- Better error reporting

    Obviously

- Tests

    There are none yet

- Meta-stuff

    Readme, Changelog, Makefile.PL, ...

- Fallback to Net::NVD

    Optionally. It does not (yet) provide vendor, product and platforms.
    It however provides nice search capabilities.

- RHSA support

    Extend to return results for `RHSA-2023:1791` type vulnerability tags.

        https://access.redhat.com/errata/RHSA-2023:1791
        https://access.redhat.com/hydra/rest/securitydata/crf/RHSA-2023:1791.json

    The CRF API provides the list of CVE's related to this tag:

        my $url = "https://access.redhat.com/hydra/rest/securitydata/crf";
        my $crf = decode_json ($ua->get ("$url/RHSA-2023:1791.json"));
        my @cve = map { $_->{cve} }
                  @{$crf->{cvrfdoc}{vulnerability} || []}

    Will set `@cve` to

        qw( CVE-2023-1945  CVE-2023-1999  CVE-2023-29533 CVE-2023-29535
            CVE-2023-29536 CVE-2023-29539 CVE-2023-29541 CVE-2023-29548
            CVE-2023-29550 );

    See [the API documentation](https://access.redhat.com/documentation/en-us/red_hat_security_data_api/1.0/html-single/red_hat_security_data_api/index).

# SEE ALSO

- CVE search

    [https://cve.org](https://cve.org) and [https://cve.mitre.org/cve/search\_cve\_list.html](https://cve.mitre.org/cve/search_cve_list.html)

- [Net::OSV](https://metacpan.org/pod/Net%3A%3AOSV)

    Returns OpenSource Vulnerabilities.

- CVE database

    [https://www.cvedetails.com/](https://www.cvedetails.com/)

# AUTHOR

H.Merijn Brand <hmbrand@cpan.org>

# COPYRIGHT AND LICENSE

Copyright (C) 2023-2023 H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic).

This interface uses data from the CVE API but is not endorsed by any
of the CVE partners.

# DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
