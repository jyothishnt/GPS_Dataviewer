package DBConnect::Model::gps;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'DBConnect::Schema',
    
    connect_info => {
        dsn => DBConnect->config->{dsn},
        user => DBConnect->config->{user},
        password => DBConnect->config->{password},
        mysql_auto_reconnect => DBConnect->config->{mysql_auto_reconnect}
    }
);

=head1 NAME

DBConnect::Model::gps - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<DBConnect>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<DBConnect::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.62

=head1 AUTHOR

Jyothish  N.N.T. Bhai

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
