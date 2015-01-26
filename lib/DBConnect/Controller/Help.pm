package DBConnect::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::Help - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
# For loading the tt which has search column heading explanations
sub search_col :Path('/col'):Args(0)  {
  my ( $self, $c ) = @_;
  $c->stash->{template} = 'site/search_col_help.tt';
}

# For loading the tt which has search type explanations
sub search_type :Path('/type'):Args(0)  {
  my ( $self, $c ) = @_;
  $c->stash->{template} = 'site/search_type_help.tt';
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
