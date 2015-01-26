package DBConnect::Controller::UpdateComments;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::UpdateComments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Update comments in the GPS database
sub updateComments : Path('/gps/update/comments') {
  my ( $self, $c, @args ) = @_;

  my $schema = $c->model('gps::GpsResult');
  my $postData = from_json $c->request->params->{data};
  my $rs;
  my $txn;
  my $res = {};
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= '-UpdateComments-'.to_json($postData) if(scalar @$postData > 0);
  $c->log->warn($log_str);
  my $q;
  my $sth;
  my $now;
  foreach my $row (@{$postData}) {
    try {
      #print Dumper $rs;
      # There can be a sample without a lane id. So if its not found in below command, we should
      # get them using sanger id.
      if(defined $row->{gss_lane_id} && defined $row->{gss_sanger_id}) {
        $rs = $schema->search({'grs_lane_id' => $row->{gss_lane_id}});
        if($rs->count) {                    

          # Storing insilico st and serotype for updating
          my $in_st = ($row->{grs_in_silico_st})? $row->{grs_in_silico_st} : "";
          my $in_stype = ($row->{grs_in_silico_serotype})? $row->{grs_in_silico_serotype} : "";
          $q = qq{UPDATE gps_results SET grs_comments = ?, grs_in_silico_st = ?, grs_in_silico_serotype = ?, grs_updated_on = now() WHERE grs_sanger_id = ? AND grs_lane_id = ?};
          $sth = $c->config->{gps_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
          $sth->execute($row->{grs_comments}, $in_st, $in_stype, $row->{gss_sanger_id}, $row->{gss_lane_id}) or die "Could not save! Error while executing query - $!"; 
        }        
        else {
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Lane ID not found in the database}};
          $c->res->body(to_json($res));
        }
      }
      elsif(defined $row->{gss_sanger_id}) {
        $rs = $schema->search({ 'grs_sanger_id' => $row->{gss_sanger_id}});
        if($rs->count) {
          my $in_st = ($row->{grs_in_silico_st})? $row->{grs_in_silico_st} : "";
          my $in_stype = ($row->{grs_in_silico_serotype})? $row->{grs_in_silico_serotype} : "";
          $q = qq{UPDATE gps_results SET grs_comments = ?, grs_in_silico_st = ?, grs_in_silico_serotype = ?, grs_updated_on = now() WHERE grs_sanger_id = ? AND grs_lane_id IS NULL};
          $sth = $c->config->{gps_dbh}->prepare($q) or die "Could not save! Error while preparing query - $!";
          $sth->execute($row->{grs_comments}, $in_st, $in_stype, $row->{gss_sanger_id}) or die "Could not save! Error while executing query - $!";
        }
        else {
          # if lane and sample not found, then create a new row.
          # Ideally this should not happen as there should be atleast a sanger id for a row.
          # And we are also updating the QC decision table with newly added sample and lanes 
          # when we update the sequencing pipeline table.
          #$now = strftime "%Y-%m-%d %H:%M:%S", localtime;
          #$schema->create({
          #  'grs_sanger_id' => $row->{gss_sanger_id},
          #  'grs_lane_id' => $row->{gss_lane_id},
          #  'grs_comments' => $row->{grs_comments},
          #  'grs_updated_on' => $now
          #});
          $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID not found in the database}};
          $c->res->body(to_json($res));
        }
      }
      else {
        $res = {'err' => 'Error occured while saving', 'errMsg' => qq{Sanger ID and Lane ID not found in the database}};
        $c->res->body(to_json($res));
      }
    }
    catch {
      #print Dumper $_;
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
