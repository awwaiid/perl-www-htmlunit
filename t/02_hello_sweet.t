#!/usr/bin/perl

use strict;
use WWW::HtmlUnit::Sweet;
use Test::More tests => 1;

my $agent = WWW::HtmlUnit::Sweet->new(
  url => 'file:t/02_hello_sweet.html'
);

my $result = $agent->asXml;

like $result, qr/<h1>\s*Hello!\s*<\/h1>/, 'Found printed Hello';

