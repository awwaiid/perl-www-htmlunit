#!/usr/bin/perl

use strict;
use WWW::HtmlUnit;
use Test::More tests => 1;

my $webClient = WWW::HtmlUnit->new('FIREFOX_3');
my $page = $webClient->getPage("file:t/hello.html");
my $result = $page->asXml;

like $result, qr/<h1>\s*Hello!\s*<\/h1>/, 'Found printed Hello';

