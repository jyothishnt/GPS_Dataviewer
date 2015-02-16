package DBConnect::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

DBConnect::Controller::Root - Root Controller for DBConnect

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut


=head2 auto

This 'auto' method will be called for every request that is received by the entire application.
Check if there is a user and, if not, forward to login page

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto' "chain" (all from application path to most specific class are run)
sub auto : Private {
    my ($self, $c) = @_;

    # Allow unauthenticated users to reach the login page
    if ($c->request->path =~ /login/) {
        if (!$c->user_exists) {
            return 1;
        }
        else {
            $c->response->redirect($c->uri_for('/gps/data'));
        }
    }
    elsif ($c->request->path =~ /changepassword/) {
        return 1;
    }
    elsif ($c->request->path =~ /json\/*/) {
        return 1;
    }
    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        #$c->flash->{login_target} = $c->req->path; # Remember where they were trying to get...
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }


    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut
sub default :Path {
    my ( $self, $c ) = @_;

    if($c->request->path =~ /dataviewer/) {
      if (!$c->user_exists) {
        $c->response->redirect($c->uri_for('/login'));
      }
      else{
        $c->response->redirect($c->uri_for('/gps/data'));
      }
    }
    $c->stash->{template} = 'site/404.tt';
}


=head2 end

Attempt to render a view, if needed.

=cut


sub end : ActionClass('RenderView') {}

=head1 AUTHOR

System Administrator

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
