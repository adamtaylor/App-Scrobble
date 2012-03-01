# ABSTRACT: Command line scrobbling app
package App::Scrobble;

use Moose;
with 'MooseX::Getopt::Dashes'; #'MooseX::SimpleConfig';

use Module::PluginFinder;
use Net::LastFM::Submission;

has 'username' => (
    is => 'rw',
    documentation => 'Your last.fm username',
);

has 'password' => (
    is => 'rw',
    documentation => 'Your last.fm password',
);

has 'url' => (
    required => 1,
    is => 'rw',
    documentation => 'The URL of the thing you\'d like to scrobble',
);

has 'configfile' => (
    is => 'rw',
    default => "/.scrobble",
);

has 'dry_run' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
    documentation => 'Show what would have been scrobbled but doesn\'t actually scrobble',
);

has 'verbose' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
    documentation => 'Prints out information about progress',
);

has 'finder' => (
    is => 'ro',
    lazy_build => 1,
    traits => [ 'NoGetopt' ],
);

sub _build_finder {
    my $self = shift;

    return Module::PluginFinder->new(
       search_path => 'App::Scrobble::Service',

       filter => sub {
          my ( $module, $searchkey ) = @_;

          return 0 unless $module->can( "is_plugin_for" );
          return $module->is_plugin_for( $searchkey );
       },
    );
}

sub scrobble {
    my $self = shift;

    my $service = $self->finder->construct( $self->url, $self->url );

    my $tracks = $service->get_data;

    $self->_scrobble_tracks( $tracks );
}

sub _scrobble_tracks {
    my $self = shift;
    my $tracks = shift;

    my $lastfm = Net::LastFM::Submission->new;

    foreach my $track ( @{ $tracks } ) {

        my $artist = $track->{artist};
        my $track = $track->{track};

        print "Scrobbling track: $track artist: $artist" if $self->verbose;

        $lastfm->submit({
            artist => $artist,
            track  => $track,
        }) unless $self->dry_run;
    }
}

1;
