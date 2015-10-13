package DBConnect::Controller::UpdateMlst;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::UpdateMlst - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
# Create sql in-string
sub createSqlString {
  my $row = shift;
  my $strArr = ();
  my $conditionStrArr = ();

  my $qstring;
  my $final_query = "UPDATE gps_results_mlst SET";

  for my $k (keys %$row) {
    if(defined $row->{$k}) {
      if($k ne "gss_lane_id") {
        if ($row->{$k} eq "") {
          push(@$strArr, qq{ $k = NULL });
        }
        else {
          push(@$strArr, qq{ $k = "$row->{$k}" });
        }
      }
      elsif ($k eq "gss_lane_id" && $row->{$k} ne "") {
        push(@$conditionStrArr, qq{ grm_lane_id = "$row->{$k}" });
      }
    }
  }

  $final_query .= join(',', @$strArr);
  $final_query .= ' WHERE ' . join(' AND ', @$conditionStrArr) . ' ';

  return $final_query;
}

# Update comments in the GPS database
sub updateMlst : Path('/gps/update/mlst') {
  my ( $self, $c, @args ) = @_;

  my $postData = from_json $c->request->params->{data};
  my $rs;
  my $txn;
  my $res = {};
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= '-UpdateMlst-'.to_json($postData) if(scalar @$postData > 0);
  $c->log->warn($log_str);
  my $q;
  my $sth;
  my $now;

  foreach my $row (@{$postData}) {
    try {

      # Create quesry in-string to inject into the mysql query string
      my $qstring = createSqlString($row);
      my $q = qq{
        INSERT INTO gps_results_mlst (grm_lane_id,grs_aroe_insilico,grs_gdh_insilico,grs_gki_insilico,
          grs_recp_insilico,grs_spi_insilico,grs_xpt_insilico,grs_ddl_insilico) VALUES ('a','a','a','a','a','a','a','a');
          ON DUPLICATE KEY UPDATE grs_aroe_insilico = 'x';
      };
      $c->config->{gps_dbh}->do($qstring) or die "Could not save! Error while executing query - $!";
    }
    catch {
      $c->config->{gps_dbh}->rollback;
      $res = {'err' => 'Error occured while saving', 'errMsg' => qq{$_}};
      $c->res->body(to_json($res));

    }
  }
  # Return the number of rows updated
  if(!defined $res->{'err'}) {
    $c->config->{gps_dbh}->commit;
    $res->{'success'} = @{$postData};
  }
  $c->res->body(to_json($res));
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
