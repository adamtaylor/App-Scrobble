# ABSTRACT:
package App::Scrobble::Service::Mixcloud;

# VERSION

use Moose;
use WWW::Mixcloud;
with 'App::Scrobble::Role::WithService';

sub is_plugin_for {
    my $class = shift;
    my $url   = shift;

    warn "checking url: $url";

    return unless $url =~ /mixcloud\.com/;

    #$self->url( $url );

    return 1;

}

sub get_tracks {
    my $self = shift;

    my $cloudcast = WWW::Mixcloud->new->get_cloudcast( $self->url );

    foreach my $section ( @{$cloudcast->sections} ) {
        $self->add_track({
            title => $section->track->name,
            artist => $section->track->artist->name,
        });
    }

    return $self->tracks;
}

1;