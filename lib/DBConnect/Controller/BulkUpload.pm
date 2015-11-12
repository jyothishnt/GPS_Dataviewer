package DBConnect::Controller::BulkUpload;
use Moose;
use namespace::autoclean;
use JSON;
use DBConnect::Controller::JsonUtilityServices;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::FileUploadST - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Bulk update ST data into gps_results table via file upload
sub bulkUpload :Path('/bulk_upload/') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->parameters;
  # Logging
  my $upfile = $c->request->upload('st_update_file');
  my $column = $c->request->param('st_update_type');
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= "-BulkUpload-$column-".to_json($postData) if(scalar keys %{$postData} > 0);
  $c->log->warn($log_str);
  my $res = {};
  $res->{rows_updated} = 0;

  if(!$column) {
    $res->{err} = 'Type not specified';
    $c->res->body(to_json($res));
    return;
  }


  my $extension = (split('\.', $upfile->filename))[-1];
  my $parsedData = {};
  if($extension eq "xlsx") {
    $parsedData = DBConnect::Controller::JsonUtilityServices::parseXLSX($upfile->fh);
  }
  elsif($extension eq "xls") {
    $parsedData = DBConnect::Controller::JsonUtilityServices::parseXLS($upfile->fh);
  }
  elsif($extension eq "csv") {
    $parsedData = DBConnect::Controller::JsonUtilityServices::parseCSV($upfile->fh);
  }

  if ($column eq "mlst") {
    $res  = uploadMLST($c, $parsedData);
  }
  elsif ($column eq "antibiotic") {
    $res  = uploadAntibiotic($c, $parsedData);
  }
  else {
    my $q;
    eval {
      foreach my $lane (keys %$parsedData) {
        my $rows_affected;
        try {
          $q = qq {
            UPDATE gps_results SET $column = '$parsedData->{$lane}->[0]', grs_updated_on = now() WHERE grs_lane_id = '$lane'
          };

          $rows_affected = $c->config->{gps_dbh}->do($q) or die $!;
          if($rows_affected == 0  or $rows_affected eq '0E0') {
            push @{$res->{rows_not_updated}}, $lane;
          }
          else {
            $res->{rows_updated}++;
          }
        }
        catch {
          # Updated = 0 due to rollback
          $res->{rows_updated} = 0;
          $c->config->{gps_dbh}->rollback();
          $res->{err} = "Could not complete your request. Please check the input file: $_";
          $c->res->body(to_json($res));
          last;
        }
      }
    };
    # If any error occured, then rollback
    if($@) {
      eval( $c->config->{gps_dbh}->rollback );
    }
  }

  if(!$res->{err}) {
    $c->config->{gps_dbh}->commit();
  }

  $c->res->body(to_json($res));
}

sub uploadMLST {
  my ($c, $parsedData) = @_;
  my $res = {};
  $res->{rows_updated} = 0;
  # print Dumper $parsedData;
  eval {
    foreach my $lane (keys %$parsedData) {
      my $rows_affected;
      my $row = $parsedData->{$lane};
      try {
        my $rowString = '"'. join('","', @$row ) . '"';

        # Create quesry in-string to inject into the mysql query string
        my $q = qq{
          INSERT INTO gps_results_mlst (grm_lane_id, grm_aroe_insilico, grm_gdh_insilico, grm_gki_insilico,
            grm_recp_insilico, grm_spi_insilico, grm_xpt_insilico, grm_ddl_insilico)
          VALUES ("$lane", $rowString)
            ON DUPLICATE KEY UPDATE
            grm_aroe_insilico = "$row->[0]",
            grm_gdh_insilico = "$row->[1]",
            grm_gki_insilico = "$row->[2]",
            grm_recp_insilico = "$row->[3]",
            grm_spi_insilico = "$row->[4]",
            grm_xpt_insilico = "$row->[5]",
            grm_ddl_insilico = "$row->[6]";
        };

        $rows_affected = $c->config->{gps_dbh}->do($q) or die $!;
        if($rows_affected == 0  or $rows_affected eq '0E0') {
          push @{$res->{rows_not_updated}}, $lane;
        }
        else {
          $res->{rows_updated}++;
        }
      }
      catch {
        # Updated = 0 due to rollback
        $res->{rows_updated} = 0;
        $c->config->{gps_dbh}->rollback();
        $res->{err} = "Could not complete your request. Please check the input file: $_";
        last;
      }
    }
  };
  # If any error occured, then rollback
  if($@) {
    eval( $c->config->{gps_dbh}->rollback );
  }

  return $res;
}

