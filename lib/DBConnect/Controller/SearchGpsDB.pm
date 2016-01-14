package DBConnect::Controller::SearchGpsDB;
use Moose;
use namespace::autoclean;
use JSON;
use Try::Tiny;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::SearchGpsDB - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Search gps data
# Fetching sequence data from gps db
sub searchGPSData :Path('/gps/json/') {
  my ( $self, $c, @args ) = @_;
  # Logging
  my $log_str = '';
  $log_str .= (defined $c->user->gpu_institution)?$c->user->get('gpu_name'):"GUEST-".$c->request->address;

  my $search_data;
  if($c->request->body_data) {
    $search_data = $c->request->body_data;
  }

  if(defined $search_data->{search_input}) {
    $search_data->{search_input} = decode_json($search_data->{search_input});
  }

  # Logging
  if(!defined $search_data->{search_input}) {
    if(defined $search_data->{order}) {
      $log_str .= '-PageLoad-' . to_json($search_data);
    }
    else {
      $log_str .= '-PageLoad';
    }
    if($args[0] eq 'download') {
      $log_str .= '-Download';
    }
    if($args[0] eq 'download_selected') {
      $log_str .= '-Download_Selected';
    }
  }
  else {
    if(scalar @{$search_data->{search_input}} > 0) {
      $log_str .= '-Search:'. to_json($search_data->{search_input});
    }
    if($args[0] eq 'download') {
      $log_str .= '-Download';
    }
    if($args[0] eq 'download_selected') {
      $log_str .= '-Download_Selected';
    }
  }

  # If option "Selected Download" then no need to use search conditions. So make it null
  if($args[0] eq 'download_selected') {
    $search_data->{search_input} = ();
  }

  # Log info
  $c->log->warn($log_str);

  # Columns to fetch
  my $selected_columns_arr = ();
  my $selected_columns_str;
  if(defined $search_data->{'selected_columns'}) {
    $selected_columns_arr = $search_data->{'selected_columns'};
  }

  my $download_type = $args[0];

  # Create query string
  my $qString = createQuery($search_data, $selected_columns_arr, $download_type, $c);

  my $rs;
  if($args[0] !~/download/) {
    $rs = getSearchResults($qString, $c);
  }
  else {
    $rs = getDownloadResults($qString, $selected_columns_arr, $c);
  }

  $c->res->header("Cache-Control", "no-cache, no-store, must-revalidate"); # HTTP 1.1.
  $c->res->header("Pragma", "no-cache"); # HTTP 1.0.
  $c->res->header("Expires", 0); # Proxies.
  $c->res->body(to_json($rs));

}

sub getColumnPrefix {
  my $col = shift;
  if ($col =~/^gmd/) {
    return 'M';
  }
  if ($col =~/^gsd/) {
    return 'S';
  }
  if ($col =~/^gss/) {
    return 'SC';
  }
  if ($col =~/^grs/) {
    return 'U';
  }
  if ($col =~/^gra/) {
    return 'A';
  }
  if ($col =~/^grm/) {
    return 'ML';
  }
}

