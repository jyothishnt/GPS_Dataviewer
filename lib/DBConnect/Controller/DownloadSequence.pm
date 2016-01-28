package DBConnect::Controller::DownloadSequence;
use Moose;
use namespace::autoclean;
use JSON;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Spec;
use File::Basename 'basename';

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::DownloadSequence - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Assembly/Annotation file download
sub downloadSequenceFiles :Path('/download') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->body_data;

  # Logging
  my $log_str = '***';
  $log_str .= (defined $c->user->gpu_institution) ? $c->user->get('gpu_name'). ",".$c->request->headers->header('x-cluster-client-ip') : "GUEST,".$c->request->headers->header('x-cluster-client-ip');
  $log_str .= "***";
  if(scalar keys %{$postData} <= 0) {
    $c->res->body(to_json({'err'=>'No input found!'}));
    return;
  }

  if($args[0]=~/assemblies/) {
    $log_str .= "-AssemblyDownload-".to_json($postData) if(scalar @{$postData->{lane_ids}} > 0);
  }
  elsif($args[0]=~/annotations/) {
    $log_str .= "-AnnotatoionDownload-".to_json($postData) if(scalar @{$postData->{lane_ids}} > 0);
  }
  else {
    $c->res->body({err=>'Bad url!'});
  }

  $c->log->warn($log_str);

  # Creating a zip file
  my $zip = Archive::Zip->new();
  my $found = 0;
  my $file = '';
  my $file_name;

  foreach my $lane (@{$postData->{lane_ids}}) {
    if($args[0]=~/assemblies/) {
      $file = File::Spec->catfile($c->config->{download_path}, '2245_assemblies', $lane.'.contigs_velvet.fa.gz');
      # If zipped not found, check if there is an unzipped one
      if(! -s "$file") {
        $file = File::Spec->catfile($c->config->{download_path}, '2245_assemblies', $lane.'.contigs_velvet.fa');
      }
    }
    elsif($args[0]=~/annotations/) {
      $file = File::Spec->catfile($c->config->{download_path}, '2245_annotations', $lane.'.gff.gz');
      # If zipped not found, check if there is an unzipped one
      if(! -s "$file") {
        $file = File::Spec->catfile($c->config->{download_path}, '2245_annotations', $lane.'.gff');
      }
    }

    $file_name = basename $file;
    if(-s "$file") {
      $zip->addFile($file, $file_name, 1);
      $found = 1;
    }
  }

  if($found == 0) {
    $c->res->body(to_json({err=>'Files not available for download!'}));
  }
  else {
    # Save the Zip file
    my $outfilename = "$args[0]_".$c->user->get('gpu_username')."_".time.".zip";
    my $outfile = File::Spec->catfile($c->config->{dataviewer_tmp}, $outfilename);

    unless ( $zip->writeToFileNamed($outfile) == AZ_OK ) {
      $c->res->body({err=>'Error creating zip file... Please try again!'});
    }

    # return json data back to server
    $c->res->header('Content-Type' => "text/json");
    $c->res->body(to_json({'file'=>$outfile}));
  }
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
