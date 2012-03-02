# ABSTRACT: Role interface for App::Scrobble::Service classes
package App::Scrobble::Role::WithService;

# VERSION

use Moose::Role;

has 'data' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

requires 'construct';

requires 'get_data';

1;

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<data>

=head1 METHODS

=head2 C<construct>

=head2 C<get_data>

=head1 SEE ALSO

L<App::Scrobble>
L<App::Scrobble::Service::Mixcloud>

=cut
