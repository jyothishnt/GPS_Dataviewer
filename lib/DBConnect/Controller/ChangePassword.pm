package DBConnect::Controller::ChangePassword;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;
use Digest::MD5 qw (md5_hex);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::ChangePassword - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{template} = 'site/change_password.tt';
}

=head2 index

=cut
sub change_password : Path('/changepassword/update') {
  my ( $self, $c, @args ) = @_;
  my $schema = $c->model('gps::GpsUser');
  my $rs;
  my $res = {};
  # Logging
  my $log_str = '***';
  $log_str .= "***" . $c->request->params->{username} . "," . $c->request->headers->header('x-cluster-client-ip') . "***";
  $log_str .= "-ChangePassword";
  $c->log->warn($log_str);
  my $q;
  my $sth;

  my $username = $c->request->params->{username};
  my $oldpass = $c->request->params->{oldpass};
  my $newpass = $c->request->params->{newpass};
  my $newpass_rep = $c->request->params->{newpass_rep};

  try {
    # If the username and password values were found in form
    if ($username && $oldpass) {

        if(length($newpass) < 6) {
          $c->stash->{error_msg} = "Password should be minimum 6 characters long!";
          $c->stash->{template} = 'site/change_password.tt';
          return;
        }

        if($newpass ne $newpass_rep) {
          $c->stash->{error_msg} = "New passwords not matching!";
          $c->stash->{template} = 'site/change_password.tt';
          return;
        }

        # Attempt to authenticate
        if( $c->authenticate({
              gpu_username => $username,
              gpu_password => md5_hex($oldpass)
            }) ) {

          if($c->user->get("gpu_active")) {
              $q = qq{UPDATE gps_users SET gpu_password = MD5(?) WHERE gpu_username = ? AND gpu_password = MD5(?)};
              my $err_fl = 0;
              try {
                $sth = $c->config->{gps_dbh}->prepare($q) or die $!;
                $sth->execute($newpass, $username, $oldpass) or die $!;
              }
              catch {
                $err_fl = 1;
                $c->config->{gps_dbh}->rollback();
                $c->stash->{error_msg} = 'Could not complete your request! Please try again later.';
                $c->stash->{template} = 'site/change_password.tt';
                return;
              };
              if($err_fl) {
                $c->config->{gps_dbh}->rollback();
                $c->stash->{error_msg} = 'Could not complete your request! Please try again later.';
                $c->stash->{template} = 'site/change_password.tt';
              }
              else {
                $c->config->{gps_dbh}->commit();
                $c->stash->{res} = 'Successfully changed password!';
                $c->stash->{template} = 'site/change_password.tt';
              }
          }
        }
        else {
          $c->stash->{error_msg} = "User not found! Please check the username or password";
        }
    }
    else {
      $c->stash->{error_msg} = "Missing input!";
    }
  }
  catch {
    $c->stash->{error_msg} = $_;
  };

  $c->stash->{template} = 'site/change_password.tt';
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
