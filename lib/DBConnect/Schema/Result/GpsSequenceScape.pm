use utf8;
package DBConnect::Schema::Result::GpsSequenceScape;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsSequenceScape

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

=head1 TABLE: C<gps_sequence_scape>

=cut

__PACKAGE__->table("gps_sequence_scape");

=head1 ACCESSORS

=head2 gss_sanger_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 gss_public_name

  data_type: 'text'
  is_nullable: 1

=head2 gss_lane_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 gss_concentration

  data_type: 'float'
  is_nullable: 1

=head2 gss_measured_volume

  data_type: 'float'
  is_nullable: 1

=head2 gss_total_dna

  data_type: 'double precision'
  is_nullable: 1

=head2 gss_q20_yield_forward_read

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gss_q20_yield_reverse_read

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gss_total_yield

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 gss_created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gss_sanger_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "gss_public_name",
  { data_type => "text", is_nullable => 1 },
  "gss_lane_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "gss_concentration",
  { data_type => "float", is_nullable => 1 },
  "gss_measured_volume",
  { data_type => "float", is_nullable => 1 },
  "gss_total_dna",
  { data_type => "double precision", is_nullable => 1 },
  "gss_q20_yield_forward_read",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gss_q20_yield_reverse_read",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gss_total_yield",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "gss_created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-08 17:09:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:y+AxQ16ycImz1DTXdpDCeA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
