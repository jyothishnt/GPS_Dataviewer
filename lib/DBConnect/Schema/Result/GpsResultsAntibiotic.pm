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

=head2 gra_VanS_F_1_AF155139

  accessor: 'gra_van_s_f_1_af155139'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac3_IIa_X13543

  accessor: 'gra_aac3_iia_x13543'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aacA_AB304512

  accessor: 'gra_aac_a_ab304512'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_3_IVa_1_X01385

  accessor: 'gra_aac_3_iva_1_x01385'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_6prime_Ii_1_L12710

  accessor: 'gra_aac_6prime_ii_1_l12710'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aac_6prime_aph_2primeprime__1_M13771

  accessor: 'gra_aac_6prime_aph_2primeprime_1_m13771'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aadA2

  accessor: 'gra_aad_a2'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aadB_1_JN119852

  accessor: 'gra_aad_b_1_jn119852'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aadD_1_AF181950

  accessor: 'gra_aad_d_1_af181950'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ant_6_Ia_1_AF330699

  accessor: 'gra_ant_6_ia_1_af330699'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_aph_3prime_III_1_M26832

  accessor: 'gra_aph_3prime_iii_1_m26832'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_arsB_M86824

  accessor: 'gra_ars_b_m86824'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaTEM1_1_JF910132

  accessor: 'gra_bla_tem1_1_jf910132'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaTEM33_1_GU371926

  accessor: 'gra_bla_tem33_1_gu371926'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaZ_34_AP003139

  accessor: 'gra_bla_z_34_ap003139'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaZ_35_AJ302698

  accessor: 'gra_bla_z_35_aj302698'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaZ_36_AJ400722

  accessor: 'gra_bla_z_36_aj400722'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_blaZ_39_BX571856

  accessor: 'gra_bla_z_39_bx571856'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cadA_BX571856

  accessor: 'gra_cad_a_bx571856'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cadD_BX571858

  accessor: 'gra_cad_d_bx571858'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_catQ_1_M55620

  accessor: 'gra_cat_q_1_m55620'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_5_U35036

  accessor: 'gra_cat_5_u35036'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pC194_1_NC_002013

  accessor: 'gra_cat_p_c194_1_nc_002013'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pC221_1_X02529

  accessor: 'gra_cat_p_c221_1_x02529'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cat_pC233_1_AY355285

  accessor: 'gra_cat_p_c233_1_ay355285'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_catpC194_1_NC_002013

  accessor: 'gra_catp_c194_1_nc_002013'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_catpC221_1_X02529

  accessor: 'gra_catp_c221_1_x02529'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_catpC233_1_AY355285

  accessor: 'gra_catp_c233_1_ay355285'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_cmx_1_U85507

  accessor: 'gra_cmx_1_u85507'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrA12_1_AB571791

  accessor: 'gra_dfr_a12_1_ab571791'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrA14_1_DQ388123

  accessor: 'gra_dfr_a14_1_dq388123'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrC_1_GU565967

  accessor: 'gra_dfr_c_1_gu565967'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrC_1_Z48233

  accessor: 'gra_dfr_c_1_z48233'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_dfrG_1_AB205645

  accessor: 'gra_dfr_g_1_ab205645'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermA_2_AF002716

  accessor: 'gra_erm_a_2_af002716'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermB_10_U86375

  accessor: 'gra_erm_b_10_u86375'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermB_16_X82819

  accessor: 'gra_erm_b_16_x82819'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermB_18_X66468

  accessor: 'gra_erm_b_18_x66468'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermB_20_AF109075

  accessor: 'gra_erm_b_20_af109075'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermB_6_AF242872

  accessor: 'gra_erm_b_6_af242872'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ermC_13_M13761

  accessor: 'gra_erm_c_13_m13761'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fexA_1_AJ549214

  accessor: 'gra_fex_a_1_aj549214'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fosA_8_ACHE01000077

  accessor: 'gra_fos_a_8_ache01000077'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fosB_1_X54227

  accessor: 'gra_fos_b_1_x54227'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusA_17_DQ866810

  accessor: 'gra_fus_a_17_dq866810'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusB_1_AM292600

  accessor: 'gra_fus_b_1_am292600'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_fusD_AP008934

  accessor: 'gra_fus_d_ap008934'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_ileS2_GU237136

  accessor: 'gra_ile_s2_gu237136'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_lnuA_1_M14039

  accessor: 'gra_lnu_a_1_m14039'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_lsaC_1_HM990671

  accessor: 'gra_lsa_c_1_hm990671'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mecA_10_AB512767

  accessor: 'gra_mec_a_10_ab512767'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mecA_15_AB505628

  accessor: 'gra_mec_a_15_ab505628'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefA_10_AF376746

  accessor: 'gra_mef_a_10_af376746'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefA_3_AF227521

  accessor: 'gra_mef_a_3_af227521'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mefE_AE007317

  accessor: 'gra_mef_e_ae007317'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_merA_L29436

  accessor: 'gra_mer_a_l29436'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_merB_L29436

  accessor: 'gra_mer_b_l29436'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_merR_L29436

  accessor: 'gra_mer_r_l29436'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mphA_1_D16251

  accessor: 'gra_mph_a_1_d16251'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mphB_1_D85892

  accessor: 'gra_mph_b_1_d85892'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_mphC_2_AF167161

  accessor: 'gra_mph_c_2_af167161'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrA_1_X52085

  accessor: 'gra_msr_a_1_x52085'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrC_2_AF313494

  accessor: 'gra_msr_c_2_af313494'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrD_2_AF274302

  accessor: 'gra_msr_d_2_af274302'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_msrD_3_AF227520

  accessor: 'gra_msr_d_3_af227520'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_qacA_AP0003367

  accessor: 'gra_qac_a_ap0003367'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_qepA_1_AB263754

  accessor: 'gra_qep_a_1_ab263754'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_smr_qacC_M37889

  accessor: 'gra_smr_qac_c_m37889'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_strA_1_M96392

  accessor: 'gra_str_a_1_m96392'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_strA_4_NC_003384

  accessor: 'gra_str_a_4_nc_003384'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_strB_1_M96392

  accessor: 'gra_str_b_1_m96392'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_str_1_X92946

  accessor: 'gra_str_1_x92946'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_str_2_FN435330

  accessor: 'gra_str_2_fn435330'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul1_1_AY224185

  accessor: 'gra_sul1_1_ay224185'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul1_9_AY963803

  accessor: 'gra_sul1_9_ay963803'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_sul2_9_FJ197818

  accessor: 'gra_sul2_9_fj197818'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tet32_2_EF626943

  accessor: 'gra_tet32_2_ef626943'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tet38_3_FR821779

  accessor: 'gra_tet38_3_fr821779'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetB_4_AF326777

  accessor: 'gra_tet_b_4_af326777'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetG_4_AF133140

  accessor: 'gra_tet_g_4_af133140'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetK_4_U38428

  accessor: 'gra_tet_k_4_u38428'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetL_2_M29725

  accessor: 'gra_tet_l_2_m29725'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetL_6_X08034

  accessor: 'gra_tet_l_6_x08034'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_10_EU182585

  accessor: 'gra_tet_m_10_eu182585'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_12_FR671418

  accessor: 'gra_tet_m_12_fr671418'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_13_AM990992

  accessor: 'gra_tet_m_13_am990992'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_1_X92947

  accessor: 'gra_tet_m_1_x92947'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_2_X90939

  accessor: 'gra_tet_m_2_x90939'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_4_X75073

  accessor: 'gra_tet_m_4_x75073'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_5_U58985

  accessor: 'gra_tet_m_5_u58985'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_6_M21136

  accessor: 'gra_tet_m_6_m21136'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetM_8_X04388

  accessor: 'gra_tet_m_8_x04388'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetO_1_M18896

  accessor: 'gra_tet_o_1_m18896'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetO_3_Y07780

  accessor: 'gra_tet_o_3_y07780'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetR_sgi1

  accessor: 'gra_tet_r_sgi1'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_tetS_3_X92946

  accessor: 'gra_tet_s_3_x92946'
  data_type: 'integer'
  is_nullable: 1

