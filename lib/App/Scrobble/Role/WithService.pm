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

=head1 DESCRIPTION

Interface for L<App::Scrobble::Service::*> plugins.

=head1 ATTRIBUTES

=head2 C<url>

The URL (Str) of the podcast/cloudcast/webpage/whatever to scrobble.

=head2 C<tracks>

Arrayref of track data in the form:

    { title => 'foo', artist => 'bar' }

=head1 METHODS

=head2 C<is_plugin_for>

Will be passed the URL to scrobble and should return a boolean indicating
whether this plugin can scrobble this URL.

=head2 C<get_tracks>

Should populate the C<tracks> hashref with the data from the URL. Is expected
to return the C<tracks> hashref.

=head1 SEE ALSO

L<App::Scrobble>
L<App::Scrobble::Service::Mixcloud>

=cut
