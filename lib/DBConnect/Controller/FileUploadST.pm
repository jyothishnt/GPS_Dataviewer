package DBConnect::Controller::FileUploadST;
use Moose;
use namespace::autoclean;
use JSON;
use Spreadsheet::XLSX;
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
sub fileupload_ST :Path('/updateST/bulk/') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->body_data;
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= "-BulkUpload-ST-".to_json($postData) if(scalar keys %{$postData} > 0);
  $c->log->warn($log_str);
  my $upfile = $c->request->upload('st_update_file');
  my $type = $c->request->param('st_update_type');
  my $res = {};
  $res->{rows_updated} = 0;

  if(!$type) {
    $res->{err} = 'Type not specified';
    $c->res->body(to_json($res));
    return;
  }
  my $excel = Spreadsheet::XLSX -> new ($upfile->fh);

  # Transaction start
  my $schema = $c->model('gps::GpsResult')->result_source->schema;
  
  # Begin transaction

  eval {
    GETOUT: foreach my $sheet (@{$excel -> {Worksheet}}) {
      $sheet -> {MaxRow} ||= $sheet -> {MinRow};
       foreach my $row ($sheet -> {MinRow} +1 .. $sheet -> {MaxRow}) {
        $sheet -> {MaxCol} ||= $sheet -> {MinCol};
        my $lane = $sheet->{Cells}[$row][0]->{Val};
        my $st = $sheet->{Cells}[$row][1]->{Val};
        if ($lane && $st) {
          my $rows_affected;
          try {
            if($type eq "st") {
              $rows_affected = $c->config->{gps_dbh}->do("update gps_results set grs_in_silico_st = '$st', grs_updated_on = now() where grs_lane_id = '$lane'") or die $!;
            }
            elsif($type eq "stype") {
              $rows_affected = $c->config->{gps_dbh}->do("update gps_results set grs_in_silico_serotype = '$st', grs_updated_on = now() where grs_lane_id = '$lane'") or die $!;
            }
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
            last GETOUT;
          };
        }
      }
    }
  };
  # If any error occured, then rollback
  if($@) {
    eval( $c->config->{gps_dbh}->rollback );
  }
  if(!$res->{err}) {
    $c->config->{gps_dbh}->commit();
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
