package DBConnect;
use Moose;
use namespace::autoclean;
use Log::Log4perl::Catalyst;
use DBI;
use Catalyst::Runtime 5.80;
use Data::Dumper;
# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
            
    Authentication

    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in dbconnect.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.
=head
__PACKAGE__->config( 'Plugin::Authentication' =>
                {
                    default => {
                        credential => {
                            class => 'Password',
                            password_field => 'password',
                            password_type => 'clear'
                        },
                        store => {
                            class => 'Minimal',
                            users => {
                                jb39 => {
                                    password => "123",
                                    role => "admin",
                                    active => 1,
                                    name => 'Jyo'
                                },
                                rg9 => {
                                    password => "rg9_pass",
                                    role => "admin",
                                    active => 1,
                                    name => 'Becca'
                                },
                                sdb => {
                                    password => "sdb_pass",
                                    role => "user",
                                    active => 1,
                                    name => 'Ste'
                                }
                            }
                        }
                    }
                }
    );
=cut
# Using Database info for user authentication
__PACKAGE__->config( 'Plugin::Authentication' =>
                    {
                        default_realm => 'members',
                        members => {
                            credential => {
                                class => 'Password',
                                password_field => 'gpu_password',
                                password_type => 'clear'
                            },
                            store => {
                                class => 'DBIx::Class',
                                user_model => 'gps::GpsUser'
                            }
                        }
                    }
    );

# Start the application
__PACKAGE__->setup();

__PACKAGE__->log( Log::Log4perl::Catalyst->new(
		__PACKAGE__->path_to('gps_log.conf')->stringify  
	));

# Connecting to database and storing dbh in config so that it only connects once to the database.
my $attr = {
    mysql_auto_reconnect => __PACKAGE__->config->{mysql_auto_reconnect},
    AutoCommit => __PACKAGE__->config->{AutoCommit}
};

my $dbh = DBI->connect(__PACKAGE__->config->{dsn},__PACKAGE__->config->{user},__PACKAGE__->config->{password}, $attr);
__PACKAGE__->config->{gps_dbh} = $dbh;

=encoding utf8

=head1 NAME

DBConnect - Catalyst based application

=head1 SYNOPSIS

    script/dbconnect_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<DBConnect::Controller::Root>, L<Catalyst>

=head1 AUTHOR

System Administrator

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;