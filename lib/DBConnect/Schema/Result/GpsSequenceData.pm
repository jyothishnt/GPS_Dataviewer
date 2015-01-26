use utf8;
package DBConnect::Schema::Result::GpsSequenceData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsSequenceData

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

=head1 TABLE: C<gps_sequence_data>

=cut

__PACKAGE__->table("gps_sequence_data");

=head1 ACCESSORS

=head2 gsd_lane_id

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 gsd_sanger_id

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 gsd_public_name

  data_type: 'text'
  is_nullable: 0

=head2 gsd_accessionfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_ers

  data_type: 'text'
  is_nullable: 1

=head2 gsd_err

  data_type: 'text'
  is_nullable: 1

=head2 gsd_mapfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_reference

  data_type: 'text'
  is_nullable: 1

=head2 gsd_mapped_perc

  data_type: 'float'
  is_nullable: 1

=head2 gsd_depth_of_coverage

  data_type: 'text'
  is_nullable: 1

=head2 gsd_depth_of_coverage_sd

  data_type: 'text'
  is_nullable: 1

=head2 gsd_assfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_total_length

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_no_contigs

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_n50

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_pathfind_no_duplicates

  data_type: 'integer'
  is_nullable: 1

=head2 gsd_npg_qc

  data_type: 'text'
  is_nullable: 1

=head2 gsd_manual_qc

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gsd_lane_id",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "gsd_sanger_id",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "gsd_public_name",
  { data_type => "text", is_nullable => 0 },
  "gsd_accessionfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "gsd_ers",
  { data_type => "text", is_nullable => 1 },
  "gsd_err",
  { data_type => "text", is_nullable => 1 },
  "gsd_mapfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "gsd_reference",
  { data_type => "text", is_nullable => 1 },
  "gsd_mapped_perc",
  { data_type => "float", is_nullable => 1 },
  "gsd_depth_of_coverage",
  { data_type => "text", is_nullable => 1 },
  "gsd_depth_of_coverage_sd",
  { data_type => "text", is_nullable => 1 },
  "gsd_assfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "gsd_total_length",
  { data_type => "integer", is_nullable => 1 },
  "gsd_no_contigs",
  { data_type => "integer", is_nullable => 1 },
  "gsd_n50",
  { data_type => "integer", is_nullable => 1 },
  "gsd_pathfind_no_duplicates",
  { data_type => "integer", is_nullable => 1 },
  "gsd_npg_qc",
  { data_type => "text", is_nullable => 1 },
  "gsd_manual_qc",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-07-04 14:35:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EaICYSKSQySoPBu1crxRyQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
