use utf8;
package DBConnect::Schema::Result::GpsResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsResult

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

=head1 TABLE: C<gps_results>

=cut

__PACKAGE__->table("gps_results");

=head1 ACCESSORS

=head2 grs_sanger_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 grs_lane_id

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 grs_gps_qc

  data_type: 'text'
  is_nullable: 1

=head2 grs_comments

  data_type: 'text'
  is_nullable: 1

=head2 grs_in_silico_st

  data_type: 'text'
  is_nullable: 1

=head2 grs_in_silico_serotype

  data_type: 'text'
  is_nullable: 1

=head2 grs_sample_outcome

  data_type: 'text'
  is_nullable: 1

=head2 grs_updated_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 grs_dbupdate_comments

  data_type: 'text'
  is_nullable: 1

=head2 grs_baps_1

  data_type: 'text'
  is_nullable: 1

=head2 grs_baps_2

  data_type: 'text'
  is_nullable: 1

=head2 grs_vaccine_status

  data_type: 'text'
  is_nullable: 1

=head2 grs_vaccine_period

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "grs_sanger_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "grs_lane_id",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "grs_gps_qc",
  { data_type => "text", is_nullable => 1 },
  "grs_comments",
  { data_type => "text", is_nullable => 1 },
  "grs_in_silico_st",
  { data_type => "text", is_nullable => 1 },
  "grs_in_silico_serotype",
  { data_type => "text", is_nullable => 1 },
  "grs_sample_outcome",
  { data_type => "text", is_nullable => 1 },
  "grs_updated_on",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "grs_dbupdate_comments",
  { data_type => "text", is_nullable => 1 },
  "grs_baps_1",
  { data_type => "text", is_nullable => 1 },
  "grs_baps_2",
  { data_type => "text", is_nullable => 1 },
  "grs_vaccine_status",
  { data_type => "text", is_nullable => 1 },
  "grs_vaccine_period",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-02-03 14:23:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ovn+17YUAhtFt/aPyo/FAw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
