package DBConnect::Controller::SiteLoad;
use Moose;
use namespace::autoclean;
use JSON;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::SiteLoad - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Function that gets called for loading the initial page.
# This sends db columns as a 2D array to the template
sub gpsDataDisplayMain :Path('/gps/data/') :Args(0) {
  my ( $self, $c ) = @_;
  my @col_arr = ();
  my $col = ();

  # Get all the columns from the database to populate HTML dropdown in the search form
  # Pushing columns from sequence scape table
  my $schema_gss = $c->model('gps::GpsSequenceScape');
  my @col_arr_gss = $schema_gss->result_source->columns;
  push(@col_arr, @col_arr_gss);
  push(@{$col}, [@col_arr]);

  # Pushing columns from gps results table
  my $schema_gup = $c->model('gps::GpsResult');
  my @col_arr_gup = $schema_gup->result_source->columns;
  splice (@col_arr_gup,0,2);
  push(@col_arr, @col_arr_gup);
  push(@{$col}, [@col_arr_gup]);

  # Pushing columns from sequence data table
  my $schema_gsd = $c->model('gps::GpsSequenceData');
  my @col_arr_gsd = $schema_gsd->result_source->columns;
  splice (@col_arr_gsd,0,4);
  splice (@col_arr_gsd,2,1);
  splice (@col_arr_gsd,6,1);
  splice (@col_arr_gsd,9,1);
  push(@col_arr, @col_arr_gsd);
  push(@{$col}, [@col_arr_gsd]);

  # Pushing columns from metadata table
  my $schema_gmd = $c->model('gps::GpsMetadata');
  my @col_arr_gmd = $schema_gmd->result_source->columns;
  push(@col_arr, @col_arr_gmd);
  splice (@col_arr_gmd,1,1);
  push(@{$col}, [@col_arr_gmd]);

  #$c->stash->{search_columns} = to_json(\@col_arr);
  $c->stash->{gpsdb_column_2d_array} = to_json($col);
  $c->stash->{username} = 'GPS Search';
  $c->stash->{template} = 'site/pipe_display.tt';
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
