package App::Scrobble;

use Moose;
with 'MooseX::GetOpt', 'MooseX::SimpleConfig';

use Module::PluginFinder;
use Net::LastFM::Submit;

has 'username' => (
    is => 'rw',
);

has 'password' => (
    is => 'rw',
);

has 'url' => (
    is => 'rw',
);

has 'configfile' => (
    is => 'rw',
    default => "$HOME/.scrobble",
);

has 'dry-run' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

has 'finder' => (
    is => 'ro',
    lazy_build => 1,
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
}

1;
