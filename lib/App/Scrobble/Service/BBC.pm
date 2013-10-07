package App::Scrobble::Service::BBC;

use Moose;
with 'App::Scrobble::Role::WithService';

use WebService::BBC::TrackListings;

sub is_plugin_for {
    my $class = shift;
    my $url = shift;

    return unless $url =~ /bbc\.co\.uk/;

    return 1;
}

sub get_tracks {
    my $self = shift;

    my $track_listings = WebService::BBC::TrackListings->new( $self->url );
    return $track_listings->all_tracks();
}
