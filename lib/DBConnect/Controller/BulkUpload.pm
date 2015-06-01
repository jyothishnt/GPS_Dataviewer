package DBConnect::Controller::BulkUpload;
use Moose;
use namespace::autoclean;
use JSON;
use Spreadsheet::XLSX;
use Spreadsheet::ParseExcel;
use Text::CSV;
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
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";
  $log_str .= "-BulkUpload-ST-".to_json($postData) if(scalar keys %{$postData} > 0);
  $c->log->warn($log_str);
  my $upfile = $c->request->upload('st_update_file');
  my $column = $c->request->param('st_update_type');
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
    $parsedData = parseXLSX($upfile->fh);
  }
  elsif($extension eq "xls") {
    $parsedData = parseXLS($upfile->fh);
  }
  elsif($extension eq "csv") {
    $parsedData =parseCSV($upfile->fh);
  }

  my $q;
  eval {
    foreach my $lane (keys %$parsedData) {

      my $rows_affected;
      try {
        $q = qq {
          UPDATE gps_results SET $column = '$parsedData->{$lane}', grs_updated_on = now() WHERE grs_lane_id = '$lane'
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
  if(!$res->{err}) {
    $c->config->{gps_dbh}->commit();
  }

  $c->res->body(to_json($res));
}

sub parseXLSX {
  my $fh = shift || die "Parse file not specified";
  my $parsedData = {};
  my $excel = Spreadsheet::XLSX -> new ($fh);
  foreach my $sheet (@{$excel -> {Worksheet}}) {
    $sheet -> {MaxRow} ||= $sheet -> {MinRow};
     foreach my $row ($sheet -> {MinRow} +1 .. $sheet -> {MaxRow}) {
      $sheet -> {MaxCol} ||= $sheet -> {MinCol};
      my $lane = $sheet->{Cells}[$row][0]->{Val};
      my $new_value = $sheet->{Cells}[$row][1]->{Val};
      if (defined $lane) {
        $parsedData->{$lane} =  (defined $new_value)? $new_value : '';
      }
    }
  }
  return $parsedData;
}

sub parseXLS {
  my $fh = shift || die "Parse file not specified";
  my $parser   = Spreadsheet::ParseExcel->new();
  my $workbook = $parser->parse($fh);
  my $parsedData = {};
  if ( !defined $workbook ) {
      die $parser->error(), ".\n";
  }
  for my $worksheet ( $workbook->worksheets() ) {
    my ( $row_min, $row_max ) = $worksheet->row_range();
    for my $row ( $row_min+1 .. $row_max ) {

      my $lane = $worksheet->get_cell( $row, 0 )->value();
      my $value = $worksheet->get_cell( $row, 1 )->value();
      if($lane) {
        $parsedData->{$lane} = (defined $value)? $value : '';
      }
    }
  }
  return $parsedData;
}

sub parseCSV {
  my $fh = shift || die "Parse file not specified";
  my $parsedData = {};
  my @arr;

  my @rows;
  my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                 or die "Cannot use CSV: ".Text::CSV->error_diag ();
  <$fh>;
  while ( my $row = $csv->getline( $fh ) ) {
    if (defined $row->[0]) {
      $parsedData->{$row->[0]} = (defined $row->[1])? $row->[1] : ''
    }
  }
  $csv->eof or $csv->error_diag();
  close $fh;
  $csv->eol ("\r\n");

  return $parsedData;
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
