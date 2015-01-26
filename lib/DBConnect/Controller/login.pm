package DBConnect::Controller::login;
use Moose;
use namespace::autoclean;
use Digest::MD5 qw (md5_hex);
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index
    
Login logic

=cut
sub index : Path('/login') {
    my ($self, $c) = @_;

    # Reconnect to db if connection available
    if(!$c->config->{gps_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{gps_dbh} = $dbh;
    }

    # Get the username and password from form
    my $username = $c->request->params->{username} || "";
    my $password = $c->request->params->{password} || "";
    my $rs = $c->find_user({
              gpu_username => $username,
            });
    
    # If the username and password values were found in form
    if ($username && $password) {
        # Attempt to log the user in
        if( $c->authenticate({
              gpu_username => $username,
              gpu_password => md5_hex($password)
            }) ) {

          if(defined $c->user->get("gpu_active") && $c->user->get("gpu_active")) {
            $c->response->redirect($c->uri_for('/gps/data'));
          }
          else {
            $c->stash->{error_msg} = "Not an active user!";
          }
        }
        else {
          $c->stash->{error_msg} = "Incorrect username or password!";
        }      
    }
    else {
      # Do nothing here
    }

  # If either of above don't work out, send to the login page
  $c->stash->{template} = 'site/login.tt';
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
