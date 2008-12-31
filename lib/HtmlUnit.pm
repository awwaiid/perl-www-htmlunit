package HtmlUnit;

=head1 NAME

HtmlUnit - Inline::Java based wrapper of the HtmlUnit library

=head1 SYNOPSIS

  use HtmlUnit;
  my $webClient = HtmlUnit->new('FIREFOX_3');
  my $page = $webClient->getPage("http://google.com/");
  my $f = $page->getFormByName('f');
  my $submit = $f->getInputByName("btnG");
  my $query  = $f->getInputByName("q");
  $page = $query->type("HtmlUnit");
  $page = $query->type("\n");

  my $content = $page->asXml;
  print "Result:\n$content\n\n";

=head1 DESCRIPTION

This is a wrapper around the HtmlUnit library. It includes the HtmlUnit jar
itself and it's dependencies. All this library really does is find the jars and
load them up using Inline::Java.

The reason all this is interesting? HtmlUnit has very good javascript support,
so you can automate, scrape, or test javascript-required websites.

=cut

use strict;
use warnings;

our $VERSION = '0.03';

use File::Find;
use vars qw( $jar_path );

sub find_jar_path {
    my $self = shift;
    my $module = 'HtmlUnit';
    $module =~ s/\*$/.*/;

    my $found = {};
    my @module_path;
    find {
        wanted => sub {
            my $path = $File::Find::name;
            return if -d $_;
            push @module_path, $path if $path =~ /[\\\/]$module.pm$/i;
        },
    }, grep {-d $_ and $_ ne '.'} @INC;
    #print "Mod path: @module_path\n";
    my $path = shift @module_path;
    $path =~ s/\/$module.pm$//;
    $path = "$path/HtmlUnit/jar";
    #print "Path: $path\n";
    return $path;
}


BEGIN {
  $jar_path = find_jar_path();
}

use Inline (
  Java => 'STUDY',
  STUDY => [
    'com.gargoylesoftware.htmlunit.WebClient',
    'com.gargoylesoftware.htmlunit.BrowserVersion',
  ],
  AUTOSTUDY => 1,
  CLASSPATH => join ':', map { "$jar_path/$_" } qw(
    commons-codec-1.3.jar
    commons-collections-3.2.1.jar
    commons-httpclient-3.1.jar
    commons-io-1.4.jar
    commons-lang-2.4.jar
    commons-logging-1.1.1.jar
    cssparser-0.9.5.jar
    htmlunit-2.4.jar
    htmlunit-core-js-2.4.jar
    nekohtml-1.9.11.jar
    sac-1.3.jar
    serializer-2.7.1.jar
    xalan-2.7.1.jar
    xercesImpl-2.8.1.jar
    xml-apis-1.3.04.jar
  ),
);

=head1 METHODS

=head2 $webClient = HtmlUnit->new($browser_name)

This is just a shortcut for 

  $webClient = HtmlUnit::com::gargoylesoftware::htmlunit::WebClient->new;

The optional $browser_name allows you to specify which browser version to pass
to the WebClient->new method.

=cut

sub new {
  my ($class, $version) = @_;
  if($version) {
    my $browser_version = eval "\$HtmlUnit::com::gargoylesoftware::htmlunit::BrowserVersion::$version";
    return HtmlUnit::com::gargoylesoftware::htmlunit::WebClient->new($browser_version);
  } else {
    return HtmlUnit::com::gargoylesoftware::htmlunit::WebClient->new;
  }
}


=head1 SEE ALSO

L<http://htmlunit.sourceforge.net/>, L<Inline::Java>

=head1 AUTHOR

  Brock Wilcox <awwaiid@thelackthereof.org> - http://thelackthereof.org/

=head1 COPYRIGHT

  Copyright (c) 2008 Brock Wilcox <awwaiid@thelackthereof.org>. All rights
  reserved.  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself.

  HtmlUnit library includes the following copyright:

      Copyright (c) 2002-2008 Gargoyle Software Inc.

      Licensed under the Apache License, Version 2.0 (the "License");
      you may not use this file except in compliance with the License.
      You may obtain a copy of the License at
      http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      See the License for the specific language governing permissions and
      limitations under the License.

=cut

1;

