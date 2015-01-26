package DBConnect::Controller::logout;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::logout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Logout logic

=cut

sub index : Private {
    my ($self, $c) = @_;

    # Clear the user's state
    $c->logout;
    # Send the user to the starting point
    $c->response->redirect($c->uri_for('/'));
}


=encoding utf8

=head1 AUTHOR

Jyothish  N.N.T. Bhai

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
