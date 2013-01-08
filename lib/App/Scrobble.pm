# ABSTRACT: Command line scrobbling app
package App::Scrobble;

use Moose;
with 'MooseX::Getopt::Dashes'; #'MooseX::SimpleConfig';

# VERSION

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
        ua       => LWP::UserAgent->new('timeout' => 10, 'env_proxy' => 1),
        user     => $self->username,
        password => $self->password,
    );

    # XXX catch exception and warn
    my $ret = $lastfm->handshake;
    # XXX print p $ret if $self->debug

    my $time = time;
    my $count = 0;

    foreach my $track ( @{ $tracks } ) {

        my $artist = $track->{artist};
        my $track  = $track->{title};

        print "Scrobbling track: $track artist: $artist \n" if $self->verbose;

        $lastfm->submit({
            artist => $artist,
            title  => $track,
            time   => $time - ( $count *  3 * 60 ),
        }) unless $self->dry_run;
        # XXX print p $ret if $self->debug

        $count++;
    }
}

1;

=pod

=head1 DESCRIPTION

Main functionality of L<App::Scrobble>. Takes the command line arguments and
instantiates the correct plugin, if one supports the URL to scrobble.

Instructs the plugin to grab the track data and then submits each track to
L<LastFM|http://www.last.fm>. Makes some vaguely sensible made-up submission times
so all the tracks aren't submitted at exactly the same time.

Works behind a proxy if you set the C<http_proxy> env var.

=head1 METHODS

=head2 C<scrobble>

Main sub called by the script.

=head1 SEE ALSO

L<App::scrobble>

=cut
