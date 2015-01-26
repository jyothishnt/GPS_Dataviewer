use utf8;
package DBConnect::Schema::Result::GpsCoordinates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpCoordinates

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<gps_coordinates>

=cut

__PACKAGE__->table("gps_coordinates");

=head1 ACCESSORS

=head2 gco_location

  data_type: 'text'
  is_nullable: 0

=head2 gco_latitute

  data_type: 'float'
  is_nullable: 1

=head2 gco_longitude

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gco_location",
  { data_type => "text", is_nullable => 0 },
  "gco_latitude",
  { data_type => "float", is_nullable => 1 },
  "gco_longitude",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gco_location>

=back

=cut

__PACKAGE__->set_primary_key("gco_location");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-12-05 16:40:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Rz/s4XKKdoEPkSbHybejlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
