package Dist::Zilla::Plugin::MinimumPerlFast;
use strict;
use warnings;

use Moose;

use MooseX::Types::Perl 0.101340 qw( LaxVersionStr );
use Perl::MinimumVersion::Fast;
use List::Util 'max';

with(
	'Dist::Zilla::Role::PrereqSource' => { -version => '4.102345' },
	'Dist::Zilla::Role::FileFinderUser' => {
		-version => '4.102345',
		default_finders => [ ':InstallModules', ':ExecFiles', ':TestFiles' ]
	},
);

has perl => (
	is      => 'ro',
	lazy    => 1,
	isa     => 'version',
	builder => '_build_perl',
);

sub _build_perl {
	my $self = shift;
	return max map { Perl::MinimumVersion::Fast->new(\$_->content)->minimum_version } grep { $_->name =~ /\.(?:t|p[ml])$/i } @{ $self->found_files };
}

sub register_prereqs {
	my $self = shift;
	$self->zilla->register_prereqs({ phase => 'runtime' }, perl => $self->perl->stringify);
	return;
}

no Moose;

1;

# ABSTRACT: Fast minimum perl version finder

=head1 DESCRIPTION

This plugin uses L<Perl::MinimumVersion::Fast> to automatically find the minimum version of Perl required for your dist and adds it to the prereqs.

# In your dist.ini:
[MinimumPerl]

This plugin will search for files matching C</\.(t|pl|pm)$/i> in the C<lib/>, C<bin/>, and C<t/> directories.

=head1 SEE ALSO
Dist::Zilla

=cut

