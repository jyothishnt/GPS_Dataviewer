use utf8;
package DBConnect::Schema::Result::GpsResultsAntibiotic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsResultsAntibiotic

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

=head1 TABLE: C<gps_results_antibiotic>

=cut

__PACKAGE__->table("gps_results_antibiotic");

=head1 ACCESSORS

=head2 gra_lane_id

  data_type: 'text'
  is_nullable: 1

=head2 gra_vans_f_1_af155139

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac3_iia_x13543

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aaca_ab304512

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_3_iva_1_x01385

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_6prime_ii_1_l12710

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_6prime_aph_2primeprime__1_m13771

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aada2

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aadb_1_jn119852

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aadd_1_af181950

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ant_6_ia_1_af330699

  data_type: 'integer'
  is_nullable: 1

=head2 gra_aph_3prime_iii_1_m26832

  data_type: 'integer'
  is_nullable: 1

=head2 gra_arsb_m86824

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blatem1_1_jf910132

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blatem33_1_gu371926

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaz_34_ap003139

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaz_35_aj302698

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaz_36_aj400722

  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaz_39_bx571856

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cada_bx571856

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cadd_bx571858

  data_type: 'integer'
  is_nullable: 1

=head2 gra_catq_1_m55620

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_5_u35036

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pc194_1_nc_002013

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pc221_1_x02529

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pc233_1_ay355285

  data_type: 'integer'
  is_nullable: 1

=head2 gra_cmx_1_u85507

  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfra12_1_ab571791

  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfra14_1_dq388123

  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrc_1_gu565967

  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrc_1_z48233

  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrg_1_ab205645

  data_type: 'integer'
  is_nullable: 1

=head2 gra_erma_2_af002716

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermb_10_u86375

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermb_16_x82819

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermb_18_x66468

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermb_20_af109075

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermb_6_af242872

  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermc_13_m13761

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fexa_1_aj549214

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fosa_8_ache01000077

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fosb_1_x54227

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusa_17_dq866810

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusb_1_am292600

  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusd_ap008934

  data_type: 'integer'
  is_nullable: 1

=head2 gra_iles2_gu237136

  data_type: 'integer'
  is_nullable: 1

=head2 gra_lnua_1_m14039

  data_type: 'integer'
  is_nullable: 1

=head2 gra_lsac_1_hm990671

  data_type: 'integer'
  is_nullable: 1

=head2 gra_meca_10_ab512767

  data_type: 'integer'
  is_nullable: 1

=head2 gra_meca_15_ab505628

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefa_10_af376746

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefa_3_af227521

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefe_ae007317

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mera_l29436

  data_type: 'integer'
  is_nullable: 1

=head2 gra_merb_l29436

  data_type: 'integer'
  is_nullable: 1

=head2 gra_merr_l29436

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mpha_1_d16251

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mphb_1_d85892

  data_type: 'integer'
  is_nullable: 1

=head2 gra_mphc_2_af167161

  data_type: 'integer'
  is_nullable: 1

=head2 gra_msra_1_x52085

  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrc_2_af313494

  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrd_2_af274302

  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrd_3_af227520

  data_type: 'integer'
  is_nullable: 1

=head2 gra_qaca_ap0003367

  data_type: 'integer'
  is_nullable: 1

=head2 gra_qepa_1_ab263754

  data_type: 'integer'
  is_nullable: 1

=head2 gra_smr_qacc_m37889

  data_type: 'integer'
  is_nullable: 1

=head2 gra_stra_1_m96392

  data_type: 'integer'
  is_nullable: 1

=head2 gra_stra_4_nc_003384

  data_type: 'integer'
  is_nullable: 1

=head2 gra_strb_1_m96392

  data_type: 'integer'
  is_nullable: 1

=head2 gra_str_1_x92946

  data_type: 'integer'
  is_nullable: 1

=head2 gra_str_2_fn435330

  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul1_1_ay224185

  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul1_9_ay963803

  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul2_9_fj197818

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tet32_2_ef626943

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tet38_3_fr821779

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetb_4_af326777

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetg_4_af133140

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetk_4_u38428

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetl_2_m29725

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetl_6_x08034

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_10_eu182585

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_12_fr671418

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_13_am990992

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_1_x92947

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_2_x90939

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_4_x75073

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_5_u58985

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_6_m21136

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetm_8_x04388

  data_type: 'integer'
  is_nullable: 1