sub getSearchResults() {
  my ($qString, $c) = @_;
  my $resultSet = {};
  my $t_arr = ();
  $resultSet->{rows} = [];

##### Currently below lines are commented as we resolved the _R1 issue mannually by adding rows in the metadata.
  # Get repeat map
  # my $sscapeRepeatMap = getSScapeMapForRepeats($c);
  # my $metadataRepeatMap = getMetadataMapForRepeats($sscapeRepeatMap->{public_name_orig_arr}, $c);
  # my $publicNameRepeat_metadataMap = createPublicNameRepeatMetadataMap($sscapeRepeatMap, $metadataRepeatMap);

  my $sth = checkDBConnectionAndExecute($qString, $c);

  # Push metadata to the final map
  while(my $row = $sth->fetchrow_hashref) {
##### Currently below lines are commented as we resolved the _R1 issue mannually by adding rows in the metadata.
    # if($row->{gss_public_name} && $publicNameRepeat_metadataMap && $publicNameRepeat_metadataMap->{$row->{gss_public_name}}) {
    #   # Merge the metadata into each row if metedata is defined.
    #   # This is done by converting them into a list context and then assigning it to a hash
    #   # which will convert back to a hash. The first hash values will be overwritten by the second hash values.
    #   my %mergeMap = (%$row, %{$publicNameRepeat_metadataMap->{$row->{gss_public_name}}});
    #   $row = \%mergeMap;
    # }
    push(@{$resultSet->{rows}}, $row);
  }

  # Getting the number of rows.
  $qString = qq { SELECT FOUND_ROWS() };

  try {
    $sth = $c->config->{gps_dbh}->prepare($qString) or $resultSet->{err} = "$!";
    $sth->execute() or $resultSet->{err} = "$!";
    $resultSet->{total} = $sth->fetchrow_array;
  }
  catch {
    $resultSet = {'err' => 'Error occured while retrieving data', 'errMsg' => qq{$_}};
  };
  $sth->finish;
  return $resultSet;
}

sub getDownloadResults {
  my ($qString, $selected_columns_arr, $c) = @_;
  my $resultSet = {};
  my $t_arr = ();

##### Currently below lines are commented as we resolved the _R1 issue mannually by adding rows in the metadata.
  # Get repeat map
  # my $sscapeRepeatMap = getSScapeMapForRepeats($c);
  # my $metadataRepeatMap = getMetadataMapForRepeats($sscapeRepeatMap->{public_name_orig_arr}, $c);
  # my $publicNameRepeat_metadataMap = createPublicNameRepeatMetadataMap($sscapeRepeatMap, $metadataRepeatMap);

  my $sth = checkDBConnectionAndExecute($qString, $c);

  # Creating column names
  if (defined $selected_columns_arr) {
    my @t_selected_columns_arr = @$selected_columns_arr;
    foreach my $colname (@t_selected_columns_arr) {
      $colname =~s/\_/ /g;
      $colname =~s/\b(\w)/\U$1/g;
      $colname = substr($colname, 4);
    }
    push @{$resultSet->{rows}}, \@t_selected_columns_arr;

    # Storing rows as array;
    if($sth->rows > 0) {
      while(my $row = $sth->fetchrow_hashref) {

##### Currently below lines are commented as we resolved the _R1 issue mannually by adding rows in the metadata.
        # if($row->{gss_public_name} && $publicNameRepeat_metadataMap && $publicNameRepeat_metadataMap->{$row->{gss_public_name}}) {
        #   # Merge the metadata into each row if metedata is defined.
        #   # This is done by converting them into a list context and then assigning it to a hash
        #   # which will convert back to a hash. The first hash values will be overwritten by the second hash values.
        #   my %mergeMap = (%$row, %{$publicNameRepeat_metadataMap->{$row->{gss_public_name}}});
        #   $row = \%mergeMap;
        # }

        $t_arr = ();
        foreach my $colname (@$selected_columns_arr) {
          push @$t_arr, $row->{$colname};
        }
        push @{$resultSet->{rows}}, $t_arr;
      }
    }
    else {
      $resultSet = {'err'=> 'Samples not available for download!'};
    }
  }
  return $resultSet;
}

