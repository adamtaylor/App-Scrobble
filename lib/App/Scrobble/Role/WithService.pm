# ABSTRACT: Role interface for App::Scrobble::Service classes
package App::Scrobble::Role::WithService;

# VERSION

use Moose::Role;

has 'tracks' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_track => 'push',
    }
);

has 'url' => (
    is => 'rw',
    isa => 'Str',
);

requires 'is_plugin_for';

requires 'get_tracks';

1;

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<tracks>

=head1 METHODS

=head2 C<is_plugin_for>>

=head2 C<get_tracks>

=head1 SEE ALSO

L<App::Scrobble>
L<App::Scrobble::Service::Mixcloud>

=cut
