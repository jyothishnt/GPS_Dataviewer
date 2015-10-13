use utf8;
package DBConnect::Schema::Result::GpsResultsMlst;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsResultsMlst

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

=head1 TABLE: C<gps_results_mlst>

=cut

__PACKAGE__->table("gps_results_mlst");

=head1 ACCESSORS

=head2 grm_lane_id

  data_type: 'text'
  is_nullable: 1

=head2 grm_aroe_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_gdh_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_gki_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_recp_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_spi_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_xpt_insilico

  data_type: 'text'
  is_nullable: 1

=head2 grm_ddl_insilico

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "grm_lane_id",
  { data_type => "text", is_nullable => 1 },
  "grm_aroe_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_gdh_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_gki_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_recp_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_spi_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_xpt_insilico",
  { data_type => "text", is_nullable => 1 },
  "grm_ddl_insilico",
  { data_type => "text", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<grm_index1>

=over 4

=item * L</grm_lane_id>

=back

=cut

__PACKAGE__->add_unique_constraint("grm_index1", ["grm_lane_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-09 13:57:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YShFIcv0lCuQVaVF6HfJ0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