=head2 gra_teto_1_m18896

  data_type: 'integer'
  is_nullable: 1

=head2 gra_teto_3_y07780

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetr_sgi1

  data_type: 'integer'
  is_nullable: 1

=head2 gra_tets_3_x92946

  data_type: 'integer'
  is_nullable: 1

=head2 gra_vgaa_1_m90056

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gra_lane_id",
  { data_type => "text", is_nullable => 1 },
  "gra_vans_f_1_af155139",
  { data_type => "integer", is_nullable => 1 },
  "gra_aac3_iia_x13543",
  { data_type => "integer", is_nullable => 1 },
  "gra_aaca_ab304512",
  { data_type => "integer", is_nullable => 1 },
  "gra_aac_3_iva_1_x01385",
  { data_type => "integer", is_nullable => 1 },
  "gra_aac_6prime_ii_1_l12710",
  { data_type => "integer", is_nullable => 1 },
  "gra_aac_6prime_aph_2primeprime__1_m13771",
  { data_type => "integer", is_nullable => 1 },
  "gra_aada2",
  { data_type => "integer", is_nullable => 1 },
  "gra_aadb_1_jn119852",
  { data_type => "integer", is_nullable => 1 },
  "gra_aadd_1_af181950",
  { data_type => "integer", is_nullable => 1 },
  "gra_ant_6_ia_1_af330699",
  { data_type => "integer", is_nullable => 1 },
  "gra_aph_3prime_iii_1_m26832",
  { data_type => "integer", is_nullable => 1 },
  "gra_arsb_m86824",
  { data_type => "integer", is_nullable => 1 },
  "gra_blatem1_1_jf910132",
  { data_type => "integer", is_nullable => 1 },
  "gra_blatem33_1_gu371926",
  { data_type => "integer", is_nullable => 1 },
  "gra_blaz_34_ap003139",
  { data_type => "integer", is_nullable => 1 },
  "gra_blaz_35_aj302698",
  { data_type => "integer", is_nullable => 1 },
  "gra_blaz_36_aj400722",
  { data_type => "integer", is_nullable => 1 },
  "gra_blaz_39_bx571856",
  { data_type => "integer", is_nullable => 1 },
  "gra_cada_bx571856",
  { data_type => "integer", is_nullable => 1 },
  "gra_cadd_bx571858",
  { data_type => "integer", is_nullable => 1 },
  "gra_catq_1_m55620",
  { data_type => "integer", is_nullable => 1 },
  "gra_cat_5_u35036",
  { data_type => "integer", is_nullable => 1 },
  "gra_cat_pc194_1_nc_002013",
  { data_type => "integer", is_nullable => 1 },
  "gra_cat_pc221_1_x02529",
  { data_type => "integer", is_nullable => 1 },
  "gra_cat_pc233_1_ay355285",
  { data_type => "integer", is_nullable => 1 },
  "gra_cmx_1_u85507",
  { data_type => "integer", is_nullable => 1 },
  "gra_dfra12_1_ab571791",
  { data_type => "integer", is_nullable => 1 },
  "gra_dfra14_1_dq388123",
  { data_type => "integer", is_nullable => 1 },
  "gra_dfrc_1_gu565967",
  { data_type => "integer", is_nullable => 1 },
  "gra_dfrc_1_z48233",
  { data_type => "integer", is_nullable => 1 },
  "gra_dfrg_1_ab205645",
  { data_type => "integer", is_nullable => 1 },
  "gra_erma_2_af002716",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermb_10_u86375",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermb_16_x82819",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermb_18_x66468",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermb_20_af109075",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermb_6_af242872",
  { data_type => "integer", is_nullable => 1 },
  "gra_ermc_13_m13761",
  { data_type => "integer", is_nullable => 1 },
  "gra_fexa_1_aj549214",
  { data_type => "integer", is_nullable => 1 },
  "gra_fosa_8_ache01000077",
  { data_type => "integer", is_nullable => 1 },
  "gra_fosb_1_x54227",
  { data_type => "integer", is_nullable => 1 },
  "gra_fusa_17_dq866810",
  { data_type => "integer", is_nullable => 1 },
  "gra_fusb_1_am292600",
  { data_type => "integer", is_nullable => 1 },
  "gra_fusd_ap008934",
  { data_type => "integer", is_nullable => 1 },
  "gra_iles2_gu237136",
  { data_type => "integer", is_nullable => 1 },
  "gra_lnua_1_m14039",
  { data_type => "integer", is_nullable => 1 },
  "gra_lsac_1_hm990671",
  { data_type => "integer", is_nullable => 1 },
  "gra_meca_10_ab512767",
  { data_type => "integer", is_nullable => 1 },
  "gra_meca_15_ab505628",
  { data_type => "integer", is_nullable => 1 },
  "gra_mefa_10_af376746",
  { data_type => "integer", is_nullable => 1 },
  "gra_mefa_3_af227521",
  { data_type => "integer", is_nullable => 1 },
  "gra_mefe_ae007317",
  { data_type => "integer", is_nullable => 1 },
  "gra_mera_l29436",
  { data_type => "integer", is_nullable => 1 },
  "gra_merb_l29436",
  { data_type => "integer", is_nullable => 1 },
  "gra_merr_l29436",
  { data_type => "integer", is_nullable => 1 },
  "gra_mpha_1_d16251",
  { data_type => "integer", is_nullable => 1 },
  "gra_mphb_1_d85892",
  { data_type => "integer", is_nullable => 1 },
  "gra_mphc_2_af167161",
  { data_type => "integer", is_nullable => 1 },
  "gra_msra_1_x52085",
  { data_type => "integer", is_nullable => 1 },
  "gra_msrc_2_af313494",
  { data_type => "integer", is_nullable => 1 },
  "gra_msrd_2_af274302",
  { data_type => "integer", is_nullable => 1 },
  "gra_msrd_3_af227520",
  { data_type => "integer", is_nullable => 1 },
  "gra_qaca_ap0003367",
  { data_type => "integer", is_nullable => 1 },
  "gra_qepa_1_ab263754",
  { data_type => "integer", is_nullable => 1 },
  "gra_smr_qacc_m37889",
  { data_type => "integer", is_nullable => 1 },
  "gra_stra_1_m96392",
  { data_type => "integer", is_nullable => 1 },
  "gra_stra_4_nc_003384",
  { data_type => "integer", is_nullable => 1 },
  "gra_strb_1_m96392",
  { data_type => "integer", is_nullable => 1 },
  "gra_str_1_x92946",
  { data_type => "integer", is_nullable => 1 },
  "gra_str_2_fn435330",
  { data_type => "integer", is_nullable => 1 },
  "gra_sul1_1_ay224185",
  { data_type => "integer", is_nullable => 1 },
  "gra_sul1_9_ay963803",
  { data_type => "integer", is_nullable => 1 },
  "gra_sul2_9_fj197818",
  { data_type => "integer", is_nullable => 1 },
  "gra_tet32_2_ef626943",
  { data_type => "integer", is_nullable => 1 },
  "gra_tet38_3_fr821779",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetb_4_af326777",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetg_4_af133140",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetk_4_u38428",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetl_2_m29725",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetl_6_x08034",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_10_eu182585",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_12_fr671418",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_13_am990992",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_1_x92947",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_2_x90939",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_4_x75073",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_5_u58985",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_6_m21136",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetm_8_x04388",
  { data_type => "integer", is_nullable => 1 },
  "gra_teto_1_m18896",
  { data_type => "integer", is_nullable => 1 },
  "gra_teto_3_y07780",
  { data_type => "integer", is_nullable => 1 },
  "gra_tetr_sgi1",
  { data_type => "integer", is_nullable => 1 },
  "gra_tets_3_x92946",
  { data_type => "integer", is_nullable => 1 },
  "gra_vgaa_1_m90056",
  { data_type => "integer", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<gra_lane_id>

=over 4

=item * L</gra_lane_id>

=back

=cut

__PACKAGE__->add_unique_constraint("gra_lane_id", ["gra_lane_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-02-03 12:07:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h4a0VKQtgp3857BRTi6qSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
