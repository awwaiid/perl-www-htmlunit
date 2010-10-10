package WWW::HtmlUnit::Sweet;

=head1 NAME

WWW::HtmlUnit::Sweet - Wrapper around WWW::HtmlUnit to add some sweetness

=head1 SYNOPSIS

	use WWW::HtmlUnit::Sweet;
	my $agent = WWW::HtmlUnit::Sweet->new;
  
  $agent->getPage('http://google.com/');

  # Type into the currently focused element
  $agent->type

=head1 DESCRIPTION

Using L<Test::WWW::Mechanize> as a foundation, this adds LSI specific testing tools.

=cut

use strict;
use warnings;

use UNIVERSAL qw/isa can/;

# This will be removed once WWW:HtmlUnit supports quiet-mode
my $saved_stderr;
our $error_output;
BEGIN {
	my $hide_errors = 1;
	if($hide_errors) {
		open $saved_stderr, '>&STDERR';
		close STDERR;
		open STDERR, '>', \$error_output;
		eval "use WWW::HtmlUnit";
		*STDERR = $saved_stderr;
	} else {
		eval "use WWW::HtmlUnit";
	}
}
# It would normally be just:
# use WWW::HtmlUnit;

sub new {
	my $class = shift;
	my $self = { @_ };
	bless $self, $class;
	$self->{browser} = WWW::HtmlUnit->new;
	return $self;
}

our $default_timeout = 30;

sub wait_for(&@) {
  my ($subref, $timeout) = @_;
  $timeout ||= $default_timeout;
  while($timeout) {
    return if eval { $subref->() };
    sleep 1;
    $timeout--;
  }
  die "Timeout!\n";
}

# This will make us act a bit more like Mechanize
sub AUTOLOAD {
	my $self = shift;
	our $AUTOLOAD;
	my $method = $AUTOLOAD; $method =~ s/.*:://;
	return if $method eq 'DESTROY';
	my $retval = eval {
		if($self->{browser}->can($method)) {
			return $self->{browser}->$method(@_);
		} elsif($self->{browser}->getCurrentWindow->can($method)) {
			return $self->{browser}->getCurrentWindow->$method(@_);
		} elsif($self->{browser}->getCurrentWindow->getEnclosedPage->can($method)) {
			return $self->{browser}->getCurrentWindow->getEnclosedPage->$method(@_);
		} else {
			die "Method $method not found!";
		}
	};
	if($@ && ref($@) =~ /Exception/) {
		print STDERR "HtmlUnit ERROR: " . $@->getMessage . "\n";
		die $@; # Pass it up the chain
	} elsif($@) {
		warn $@;
	}
	return $retval;
}

=head2 $agent->type

(Convenience function) Type into the currently focused element.

=cut

sub type {
	my $self = shift;
	return $self->getFocusedElement->type(@_);
}

package WWW::HtmlUnit::com::gargoylesoftware::htmlunit::html::HtmlSelect;

sub get_option {
	my ($self, %params) = @_;
	if($params{text}) {
		return eval {$self->getOptionByText($params{text})};
	} elsif($params{value}) {
		return eval {$self->getOptionByValue($params{value})};
	}
	die "Must pass either text or value";
}

1;

