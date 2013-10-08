# ABSTRACT:
package App::Scrobble::Service::BBC;

use Moose;
use namespace::autoclean;
with 'App::Scrobble::Role::WithService';

use WWW::BBC::TrackListings;

# VERSION

sub is_plugin_for {
    my $class = shift;
    my $url = shift;

    return unless $url =~ /bbc\.co\.uk/;

    return 1;
}

sub get_tracks {
    my $self = shift;

    my $track_listings = WWW::BBC::TrackListings->new({ url => $self->url });
    my @tracks = $track_listings->all_tracks();
    return \@tracks;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 DESCRIPTION

L<App::Scrobble> plugin for L<BBC Radio Programmes|http://www.bbc.co.uk/radio/>/

=head1 METHODS

=head2 C<is_plugin_for>

Returns a boolean indicating if the URL passed in is a BBC URL.

=head2 C<get_tracks>

Uses L<WWW::BBC::TrackListings> to construct return an array of track data.

=cut
