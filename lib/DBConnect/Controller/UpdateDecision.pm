package DBConnect::Controller::UpdateDecision;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::UpdateDecision - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Update decision 0/1/-1 representing exclude/include/new entries respectively
sub updateDecision : Path('/gps/update/decision') {
  my ( $self, $c, @args ) = @_;
  my $type = (defined $c->request->param('type'))?$c->request->param('type'):1;
  my $schema = $c->model('gps::GpsResult');
  my $postData = from_json $c->request->params->{data};

  my $rs;
  my $txn;
  my $res = {};
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= "-UpdateDecision-$type-".to_json($postData) if(scalar @$postData > 0);
  $c->log->warn($log_str);
  my ($q1, $q2);
  my ($sth1, $sth2);
  my $now;
  $q1 = qq{UPDATE gps_results SET grs_decision = ?, grs_updated_on = now() WHERE grs_sanger_id = ? AND grs_lane_id = ?};
  $sth1 = $c->config->{gps_dbh}->prepare($q1) or die "Could not save! Error while preparing query - $!";
  $q2 = qq{UPDATE gps_results SET grs_decision = ?, grs_updated_on = now() WHERE grs_sanger_id = ? AND grs_lane_id IS NULL};
  $sth2 = $c->config->{gps_dbh}->prepare($q2) or die "Could not save! Error while preparing query - $!";
  my $success = {};
  foreach my $row (@{$postData}) {
    try {
      # If both sanger and lane ids are present in the post data
      if(defined $row->{gss_lane_id} && defined $row->{gss_sanger_id}) {
        $rs = $schema->search({ 'grs_lane_id' => $row->{gss_lane_id} });
        if($rs->count) {
          $sth1->execute($type, $row->{gss_sanger_id}, $row->{gss_lane_id}) or die "Could not save! Error while executing query - $!";
        }
        else {
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Lane ID not found in the database}};
          $c->config->{gps_dbh}->rollback;
          $c->res->body(to_json($res));
        }
        # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
      }
      # If only sanger id is present in the post data
      elsif(defined $row->{gss_sanger_id}) {
        $rs = $schema->search({ 'grs_sanger_id' => $row->{gss_sanger_id}});
        if($rs->count) {
          $sth2->execute($type, $row->{gss_sanger_id}) or die "Could not save! Error while executing query - $!";
          # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
        }
        else {
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID not found in the database}};
          $c->config->{gps_dbh}->rollback;
          $c->res->body(to_json($res));
        }
      }
      else {
        $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID and Lane ID not found in the database}};
        $c->config->{gps_dbh}->rollback;
        $c->res->body(to_json($res));
      }

      # Update sample_outcome based on the below conditions
=head
        For public name X. Is there A SINGLE record (only one) with public name X that has decision 1, outcome js "Sample completed".
        if not
        For public name X. Is there more than one record with public name X that has decision 1, outcome is "Sample completed".
        if not
        Is there any record with public name X that has decision -1, outcome is "Sample in progress"
        else
        outcome is "Sample failed".
=cut

      # Get all sanger ids for the public name
      if(defined $row->{gss_public_name} && $row->{gss_public_name} ne "") {
        my $q = qq{SELECT gss_sanger_id FROM gps_sequence_scape where gss_public_name = ?};
        my $sth = $c->config->{gps_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
        $sth->execute($row->{gss_public_name}) or die "Could not save! Error while executing query - $!";

        if($sth->rows > 0) {
          my $res_arr = $sth->fetchall_arrayref();
          # Create the string of sanger ids for IN making query
          my $t_arr = ();
          foreach my $row (@$res_arr) {
            (ref $row eq "ARRAY")? push @$t_arr, $row->[0]: push @$t_arr, $row;
          }

          my $sample_outcome;
          # Creating a string for mysql string search with all the sanger ids for the given public name
          my $t_sam_str = '"'.join('","',@$t_arr).'"';
          $q = qq{SELECT grs_decision FROM gps_results where grs_sanger_id IN ($t_sam_str)};
          $sth = $c->config->{gps_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
          $sth->execute() or die "Could not save! Error while preparing query - $!";
          if($sth->rows() > 0) {
            while(my $arr = $sth->fetchrow_arrayref()) {
              my $dec = $arr->[0];
              # If there is atleast one sample with decision 1, then sample is completed
              if($dec == 1 || $dec == 2) {
                $sample_outcome = 'Sample completed';
                last;
              }
              elsif($dec == -1) {
                # If there is atleast one sample with decision -1, then sample is in progress
                $sample_outcome = 'Sample in progress';
                last;
              }
              elsif($dec == 0) {
                # If decision(in db)  = 0 and current decision = 1, then sample completed. Else failed
                ($type == 1)?$sample_outcome = 'Sample Completed' : $sample_outcome = 'Sample failed';
              }
            }
          }
          else {
            $res = {'err' => 'Error', 'errMsg' => "$row->{gss_public_name} not found in GPS Results table"};
            $c->config->{gps_dbh}->rollback;
            $c->res->body(to_json($res));
            return;
          }
          # For counting the total no. of rows updated. This include all the duplicate rows for each public name in the postData list
          $success->{rows} += ($sth->rows())?$sth->rows():0;
          $success->{final_sample_outcome} = $sample_outcome;

          # Update sample outcome
          $q = qq{UPDATE gps_results SET grs_sample_outcome = "$sample_outcome", grs_updated_on = now() where grs_sanger_id IN ($t_sam_str)};
          $sth = $c->config->{gps_dbh}->do($q);
        }
        else {
          $res = {'err' => 'Error', 'errMsg' => "Sanger id not found for $row->{gss_public_name}"};
          $c->config->{gps_dbh}->rollback;
          $c->res->body(to_json($res));
          return;
        }
      }
      else {
        $res = {'err' => 'Error', 'errMsg' => "Public name not found for $row->{gss_sanger_id}"};
        $c->config->{gps_dbh}->rollback;
        $c->res->body(to_json($res));
        return;
      }
    }
    catch {
      $res = {'err' => 'Error occured while saving', 'errMsg' => qq{$_}};
      $c->config->{gps_dbh}->rollback;
      $c->res->body(to_json($res));
      return;
    }
  }
  # Return the number of rows updated
  if(!defined $res->{'err'}) {
    $c->config->{gps_dbh}->commit;
    $res->{'success'} = $success;
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
