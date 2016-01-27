package DBConnect::Controller::FastqDownload;
use Moose;
use namespace::autoclean;
use JSON;
use WWW::Mechanize;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::FastqDownload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

# Get fastq urls from EBI filereport service
# http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=ERS221588&result=read_run&fields=fastq_ftp
sub getFastq :Path('/fastq/url/') {
  my ( $self, $c, @args ) = @_;
  # Get post data
  my $postData = $c->request->body_data;
  $ENV{'HTTP_PROXY'} = $c->config->{http_proxy};
  # Logging
  my $log_str = '***';
  $log_str .= (defined $c->user->gpu_institution) ? $c->user->get('gpu_name'). ",".$c->request->address : "GUEST,".$c->request->address;
  $log_str .= "***";
  $log_str .= "-FastqUrl-".to_json($postData) if(scalar @{$postData->{accession}} > 0);
  $c->log->warn($log_str);
  # Get type of url to retrieve - submitted_ftp or fastq_ftp
  my $type = $postData->{type};
  my $url_arr = {};
  # For each err id, get the ftp url and store in a hash of arrays
  foreach my $err (@{$postData->{accession}}) {
    my $arr = get_fastq_ftp_url($err, $type);
    if($#$arr >= 0) {
      $url_arr->{$err} = $arr;
    }
  }
  # return json data back to server
  $c->res->body(to_json($url_arr));
}

# Get ftp url from ebi using Mechanize, parse and return the array of urls
sub get_fastq_ftp_url {
    my ($acc, $url_type) = @_;
    my $url;
    # initializing url based on type
    if ( $url_type eq "submitted_ftp" ) {
        $url = "http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=$acc&result=read_run&fields=submitted_ftp";
    }
    else {
        $url = "http://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=$acc&result=read_run&fields=fastq_ftp";
    }
    # New mechanize object

    my $mech = WWW::Mechanize->new;
    # download from given url

    $mech->get($url) or return [];


    my $down = $mech->content( format => 'text' );

    # Parse the content
    my @lines = split( /\n/, $down );
    my $arr = ();
    foreach my $x ( 1 .. $#lines ) {
        my @fields = split( /;/, $lines[$x] );
        foreach my $f (@fields){
          push(@$arr, "ftp://$f");
        }
    }
    return $arr;
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
