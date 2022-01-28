package Dist::Zilla::Plugin::MinimumPerlFast;

use strict;
use warnings;

use Moose;

use Carp 'croak';
use MooseX::Types::Perl 0.101340 qw( StrictVersionStr );
use Perl::MinimumVersion::Fast;
use List::Util qw/max/;

with(
	'Dist::Zilla::Role::PrereqSource' => { -version => '4.102345' },
	'Dist::Zilla::Role::FileFinderUser' => {
		finder_arg_names => [ 'configure_finder' ],
		method => 'found_configure',
		default_finders => [ ':IncModules' ]
	},
	'Dist::Zilla::Role::FileFinderUser' => {
		finder_arg_names => [ 'runtime_finder' ],
		method => 'found_runtime',
		default_finders => [ ':InstallModules', ':ExecFiles' ]
	},
	'Dist::Zilla::Role::FileFinderUser' => {
		finder_arg_names => [ 'test_finder' ],
		method => 'found_tests',
		default_finders => [ ':TestFiles' ]
	},
);

has version => (
	is      => 'ro',
	lazy    => 1,
	isa     => StrictVersionStr,
	builder => '_build_version',
);

has default_version => (
	is      => 'ro',
	lazy    => 1,
	isa     => StrictVersionStr,
	default => '5.008'
);

sub _build_version {
	my $self = shift;
	my @files = ( @{ $self->found_runtime }, @{ $self->found_configure }, grep { /\.(t|pm)$/ } @{ $self->found_tests } );
	return max($self->default_version, map { Perl::MinimumVersion::Fast->new(\$_->content)->minimum_version->numify } @files);
}

sub register_prereqs {
	my $self = shift;
	$self->zilla->register_prereqs({ phase => 'runtime' }, perl => $self->version);
	return;
}

no Moose;

1;

# ABSTRACT: Quickly detects the minimum version of Perl required for your dist

=head1 DESCRIPTION

This plugin uses L<Perl::MinimumVersion::Fast> to automatically find the minimum version of Perl required for your dist and adds it to the prereqs.

 # In your dist.ini:
 [MinimumPerlFast]

This plugin will search for files matching C</\.(t|pl|pm)$/i> in the C<lib/>, C<bin/>, and C<t/> directories.

=attr version

The minimum version of perl for this module. Determining this is the reason for existence of this module, but if necessary this can easily be overridden.

=attr default_version

The minimum version that is used if no minimum can be detected. By default it's C<5.008> because that's the oldest that C<Perl::MinimumVersion::Fast> can detect.

=head1 SEE ALSO
Dist::Zilla

=cut

