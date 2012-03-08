# ABSTRACT: Command line scrobbling app
package App::Scrobble;

# VERSION

use Moose;
with 'MooseX::Getopt::Dashes'; #'MooseX::SimpleConfig';

use Module::PluginFinder;
use Net::LastFM::Submission;

has 'username' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'Your last.fm username',
);

has 'password' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'Your last.fm password',
);

has 'url' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'The URL of the thing you\'d like to scrobble',
);

#has 'configfile' => (
    #is => 'rw',
    #default => "/.scrobble",
#);

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
    is => 'rw',
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

    my $service = $self->finder->construct( $self->url, { url => $self->url } );

    my $tracks = $service->get_tracks;

    $self->_scrobble_tracks( $tracks );
}

sub _scrobble_tracks {
    my $self = shift;
    my $tracks = shift;

    my $lastfm = Net::LastFM::Submission->new(
        user     => $self->username,
        password => $self->password,
    );

    my $ret = $lastfm->handshake;

    my $time = time;
    my $count = 0;

    foreach my $track ( @{ $tracks } ) {

        my $artist = $track->{artist};
        my $track  = $track->{title};

        print "Scrobbling track: $track artist: $artist \n" if $self->verbose;

        my $ret = $lastfm->submit({
            artist => $artist,
            title  => $track,
            time   => $time - ( $count *  3 * 60 ),
        }) unless $self->dry_run;

        $count++;
    }
}

1;