sub uploadAntibiotic {
  my ($c, $parsedData) = @_;
  my $res = {};
  $res->{rows_updated} = 0;
  # print Dumper $parsedData;
  eval {
    foreach my $lane (keys %$parsedData) {
      my $rows_affected;
      my $parsedDataRow = $parsedData->{$lane};
      try {
        my $row = ();
        @$row = map { $_ eq "" ? 'null' : $_ } @$parsedDataRow;
        my $rowString = join(',',  @$row);

        # Create quesry in-string to inject into the mysql query string
        my $q = qq{
          INSERT INTO gps_results_antibiotic (
            gra_lane_id,
            gra_VanS_F_1_AF155139,
            gra_aac3_IIa_X13543,
            gra_aacA_AB304512,
            gra_aac_3_IVa_1_X01385,
            gra_aac_6prime_Ii_1_L12710,
            gra_aac_6prime_aph_2primeprime__1_M13771,
            gra_aadA2,
            gra_aadB_1_JN119852,
            gra_aadD_1_AF181950,
            gra_ant_6_Ia_1_AF330699,
            gra_aph_3prime_III_1_M26832,
            gra_arsB_M86824,
            gra_blaTEM1_1_JF910132,
            gra_blaTEM33_1_GU371926,
            gra_blaZ_34_AP003139,
            gra_blaZ_35_AJ302698,
            gra_blaZ_36_AJ400722,
            gra_blaZ_39_BX571856,
            gra_cadA_BX571856,
            gra_cadD_BX571858,
            gra_catQ_1_M55620,
            gra_cat_5_U35036,
            gra_cat_pC194_1_NC_002013,
            gra_cat_pC221_1_X02529,
            gra_cat_pC233_1_AY355285,
            gra_catpC194_1_NC_002013,
            gra_catpC221_1_X02529,
            gra_catpC233_1_AY355285,
            gra_cmx_1_U85507,
            gra_dfrA12_1_AB571791,
            gra_dfrA14_1_DQ388123,
            gra_dfrC_1_GU565967,
            gra_dfrC_1_Z48233,
            gra_dfrG_1_AB205645,
            gra_ermA_2_AF002716,
            gra_ermB_10_U86375,
            gra_ermB_16_X82819,
            gra_ermB_18_X66468,
            gra_ermB_20_AF109075,
            gra_ermB_6_AF242872,
            gra_ermC_13_M13761,
            gra_fexA_1_AJ549214,
            gra_fosA_8_ACHE01000077,
            gra_fosB_1_X54227,
            gra_fusA_17_DQ866810,
            gra_fusB_1_AM292600,
            gra_fusD_AP008934,
            gra_ileS2_GU237136,
            gra_lnuA_1_M14039,
            gra_lsaC_1_HM990671,
            gra_mecA_10_AB512767,
            gra_mecA_15_AB505628,
            gra_mefA_10_AF376746,
            gra_mefA_3_AF227521,
            gra_mefE_AE007317,
            gra_merA_L29436,
            gra_merB_L29436,
            gra_merR_L29436,
            gra_mphA_1_D16251,
            gra_mphB_1_D85892,
            gra_mphC_2_AF167161,
            gra_msrA_1_X52085,
            gra_msrC_2_AF313494,
            gra_msrD_2_AF274302,
            gra_msrD_3_AF227520,
            gra_qacA_AP0003367,
            gra_qepA_1_AB263754,
            gra_smr_qacC_M37889,
            gra_strA_1_M96392,
            gra_strA_4_NC_003384,
            gra_strB_1_M96392,
            gra_str_1_X92946,
            gra_str_2_FN435330,
            gra_sul1_1_AY224185,
            gra_sul1_9_AY963803,
            gra_sul2_9_FJ197818,
            gra_tet32_2_EF626943,
            gra_tet38_3_FR821779,
            gra_tetB_4_AF326777,
            gra_tetG_4_AF133140,
            gra_tetK_4_U38428,
            gra_tetL_2_M29725,
            gra_tetL_6_X08034,
            gra_tetM_10_EU182585,
            gra_tetM_12_FR671418,
            gra_tetM_13_AM990992,
            gra_tetM_1_X92947,
            gra_tetM_2_X90939,
            gra_tetM_4_X75073,
            gra_tetM_5_U58985,
            gra_tetM_6_M21136,
            gra_tetM_8_X04388,
            gra_tetO_1_M18896,
            gra_tetO_3_Y07780,
            gra_tetR_sgi1,
            gra_tetS_3_X92946,
            gra_vgaA_1_M90056
          )
          VALUES ("$lane", $rowString)
            ON DUPLICATE KEY UPDATE
              gra_VanS_F_1_AF155139 = $row->[0],
              gra_aac3_IIa_X13543 = $row->[1],
              gra_aacA_AB304512 = $row->[2],
              gra_aac_3_IVa_1_X01385 = $row->[3],
              gra_aac_6prime_Ii_1_L12710 = $row->[4],
              gra_aac_6prime_aph_2primeprime__1_M13771 = $row->[5],
              gra_aadA2 = $row->[6],
              gra_aadB_1_JN119852 = $row->[7],
              gra_aadD_1_AF181950 = $row->[8],
              gra_ant_6_Ia_1_AF330699 = $row->[9],
              gra_aph_3prime_III_1_M26832 = $row->[10],
              gra_arsB_M86824 = $row->[11],
              gra_blaTEM1_1_JF910132 = $row->[12],
              gra_blaTEM33_1_GU371926 = $row->[13],
              gra_blaZ_34_AP003139 = $row->[14],
              gra_blaZ_35_AJ302698 = $row->[15],
              gra_blaZ_36_AJ400722 = $row->[16],
              gra_blaZ_39_BX571856 = $row->[17],
              gra_cadA_BX571856 = $row->[18],
              gra_cadD_BX571858 = $row->[19],
              gra_catQ_1_M55620 = $row->[20],
              gra_cat_5_U35036 = $row->[21],
              gra_cat_pC194_1_NC_002013 = $row->[22],
              gra_cat_pC221_1_X02529 = $row->[23],
              gra_cat_pC233_1_AY355285 = $row->[24],
              gra_catpC194_1_NC_002013 = $row->[25],
              gra_catpC221_1_X02529 = $row->[26],
              gra_catpC233_1_AY355285 = $row->[27],
              gra_cmx_1_U85507 = $row->[28],
              gra_dfrA12_1_AB571791 = $row->[29],
              gra_dfrA14_1_DQ388123 = $row->[30],
              gra_dfrC_1_GU565967 = $row->[31],
              gra_dfrC_1_Z48233 = $row->[32],
              gra_dfrG_1_AB205645 = $row->[33],
              gra_ermA_2_AF002716 = $row->[34],
              gra_ermB_10_U86375 = $row->[35],
              gra_ermB_16_X82819 = $row->[36],
              gra_ermB_18_X66468 = $row->[37],
              gra_ermB_20_AF109075 = $row->[38],
              gra_ermB_6_AF242872 = $row->[39],
              gra_ermC_13_M13761 = $row->[40],
              gra_fexA_1_AJ549214 = $row->[41],
              gra_fosA_8_ACHE01000077 = $row->[42],
              gra_fosB_1_X54227 = $row->[43],
              gra_fusA_17_DQ866810 = $row->[44],
              gra_fusB_1_AM292600 = $row->[45],
              gra_fusD_AP008934 = $row->[46],
              gra_ileS2_GU237136 = $row->[47],
              gra_lnuA_1_M14039 = $row->[48],
              gra_lsaC_1_HM990671 = $row->[49],
              gra_mecA_10_AB512767 = $row->[50],
              gra_mecA_15_AB505628 = $row->[51],
              gra_mefA_10_AF376746 = $row->[52],
              gra_mefA_3_AF227521 = $row->[53],
              gra_mefE_AE007317 = $row->[54],
              gra_merA_L29436 = $row->[55],
              gra_merB_L29436 = $row->[56],
              gra_merR_L29436 = $row->[57],
              gra_mphA_1_D16251 = $row->[58],
              gra_mphB_1_D85892 = $row->[59],
              gra_mphC_2_AF167161 = $row->[60],
              gra_msrA_1_X52085 = $row->[61],
              gra_msrC_2_AF313494 = $row->[62],
              gra_msrD_2_AF274302 = $row->[63],
              gra_msrD_3_AF227520 = $row->[64],
              gra_qacA_AP0003367 = $row->[65],
              gra_qepA_1_AB263754 = $row->[66],
              gra_smr_qacC_M37889 = $row->[67],
              gra_strA_1_M96392 = $row->[68],
              gra_strA_4_NC_003384 = $row->[69],
              gra_strB_1_M96392 = $row->[70],
              gra_str_1_X92946 = $row->[71],
              gra_str_2_FN435330 = $row->[72],
              gra_sul1_1_AY224185 = $row->[73],
              gra_sul1_9_AY963803 = $row->[74],
              gra_sul2_9_FJ197818 = $row->[75],
              gra_tet32_2_EF626943 = $row->[76],
              gra_tet38_3_FR821779 = $row->[77],
              gra_tetB_4_AF326777 = $row->[78],
              gra_tetG_4_AF133140 = $row->[79],
              gra_tetK_4_U38428 = $row->[80],
              gra_tetL_2_M29725 = $row->[81],
              gra_tetL_6_X08034 = $row->[82],
              gra_tetM_10_EU182585 = $row->[83],
              gra_tetM_12_FR671418 = $row->[84],
              gra_tetM_13_AM990992 = $row->[85],
              gra_tetM_1_X92947 = $row->[86],
              gra_tetM_2_X90939 = $row->[87],
              gra_tetM_4_X75073 = $row->[88],
              gra_tetM_5_U58985 = $row->[89],
              gra_tetM_6_M21136 = $row->[90],
              gra_tetM_8_X04388 = $row->[91],
              gra_tetO_1_M18896 = $row->[92],
              gra_tetO_3_Y07780 = $row->[93],
              gra_tetR_sgi1 = $row->[94],
              gra_tetS_3_X92946 = $row->[95],
              gra_vgaA_1_M90056 = $row->[96]
        };

        $rows_affected = $c->config->{gps_dbh}->do($q) or die $!;
        if($rows_affected == 0  or $rows_affected eq '0E0') {
          push @{$res->{rows_not_updated}}, $lane;
        }
        else {
          $res->{rows_updated}++;
        }
      }
      catch {
        # Updated = 0 due to rollback
        $res->{rows_updated} = 0;
        $c->config->{gps_dbh}->rollback();
        $res->{err} = "Could not complete your request. Please check the input file: $_";
        last;
      }
    }
  };
  # If any error occured, then rollback
  if($@) {
    eval( $c->config->{gps_dbh}->rollback );
  }

  return $res;
}

=encoding utf8

=head1 AUTHOR

Jyothish  N.N.T. Bhai

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