=head2 gra_vgaA_1_M90056

  accessor: 'gra_vga_a_1_m90056'
  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gra_lane_id",
  { data_type => "text", is_nullable => 1 },
  "gra_VanS_F_1_AF155139",
  {
    accessor    => "gra_van_s_f_1_af155139",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aac3_IIa_X13543",
  {
    accessor    => "gra_aac3_iia_x13543",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aacA_AB304512",
  {
    accessor    => "gra_aac_a_ab304512",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aac_3_IVa_1_X01385",
  {
    accessor    => "gra_aac_3_iva_1_x01385",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aac_6prime_Ii_1_L12710",
  {
    accessor    => "gra_aac_6prime_ii_1_l12710",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aac_6prime_aph_2primeprime__1_M13771",
  {
    accessor    => "gra_aac_6prime_aph_2primeprime_1_m13771",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aadA2",
  { accessor => "gra_aad_a2", data_type => "integer", is_nullable => 1 },
  "gra_aadB_1_JN119852",
  {
    accessor    => "gra_aad_b_1_jn119852",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aadD_1_AF181950",
  {
    accessor    => "gra_aad_d_1_af181950",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ant_6_Ia_1_AF330699",
  {
    accessor    => "gra_ant_6_ia_1_af330699",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_aph_3prime_III_1_M26832",
  {
    accessor    => "gra_aph_3prime_iii_1_m26832",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_arsB_M86824",
  {
    accessor    => "gra_ars_b_m86824",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaTEM1_1_JF910132",
  {
    accessor    => "gra_bla_tem1_1_jf910132",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaTEM33_1_GU371926",
  {
    accessor    => "gra_bla_tem33_1_gu371926",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaZ_34_AP003139",
  {
    accessor    => "gra_bla_z_34_ap003139",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaZ_35_AJ302698",
  {
    accessor    => "gra_bla_z_35_aj302698",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaZ_36_AJ400722",
  {
    accessor    => "gra_bla_z_36_aj400722",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_blaZ_39_BX571856",
  {
    accessor    => "gra_bla_z_39_bx571856",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cadA_BX571856",
  {
    accessor    => "gra_cad_a_bx571856",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cadD_BX571858",
  {
    accessor    => "gra_cad_d_bx571858",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_catQ_1_M55620",
  {
    accessor    => "gra_cat_q_1_m55620",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cat_5_U35036",
  {
    accessor    => "gra_cat_5_u35036",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cat_pC194_1_NC_002013",
  {
    accessor    => "gra_cat_p_c194_1_nc_002013",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cat_pC221_1_X02529",
  {
    accessor    => "gra_cat_p_c221_1_x02529",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cat_pC233_1_AY355285",
  {
    accessor    => "gra_cat_p_c233_1_ay355285",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_catpC194_1_NC_002013",
  {
    accessor    => "gra_catp_c194_1_nc_002013",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_catpC221_1_X02529",
  {
    accessor    => "gra_catp_c221_1_x02529",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_catpC233_1_AY355285",
  {
    accessor    => "gra_catp_c233_1_ay355285",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_cmx_1_U85507",
  {
    accessor    => "gra_cmx_1_u85507",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_dfrA12_1_AB571791",
  {
    accessor    => "gra_dfr_a12_1_ab571791",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_dfrA14_1_DQ388123",
  {
    accessor    => "gra_dfr_a14_1_dq388123",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_dfrC_1_GU565967",
  {
    accessor    => "gra_dfr_c_1_gu565967",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_dfrC_1_Z48233",
  {
    accessor    => "gra_dfr_c_1_z48233",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_dfrG_1_AB205645",
  {
    accessor    => "gra_dfr_g_1_ab205645",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermA_2_AF002716",
  {
    accessor    => "gra_erm_a_2_af002716",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermB_10_U86375",
  {
    accessor    => "gra_erm_b_10_u86375",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermB_16_X82819",
  {
    accessor    => "gra_erm_b_16_x82819",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermB_18_X66468",
  {
    accessor    => "gra_erm_b_18_x66468",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermB_20_AF109075",
  {
    accessor    => "gra_erm_b_20_af109075",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermB_6_AF242872",
  {
    accessor    => "gra_erm_b_6_af242872",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ermC_13_M13761",
  {
    accessor    => "gra_erm_c_13_m13761",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fexA_1_AJ549214",
  {
    accessor    => "gra_fex_a_1_aj549214",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fosA_8_ACHE01000077",
  {
    accessor    => "gra_fos_a_8_ache01000077",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fosB_1_X54227",
  {
    accessor    => "gra_fos_b_1_x54227",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fusA_17_DQ866810",
  {
    accessor    => "gra_fus_a_17_dq866810",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fusB_1_AM292600",
  {
    accessor    => "gra_fus_b_1_am292600",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_fusD_AP008934",
  {
    accessor    => "gra_fus_d_ap008934",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_ileS2_GU237136",
  {
    accessor    => "gra_ile_s2_gu237136",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_lnuA_1_M14039",
  {
    accessor    => "gra_lnu_a_1_m14039",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_lsaC_1_HM990671",
  {
    accessor    => "gra_lsa_c_1_hm990671",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mecA_10_AB512767",
  {
    accessor    => "gra_mec_a_10_ab512767",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mecA_15_AB505628",
  {
    accessor    => "gra_mec_a_15_ab505628",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mefA_10_AF376746",
  {
    accessor    => "gra_mef_a_10_af376746",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mefA_3_AF227521",
  {
    accessor    => "gra_mef_a_3_af227521",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mefE_AE007317",
  {
    accessor    => "gra_mef_e_ae007317",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_merA_L29436",
  {
    accessor    => "gra_mer_a_l29436",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_merB_L29436",
  {
    accessor    => "gra_mer_b_l29436",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_merR_L29436",
  {
    accessor    => "gra_mer_r_l29436",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mphA_1_D16251",
  {
    accessor    => "gra_mph_a_1_d16251",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mphB_1_D85892",
  {
    accessor    => "gra_mph_b_1_d85892",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_mphC_2_AF167161",
  {
    accessor    => "gra_mph_c_2_af167161",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_msrA_1_X52085",
  {
    accessor    => "gra_msr_a_1_x52085",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_msrC_2_AF313494",
  {
    accessor    => "gra_msr_c_2_af313494",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_msrD_2_AF274302",
  {
    accessor    => "gra_msr_d_2_af274302",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_msrD_3_AF227520",
  {
    accessor    => "gra_msr_d_3_af227520",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_qacA_AP0003367",
  {
    accessor    => "gra_qac_a_ap0003367",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_qepA_1_AB263754",
  {
    accessor    => "gra_qep_a_1_ab263754",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_smr_qacC_M37889",
  {
    accessor    => "gra_smr_qac_c_m37889",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_strA_1_M96392",
  {
    accessor    => "gra_str_a_1_m96392",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_strA_4_NC_003384",
  {
    accessor    => "gra_str_a_4_nc_003384",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_strB_1_M96392",
  {
    accessor    => "gra_str_b_1_m96392",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_str_1_X92946",
  {
    accessor    => "gra_str_1_x92946",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_str_2_FN435330",
  {
    accessor    => "gra_str_2_fn435330",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_sul1_1_AY224185",
  {
    accessor    => "gra_sul1_1_ay224185",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_sul1_9_AY963803",
  {
    accessor    => "gra_sul1_9_ay963803",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_sul2_9_FJ197818",
  {
    accessor    => "gra_sul2_9_fj197818",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tet32_2_EF626943",
  {
    accessor    => "gra_tet32_2_ef626943",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tet38_3_FR821779",
  {
    accessor    => "gra_tet38_3_fr821779",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetB_4_AF326777",
  {
    accessor    => "gra_tet_b_4_af326777",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetG_4_AF133140",
  {
    accessor    => "gra_tet_g_4_af133140",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetK_4_U38428",
  {
    accessor    => "gra_tet_k_4_u38428",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetL_2_M29725",
  {
    accessor    => "gra_tet_l_2_m29725",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetL_6_X08034",
  {
    accessor    => "gra_tet_l_6_x08034",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_10_EU182585",
  {
    accessor    => "gra_tet_m_10_eu182585",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_12_FR671418",
  {
    accessor    => "gra_tet_m_12_fr671418",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_13_AM990992",
  {
    accessor    => "gra_tet_m_13_am990992",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_1_X92947",
  {
    accessor    => "gra_tet_m_1_x92947",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_2_X90939",
  {
    accessor    => "gra_tet_m_2_x90939",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_4_X75073",
  {
    accessor    => "gra_tet_m_4_x75073",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_5_U58985",
  {
    accessor    => "gra_tet_m_5_u58985",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_6_M21136",
  {
    accessor    => "gra_tet_m_6_m21136",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetM_8_X04388",
  {
    accessor    => "gra_tet_m_8_x04388",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetO_1_M18896",
  {
    accessor    => "gra_tet_o_1_m18896",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetO_3_Y07780",
  {
    accessor    => "gra_tet_o_3_y07780",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_tetR_sgi1",
  { accessor => "gra_tet_r_sgi1", data_type => "integer", is_nullable => 1 },
  "gra_tetS_3_X92946",
  {
    accessor    => "gra_tet_s_3_x92946",
    data_type   => "integer",
    is_nullable => 1,
  },
  "gra_vgaA_1_M90056",
  {
    accessor    => "gra_vga_a_1_m90056",
    data_type   => "integer",
    is_nullable => 1,
  },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<gra_lane_id>

=over 4

=item * L</gra_lane_id>

=back

=cut

__PACKAGE__->add_unique_constraint("gra_lane_id", ["gra_lane_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-13 12:25:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eZlqAvZjCcMWrpQwQz9QnQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
