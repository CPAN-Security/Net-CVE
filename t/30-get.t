#!/usr/bin/perl

use 5.014002;
use warnings;

use Test::More;
use Test::Warnings;
use Test::MockObject;
use URI;

use Net::CVE;

ok (my $c1 = Net::CVE->new,		"New reporter");
ok ($c1->get ("CVE-2022-26928"),	"Read report with prefix");
ok (my $d1 = $c1->data,			"Generate data");
ok (my $s1 = $c1->summary,		"Generate summary");

ok (my $c2 = Net::CVE->new,		"New reporter");
ok ($c2->get ("2022-26928"),		"Read report without prefix");
ok (my $d2 = $c2->data,			"Generate data");
ok (my $s2 = $c2->summary,		"Generate summary");

isnt ($d1, $d2,				"Not the same data");
isnt ($s1, $s2,				"Not the same structure");

is_deeply ($d1, $d2,			"Same data content");
is_deeply ($s1, $s2,			"Same summary content");

is_deeply (Net::CVE->new->data ("CVE-2022-26928"), $d1, "Data direct");
is_deeply (Net::CVE->new->summary  ("2022-26928"), $s1, "Summary direct");

is_deeply (Net::CVE->new->get ("")->data, {},		"Empty fetch");

{
    my $url = "http://392.168.42.42/cve";
    my $ua  = HTTP::Tiny->new (agent => 'Net::CVE/1.00', SSL_verify => 1);
    my $nc  = Net::CVE->new (
	{   ua  => $ua,
	    url => $url,
	    });
    isa_ok ($nc, 'Net::CVE');
    is ($nc->{ua},  $ua,  "Custom user agent");
    is ($nc->{url}, $url, "Custom url");
    my $cve = $nc->get ("CVE-2022-26928");
    is_deeply (
	$cve->data ()->{containers}{cna}{descriptions}, [
	    {   value =>
		    "599 Internal Exception: Could not connect to \'392.168.42.42:80\': nodename nor servname provided, or not known\n"
		    }
	    ],
	"Internal error"
	)
	or diag (explain ($cve->data ()));
    }

{
    my $ua = Test::MockObject->new ();
    $ua->mock (
	get => sub {
	    my $self = shift;
	    my ($url) = URI->new (shift);
	    (my $cve = $url->path) =~ s{^ .+/ (?=CVE.+) }{}x;
	    open my $fh, "<:encoding(utf-8)",
		"Files/${cve}.json"
		or return {
		success => 0,
		status  => 404,
		reason  => 'NOT FOUND',
		content => undef,
		};
	    my $content = do { local $/; <$fh> };
	    close $fh;
	    return {
		success => 1,
		status  => 200,
		reason  => 'OK',
		content => $content,
		};
		});
    $ua->set_isa ("HTTP::Tiny");
    my $nc = Net::CVE->new ({ua => $ua});
    isa_ok ($nc, 'Net::CVE');
    is     ($nc->{ua}, $ua, "Custom user agent");
    my $cve = $nc->get ("CVE-2022-26928");
    is ($cve->data ()->{cveMetadata}{cveId},
	"CVE-2022-26928", "Found correct CVE")
	or diag (explain ($cve->data ()));

    $cve = $nc->get ("CVE-2038-26928");
    is_deeply (
	$cve->data ()->{containers}{cna}{descriptions},
	[{value => "404 NOT FOUND"}],
	"Not found ok"
	)
	or diag (explain ($cve->data ()));
    }

done_testing;
