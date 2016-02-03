use utf8;
package DBConnect::Schema::Result::GpsMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsMetadata

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

=head1 TABLE: C<gps_metadata>

=cut

__PACKAGE__->table("gps_metadata");

=head1 ACCESSORS

=head2 gmd_sample_id

  data_type: 'text'
  is_nullable: 1

=head2 gmd_public_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 gmd_study_name

  data_type: 'text'
  is_nullable: 1

=head2 gmd_selection_random

  data_type: 'text'
  is_nullable: 1

=head2 gmd_country

  data_type: 'text'
  is_nullable: 1

=head2 gmd_region

  data_type: 'text'
  is_nullable: 1

=head2 gmd_city

  data_type: 'text'
  is_nullable: 1

=head2 gmd_facility_collected

  data_type: 'text'
  is_nullable: 1

=head2 gmd_institution

  data_type: 'text'
  is_nullable: 1

=head2 gmd_col_month

  data_type: 'text'
  is_nullable: 1

=head2 gmd_col_year

  data_type: 'text'
  is_nullable: 1

=head2 gmd_gender

  data_type: 'text'
  is_nullable: 1

=head2 gmd_age_year

  data_type: 'text'
  is_nullable: 1

=head2 gmd_age_month

  data_type: 'text'
  is_nullable: 1

=head2 gmd_age_day

  data_type: 'text'
  is_nullable: 1

=head2 gmd_clinical_manifest

  data_type: 'text'
  is_nullable: 1

=head2 gmd_source

  data_type: 'text'
  is_nullable: 1

=head2 gmd_hiv_status

  data_type: 'text'
  is_nullable: 1

=head2 gmd_conditions

  data_type: 'text'
  is_nullable: 1

=head2 gmd_pheno_serotype_method

  data_type: 'text'
  is_nullable: 1

=head2 gmd_pheno_serotype

  data_type: 'text'
  is_nullable: 1

=head2 gmd_seq_type

  data_type: 'text'
  is_nullable: 1

=head2 gmd_aroe

  data_type: 'text'
  is_nullable: 1

=head2 gmd_gdh

  data_type: 'text'
  is_nullable: 1

=head2 gmd_gki

  data_type: 'text'
  is_nullable: 1

=head2 gmd_recp

  data_type: 'text'
  is_nullable: 1

=head2 gmd_spi

  data_type: 'text'
  is_nullable: 1

=head2 gmd_xpt

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ddl

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_penicillin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_penicillin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_amoxicillin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_amoxicillin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_cefotaxime

  data_type: 'text'
  is_nullable: 1

=head2 gmd_cefotaxime

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_ceftriaxone

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ceftriaxone

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_cefuroxime

  data_type: 'text'
  is_nullable: 1

=head2 gmd_cefuroxime

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_meropenem

  data_type: 'text'
  is_nullable: 1

=head2 gmd_meropenem

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_erythromycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_erythromycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_clindamycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_clindamycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_trim_sulfa

  data_type: 'text'
  is_nullable: 1

=head2 gmd_trim_sulfa

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_vancomycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_vancomycin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_linezolid

  data_type: 'text'
  is_nullable: 1

=head2 gmd_linezolid

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_ciprofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ciprofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_chloramphenicol

  data_type: 'text'
  is_nullable: 1

=head2 gmd_chloramphenicol

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_tetracycline

  data_type: 'text'
  is_nullable: 1

=head2 gmd_tetracycline

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_levofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_levofloxacin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_synercid

  data_type: 'text'
  is_nullable: 1

=head2 gmd_synercid

  data_type: 'text'
  is_nullable: 1

=head2 gmd_ast_rifampin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_rifampin

  data_type: 'text'
  is_nullable: 1

=head2 gmd_comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gmd_sample_id",
  { data_type => "text", is_nullable => 1 },
  "gmd_public_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "gmd_study_name",
  { data_type => "text", is_nullable => 1 },
  "gmd_selection_random",
  { data_type => "text", is_nullable => 1 },
  "gmd_country",
  { data_type => "text", is_nullable => 1 },
  "gmd_region",
  { data_type => "text", is_nullable => 1 },
  "gmd_city",
  { data_type => "text", is_nullable => 1 },
  "gmd_facility_collected",
  { data_type => "text", is_nullable => 1 },
  "gmd_institution",
  { data_type => "text", is_nullable => 1 },
  "gmd_col_month",
  { data_type => "text", is_nullable => 1 },
  "gmd_col_year",
  { data_type => "text", is_nullable => 1 },
  "gmd_gender",
  { data_type => "text", is_nullable => 1 },
  "gmd_age_year",
  { data_type => "text", is_nullable => 1 },
  "gmd_age_month",
  { data_type => "text", is_nullable => 1 },
  "gmd_age_day",
  { data_type => "text", is_nullable => 1 },
  "gmd_clinical_manifest",
  { data_type => "text", is_nullable => 1 },
  "gmd_source",
  { data_type => "text", is_nullable => 1 },
  "gmd_hiv_status",
  { data_type => "text", is_nullable => 1 },
  "gmd_conditions",
  { data_type => "text", is_nullable => 1 },
  "gmd_pheno_serotype_method",
  { data_type => "text", is_nullable => 1 },
  "gmd_pheno_serotype",
  { data_type => "text", is_nullable => 1 },
  "gmd_seq_type",
  { data_type => "text", is_nullable => 1 },
  "gmd_aroe",
  { data_type => "text", is_nullable => 1 },
  "gmd_gdh",
  { data_type => "text", is_nullable => 1 },
  "gmd_gki",
  { data_type => "text", is_nullable => 1 },
  "gmd_recp",
  { data_type => "text", is_nullable => 1 },
  "gmd_spi",
  { data_type => "text", is_nullable => 1 },
  "gmd_xpt",
  { data_type => "text", is_nullable => 1 },
  "gmd_ddl",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_penicillin",
  { data_type => "text", is_nullable => 1 },
  "gmd_penicillin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_amoxicillin",
  { data_type => "text", is_nullable => 1 },
  "gmd_amoxicillin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_cefotaxime",
  { data_type => "text", is_nullable => 1 },
  "gmd_cefotaxime",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_ceftriaxone",
  { data_type => "text", is_nullable => 1 },
  "gmd_ceftriaxone",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_cefuroxime",
  { data_type => "text", is_nullable => 1 },
  "gmd_cefuroxime",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_meropenem",
  { data_type => "text", is_nullable => 1 },
  "gmd_meropenem",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_erythromycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_erythromycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_clindamycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_clindamycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_trim_sulfa",
  { data_type => "text", is_nullable => 1 },
  "gmd_trim_sulfa",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_vancomycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_vancomycin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_linezolid",
  { data_type => "text", is_nullable => 1 },
  "gmd_linezolid",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_ciprofloxacin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ciprofloxacin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_chloramphenicol",
  { data_type => "text", is_nullable => 1 },
  "gmd_chloramphenicol",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_tetracycline",
  { data_type => "text", is_nullable => 1 },
  "gmd_tetracycline",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_levofloxacin",
  { data_type => "text", is_nullable => 1 },
  "gmd_levofloxacin",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_synercid",
  { data_type => "text", is_nullable => 1 },
  "gmd_synercid",
  { data_type => "text", is_nullable => 1 },
  "gmd_ast_rifampin",
  { data_type => "text", is_nullable => 1 },
  "gmd_rifampin",
  { data_type => "text", is_nullable => 1 },
  "gmd_comments",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gmd_public_name>

=back

=cut

__PACKAGE__->set_primary_key("gmd_public_name");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-02-03 14:23:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wytWk/t/hMVoTFlBZmhQDw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
