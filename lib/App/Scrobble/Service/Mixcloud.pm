# ABSTRACT:
package App::Scrobble::Service::Mixcloud;


use Moose;
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

1;
