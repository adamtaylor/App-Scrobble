# ABSTRACT: Mixcloud plugin
package App::Scrobble::Service::Mixcloud;

use Moose;
use namespace::autoclean;
with 'App::Scrobble::Role::WithService';

use WWW::Mixcloud;

# VERSION

sub is_plugin_for {
    my $class = shift;
    my $url   = shift;

    return unless $url =~ /mixcloud\.com/;

    return 1;

}

sub get_tracks {
    my $self = shift;

    my $cloudcast = WWW::Mixcloud->new->get_cloudcast( $self->url );

    foreach my $section ( @{$cloudcast->sections} ) {
        $self->add_track({
            title => $section->track->name,
            artist => $section->track->artist->name,
        }) if $section->has_track;
    }

    return $self->tracks;
}

__PACKAGE__->meta->make_immutable;

1;

=pod

=head1 DESCRIPTION

L<App::Scrobble> plugin for L<Mixcloud|http://www.mixcloud.com>. Will scrobble
all the tracks in any cloudcast passed to the command line client.

=head1 METHODS

=head2 C<is_plugin_for>

Returns a boolean if the URL passed in is a mixcloud URL.

=head2 C<get_tracks>

Uses L<WWW::Mixcloud> to construct a hashref of track data from the cloudcast.

=cut
