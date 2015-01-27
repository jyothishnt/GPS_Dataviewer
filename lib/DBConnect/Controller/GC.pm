package DBConnect::Controller::GC;
use Moose;
use namespace::autoclean;
use JSON;
use MIME::Base64;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::GC - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Assembly/Annotation file download
sub getGCimages :Path('/get_gc_images') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->body_data;
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-$c->request->address";

  if(scalar keys %{$postData} <= 0) {
    $c->res->body(to_json({'err'=>'No input found!'}));
    return;
  }

  $log_str .= "-GC-".to_json($postData) if(scalar @{$postData->{lane_ids}} > 0);
  $c->log->warn($log_str);
  # Get type of url to retrieve - submitted_ftp or fastq_ftp

  my $datamap = {};
  # For each err id, get the ftp url and store in a hash of arrays
  foreach my $lane (@{$postData->{lane_ids}}) {
    my $file = File::Spec->catfile($c->config->{gc_images_path}, $lane.'.png');
    if(-s "$file") {
	    open(IMAGE,"$file") or $c->res->body(to_json({'err'=>'Image not found!'}));
	    my $raw_string = do{ local $/ = undef; <IMAGE>; };
	    $datamap->{$lane} = encode_base64( $raw_string );
    }
  }

	$c->res->body(to_json($datamap));  
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