sub createQuery {
  my ($search_data, $selected_columns_arr, $download_type, $c) = @_;
  my $selected_columns_str = '';
  if($#$selected_columns_arr >= 0) {
    $selected_columns_str = join(',', @$selected_columns_arr);
  }
  else {
    $selected_columns_str = '*';
  }
  if($download_type eq "download_selected") {
    $search_data->{download_selected} = decode_json($search_data->{download_selected});
    # Making search data null as we dont want to deal with search when the user selected 'selected download'
    $search_data->{search_input} = ();
  }

  #creating query
  my $col_prefix = '';
  my $search_str_map = {};
  my $search_str_start = qq {
                          SELECT SQL_CALC_FOUND_ROWS $selected_columns_str FROM gps_sequence_scape as SC
                          LEFT JOIN gps_sequence_data as S
                              ON SC.gss_lane_id = S.gsd_lane_id
                          LEFT JOIN gps_results as U
                              ON (SC.gss_lane_id = U.grs_lane_id AND SC.gss_sanger_id = U.grs_sanger_id)
                              OR (SC.gss_lane_id IS NULL AND SC.gss_sanger_id = U.grs_sanger_id)
                          LEFT JOIN gps_results_mlst as ML
                              ON SC.gss_lane_id = ML.grm_lane_id
                          LEFT JOIN gps_results_antibiotic as A
                              ON SC.gss_lane_id = A.gra_lane_id
                          LEFT JOIN gps_metadata as M
                              ON SC.gss_public_name = M.gmd_public_name
                          LEFT JOIN gps_coordinates as C
                              ON M.gmd_country = C.gco_location
                            };

  my $search_condition = '';

  if(defined $search_data->{search_input} && @{$search_data->{search_input}} > 0) {
    # Handling GROUPBY first so that we can decide whether to use WHERE or AND later
    my $groupby_exist = 0;
    for (my $i=0; $i<scalar @{$search_data->{search_input}}; $i++) {
      $col_prefix = getColumnPrefix($search_data->{search_input}->[$i]->[0]->{columns});
      if($search_data->{search_input}->[$i]->[0]->{eq} =~/groupby/) {
        $search_condition = ' GROUP BY ';
        $groupby_exist = 1;
        $search_condition .= "$col_prefix.$search_data->{search_input}->[$i]->[0]->{columns} ";
        my $str = $search_data->{search_input}->[$i]->[0]->{search_str};
        if ($search_data->{search_input}->[$i]->[0]->{search_str} eq "") {
          $str = 0;
        }
        # If not digit, then exit.
        if($str !~/^\d+$/) {
          my $res = {'err' => 'Input Error', 'errMsg' => "Numeric value expected"};
          $c->res->body(to_json($res));
          return;
        }

        $search_condition .= " HAVING COUNT($col_prefix.$search_data->{search_input}->[$i]->[0]->{columns}) > $str ";
        last;
      }
    }

    # No need of where clause if groupby exists - 'having' clause is added above
    if(!$groupby_exist) {
      $search_condition = ' WHERE ';
    }

    # Iterate through each column conditions and create the conditional query
    for (my $i=0; $i<scalar @{$search_data->{search_input}}; $i++) {
      my $data = $search_data->{search_input}->[$i];

      if($search_data->{search_input}->[$i]->[0]->{eq} !~/groupby/) { # If not Group by then move forward
        # If groupby query added above, then append "AND"
        if($groupby_exist) {
          $search_condition .= ' AND ';
          # Deflagging it so that this is executed only once.
          $groupby_exist = 0;
        }

        # Split and store the post search string into and array
        my @arr = split(',',$search_data->{search_input}->[$i]->[0]->{search_str});

        $col_prefix = getColumnPrefix($search_data->{search_input}->[$i]->[0]->{columns});
        # Escaping underscores with preceeding backslashes else mysql consideres '_' as 'any character match'
        $search_condition .= "($col_prefix.$search_data->{search_input}->[$i]->[0]->{columns} $search_data->{search_input}->[$i]->[0]->{eq} ";
        if($search_data->{search_input}->[$i]->[0]->{eq} =~ /REGEXP/) {
          if($search_data->{search_input}->[$i]->[0]->{search_str} eq "") {
            $search_condition .= '".*")'; # Making the string search null
          }
          else {
            # Creating the search string form comma separated values
            # Example: WHERE (SC.gss_sanger_id REGEXP "2245STDY5609011|2245STDY5609010")
            my $search_inp = '"' . join('|',@arr) . '")';
            $search_condition .= $search_inp;
          }
        }
        elsif($search_data->{search_input}->[$i]->[0]->{eq} =~ /in/) {
          my $search_inp = '("' . join('","',@arr) . '"))';
          $search_condition .= $search_inp;
        }
        elsif($search_data->{search_input}->[$i]->[0]->{eq} =~ /like/) {
          my $t_str = '';
          for(my $j=0; $j<=$#arr-1; $j++) {
            $t_str .= '"'.$arr[$j]."%\" OR $col_prefix.$search_data->{search_input}->[$i]->[0]->{columns} $search_data->{search_input}->[$i]->[0]->{eq} ";
          }
          $t_str .= '"'.$arr[$#arr].'%"';
          $search_condition .= $t_str.')';
        }
        elsif($search_data->{search_input}->[$i]->[0]->{eq} =~ /is null/) {
          $search_condition .= " OR $col_prefix.$search_data->{search_input}->[$i]->[0]->{columns} <=> '') ";
        }
        elsif($search_data->{search_input}->[$i]->[0]->{eq} =~ /is not null/) {
          $search_condition .= " AND $col_prefix.$search_data->{search_input}->[$i]->[0]->{columns} <> '') ";
        }
        else {
          if($search_data->{search_input}->[$i]->[0]->{search_str} eq "") {
            $search_condition .= '"")'; # Making the string search null
          }
          else {
            $search_condition .= $search_data->{search_input}->[$i]->[0]->{search_str} . ") ";
          }
        }

        # Check if further search condition exists. If yes, the append 'AND'
        if(defined $search_data->{search_input}->[$i+1]) {
          $search_condition .= ' AND ';
        }
      }
    }
  }
  $search_str_map->{'select'} = $search_str_start;
  $search_str_map->{'condition'} = $search_condition;

  # Making query string to download selected data
  # This option will not run the above condition string query
  $search_str_map->{dowload_selected} = '';

  if($download_type eq 'download_selected') {
    # Create search string with sanger_id, lane_id and public name
    my $arr_sanger_id = ();
    foreach my $row (@{$search_data->{download_selected}}) {
      if($row->{gss_sanger_id}) {
        push @$arr_sanger_id, $row->{gss_sanger_id};
      }
    }
    if($#$arr_sanger_id >= 0) {
      my $str_sanger = '"' . join('","', @$arr_sanger_id) . '"';
      # Directly use Where condition as we dont have any search conditions above
      $search_str_map->{dowload_selected} = " WHERE SC.gss_sanger_id IN ($str_sanger) ";
    }
  }

  # Avoid excluded ones from downloading
  $search_str_map->{download_condition} = '';
  ###### Currently allowing all data to download
  # if($download_type=~/download/) {
  #    $search_str_map->{download_condition} = " AND U.grs_gps_qc != 'Fail' ";
  # }

  ######### $search_substr is used for counting the total

  # Handling site specific data retrieval
  $search_str_map->{site_specific} = '';
  if(defined $c->user->gpu_institution && $c->user->gpu_institution !~ /Sanger/) {

    my @arr = split(';',$c->user->gpu_institution);
    my $str = join('","', @arr);

    if($search_str_map->{dowload_selected} ne "" || $search_str_map->{condition} ne "") {
      $search_str_map->{site_specific} = ' AND ';
    }
    else {
      $search_str_map->{site_specific} = ' WHERE ';
    }

    $search_str_map->{site_specific} .= ' M.gmd_institution IN ("' . $str . '")';
    if($c->user->get('gpu_username') eq "testuser") {
      $search_str_map->{site_specific} .= ' M.gmd_study_name = "Global Strain Bank" ';
    }
  }

  $search_str_map->{sort} = getSearchSort($c);
  $search_str_map->{limit} = '';
  if($download_type !~/download/) {
    $search_str_map->{limit} = getSearchLimitSuffix($c);
  }

  # Concat where condition
  return  $search_str_map->{select} .
          $search_str_map->{condition} .
          $search_str_map->{dowload_selected} .
          $search_str_map->{download_condition} .
          $search_str_map->{site_specific} .
          $search_str_map->{sort} .
          $search_str_map->{limit};
}

sub getSearchSort {
  my $c = shift;
  my $search_sort = '';
  my ($sort, $order);
  # Handling sort and pagination variables if asked for
  if($c->request->params->{sort}) {
    $sort = $c->request->params->{sort};
    my $col_prefix = getColumnPrefix($sort);
    $order = ($c->request->params->{order})?$c->request->params->{order}:'asc';
    $search_sort .= " ORDER BY $col_prefix.$sort $order ";
  }
  return $search_sort;
}

sub getSearchLimitSuffix {
  my $c = shift;
  my $search_limit_suffix = '';
  if($c->request->params->{page} && $c->request->params->{rows}) {
    my $page = $c->request->params->{page};
    my $rows = $c->request->params->{rows};
    my $offset = ($page-1) * $rows;
    if(defined $page && defined $rows) {
      $search_limit_suffix .= " LIMIT $offset, $rows ";
    }
  }
  return $search_limit_suffix;
}

sub checkDBConnectionAndExecute() {
  my ($qString, $c) = @_;
  my $sth;
  # Reconnect to db if connection available
  if(!$c->config->{gps_dbh}->ping) {
    my $attr = {
        mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
        AutoCommit => $c->config->{AutoCommit}
    };
    $c->log->warn("Re-connected ".$c->config->{dsn});
    my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
    $c->config->{gps_dbh} = $dbh;
  }
  try {
    $sth = $c->config->{gps_dbh}->prepare($qString) or die;
    $sth->execute() or die;
  }
  catch {
    my $res = {'err' => 'Error occured while retrieving data', 'errMsg' => qq{$_}};
    $c->res->body(to_json($res));
    return;
  };
  return $sth;
}

# Creating NAME_R1 => NAME map
sub getSScapeMapForRepeats {
  my $c = shift;
  my $map = {};
  my $q = qq {
    SELECT
      gss_public_name,
      substr(gss_public_name,1,CHAR_LENGTH(gss_public_name)-3) as gss_orig_public_name
    FROM
      gps_sequence_scape
    WHERE
      gss_public_name REGEXP '.*_R[[:digit:]]\$'
    };
  my $sth = $c->config->{gps_dbh}->prepare($q) or die;
  $sth->execute() or die;
  if($sth->rows > 0) {
    while(my $row = $sth->fetchrow_hashref) {
      $map->{'public_name_map'}->{$row->{gss_public_name}} = $row->{gss_orig_public_name};
      push(@{$map->{public_name_orig_arr}}, $row->{gss_orig_public_name});
    }
  }
  return $map;
}

sub getMetadataSearchFields {
  my $search_data = shift;
  print Dumper $search_data;
}

sub getMetadataMapForRepeats {
  my ($pname_arr, $c) = @_;
  my $map = {};
  if($#$pname_arr >= 0) {
    my $pname_arr_str = join('","', @$pname_arr);
    my $q = qq {
      SELECT
        *
      FROM
        gps_metadata
      WHERE
        gmd_public_name IN ("$pname_arr_str")
      };
    my $sth = $c->config->{gps_dbh}->prepare($q) or die $!;
    $sth->execute() or die $!;
    if($sth->rows > 0) {
      while(my $row = $sth->fetchrow_hashref) {
        $map->{$row->{gmd_public_name}} = $row;
      }
    }
  }
  return $map;
}

sub createPublicNameRepeatMetadataMap {
  my ($sscape_map, $meta_map) = @_;
  my $map = {};
  foreach my $pubnameRepeat (keys %{$sscape_map->{public_name_map}}) {
    if(defined $meta_map->{$sscape_map->{public_name_map}->{$pubnameRepeat}}) {
      $map->{$pubnameRepeat} = $meta_map->{$sscape_map->{public_name_map}->{$pubnameRepeat}};
    }
  }
  return $map;
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
