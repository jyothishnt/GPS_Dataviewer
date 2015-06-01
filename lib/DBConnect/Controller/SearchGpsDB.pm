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
  if(defined $search_data->{data}) {
    $search_data->{data} = decode_json($search_data->{data});
  }
  if(defined $search_data->{download_selected}) {
    $search_data->{download_selected} = decode_json($search_data->{download_selected});
    # Making search data null as we dont want to deal with search when the user selected 'selected download'
    $search_data->{data} = ();
  }

  # Logging
  if(!defined $search_data->{data}) {
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
    if(scalar @{$search_data->{data}} > 0) {
      $log_str .= '-Search:'. to_json($search_data);
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
    $search_data->{data} = ();
  }

  # Columns to fetch
  my $selected_columns_arr = ();
  my $selected_columns_str;
  if(defined $search_data->{'selected_columns'}) {
    $selected_columns_arr = $search_data->{'selected_columns'};
    $selected_columns_str = join(',', @$selected_columns_arr);
  }
  else {
    $selected_columns_str = '*';
  }

  # Log info
  $c->log->warn($log_str);

  #creating query
  my $col_prefix = '';
  my $search_str;
  my $search_str_start = "SELECT $selected_columns_str FROM gps_sequence_scape as SC
                          LEFT JOIN gps_sequence_data as S
                              ON SC.gss_lane_id = S.gsd_lane_id
                          LEFT JOIN gps_results as U
                              ON (SC.gss_lane_id = U.grs_lane_id AND SC.gss_sanger_id = U.grs_sanger_id)
                              OR (SC.gss_lane_id IS NULL AND SC.gss_sanger_id = U.grs_sanger_id)
                          LEFT JOIN gps_metadata as M
                              ON SC.gss_public_name = M.gmd_public_name";
  my $search_substr = '';
  if(defined $search_data->{data} && @{$search_data->{data}} > 0) {
    # Handling GROUPBY first so that we can decide whether to use WHERE or AND later
    my $groupby_exist = 0;
    for (my $i=0; $i<scalar @{$search_data->{data}}; $i++) {
      $col_prefix = getColumnPrefix($search_data->{data}->[$i]->[0]->{columns});
      if($search_data->{data}->[$i]->[0]->{eq} =~/groupby/) {
        $search_substr = ' GROUP BY ';
        $groupby_exist = 1;
        $search_substr .= "$col_prefix.$search_data->{data}->[$i]->[0]->{columns} ";
        my $str = $search_data->{data}->[$i]->[0]->{search_str};
        if ($search_data->{data}->[$i]->[0]->{search_str} eq "") {
          $str = 0;
        }
        # If not digit, then exit.
        if($str !~/^\d+$/) {
          my $res = {'err' => 'Input Error', 'errMsg' => "Numeric value expected"};
          $c->res->body(to_json($res));
          return;
        }

        $search_substr .= " HAVING COUNT($col_prefix.$search_data->{data}->[$i]->[0]->{columns}) > $str ";
        last;
      }
    }

    # No need of where clause if groupby exists - 'having' clause is added above
    if(!$groupby_exist) {
      $search_substr = ' WHERE ';
    }

    # Iterate through each column conditions and create the conditional query
    for (my $i=0; $i<scalar @{$search_data->{data}}; $i++) {
      my $data = $search_data->{data}->[$i];

      if($search_data->{data}->[$i]->[0]->{eq} !~/groupby/) { # If not Group by then move forward
        # If groupby query added above, then append "AND"
        if($groupby_exist) {
          $search_substr .= ' AND ';
          # Deflagging it so that this is executed only once.
          $groupby_exist = 0;
        }

        # Split and store the post search string into and array
        my @arr = split(',',$search_data->{data}->[$i]->[0]->{search_str});

        $col_prefix = getColumnPrefix($search_data->{data}->[$i]->[0]->{columns});
        # Escaping underscores with preceeding backslashes else mysql consideres '_' as 'any character match'
        $search_substr .= "($col_prefix.$search_data->{data}->[$i]->[0]->{columns} $search_data->{data}->[$i]->[0]->{eq} ";
        if($search_data->{data}->[$i]->[0]->{eq} =~ /REGEXP/) {
          if($search_data->{data}->[$i]->[0]->{search_str} eq "") {
            $search_substr .= '".*")'; # Making the string search null
          }
          else {
            # Creating the search string form comma separated values
            # Example: WHERE (SC.gss_sanger_id REGEXP "2245STDY5609011|2245STDY5609010")
            my $search_inp = '"' . join('|',@arr) . '")';
            $search_substr .= $search_inp;
          }
        }
        elsif($search_data->{data}->[$i]->[0]->{eq} =~ /in/) {
          my $search_inp = '("' . join('","',@arr) . '"))';
          $search_substr .= $search_inp;
        }
        elsif($search_data->{data}->[$i]->[0]->{eq} =~ /like/) {
          my $t_str = '';
          for(my $j=0; $j<=$#arr-1; $j++) {
            $t_str .= '"'.$arr[$j]."%\" OR $col_prefix.$search_data->{data}->[$i]->[0]->{columns} $search_data->{data}->[$i]->[0]->{eq} ";
          }
          $t_str .= '"'.$arr[$#arr].'%"';
          $search_substr .= $t_str.')';
        }
        elsif($search_data->{data}->[$i]->[0]->{eq} =~ /is null/) {
          $search_substr .= " OR $col_prefix.$search_data->{data}->[$i]->[0]->{columns} <=> '') ";
        }
        elsif($search_data->{data}->[$i]->[0]->{eq} =~ /is not null/) {
          $search_substr .= " AND $col_prefix.$search_data->{data}->[$i]->[0]->{columns} <> '') ";
        }
        else {
          if($search_data->{data}->[$i]->[0]->{search_str} eq "") {
            $search_substr .= '"")'; # Making the string search null
          }
          else {
            $search_substr .= $search_data->{data}->[$i]->[0]->{search_str} . ") ";
          }
        }

        # Check if further search condition exists. If yes, the append 'AND'
        if(defined $search_data->{data}->[$i+1]) {
          $search_substr .= ' AND ';
        }
      }
    }

  }

  # Making query string to download selected data
  my $download_selected_search_substr = "";
  if($args[0] eq 'download_selected') {
    # Create search string with sanger_id, lane_id and public name
    my $arr_sanger = ();
    foreach my $row (@{$search_data->{download_selected}}) {
      if($row->{gss_sanger_id}) {
        push @$arr_sanger, $row->{gss_sanger_id};
      }
    }
    my $str_sanger = '"' . join('","', @$arr_sanger) . '"';
    # Directly use Where condition as we dont have any search conditions above
    $download_selected_search_substr = " WHERE SC.gss_sanger_id IN ($str_sanger) ";
  }

  # Avoid excluded ones from downloading
  my $download_substr = '';
  ###### Currently allowing all data to download
  # if($args[0]=~/download/) {
  #    $download_substr = " AND U.grs_decision <> 0 ";
  # }

  # print Dumper $search_substr;
  ######### $search_substr is used for counting the total

  # Handling site specific data retrieval
  my $site_search = '';
  if(defined $c->user->gpu_institution && $c->user->gpu_institution !~ /Sanger/) {

    my @arr = split(';',$c->user->gpu_institution);
    my $str = join('","', @arr);

    if($download_selected_search_substr ne "" || $search_substr ne "") {
      $site_search = ' AND M.gmd_institution IN ("' . $str . '")';
      if($c->user->get('gpu_username') eq "testuser") {
        $site_search = ' AND M.gmd_study_name = "Global Strain Bank" ';
      }
    }
    else {
      $site_search = ' WHERE M.gmd_institution IN ("' . $str . '")';
      if($c->user->get('gpu_username') eq "testuser") {
        $site_search = ' WHERE M.gmd_study_name = "Global Strain Bank" ';
      }
    }
  }

  my ($sort, $order);
  my $search_suffix = '';
  # Handling sort and pagination variables if asked for
  if($c->request->params->{sort}) {
    $sort = $c->request->params->{sort};
    my $col_prefix = getColumnPrefix($sort);
    $order = ($c->request->params->{order})?$c->request->params->{order}:'asc';
    $search_suffix .= " ORDER BY $col_prefix.$sort $order ";
  }


  my $page =  ($c->request->params->{page})?$c->request->params->{page}:1;
  my $rows = ($c->request->params->{rows})?$c->request->params->{rows}:10;
  my $offset = ($page-1) * $rows;
  if(defined $page && defined $rows && $args[0] !~/download/) {
    $search_suffix .= " LIMIT $offset, $rows ";
  }

  # Concat where condition
  $search_str = $search_str_start . $search_substr . $download_selected_search_substr . $download_substr .$site_search . $search_suffix;

  my $datamap = ();
  my $dataArr = ();
  my $map = {};
  my $t_arr = ();
  $datamap->{rows} = [];

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

  my $sth;
  try {
    $sth = $c->config->{gps_dbh}->prepare($search_str) or die;
    #print Dumper $search_str;
    $sth->execute() or die;
  }
  catch {
    my $res = {'err' => 'Error occured while retrieving data', 'errMsg' => qq{$_}};
    $c->res->body(to_json($res));
    return;
  };

  # If now download, then fetch column headings also
  if($args[0] !~/download/) {
    # Push metadata to the final map
    while(my $row = $sth->fetchrow_hashref) {
      push(@{$datamap->{rows}}, $row);
    }
  }
  else {

    # Creating column names
    if (defined $selected_columns_arr) {
      my @t_selected_columns_arr = @$selected_columns_arr;
      foreach my $colname (@t_selected_columns_arr) {
        $colname =~s/\_/ /g;
        $colname =~s/\b(\w)/\U$1/g;
        $colname = substr($colname, 4);
      }
      push @{$datamap->{rows}}, \@t_selected_columns_arr;
      # Storing rows as array;
      if($sth->rows > 0) {
        while(my $datahash = $sth->fetchrow_hashref) {
          $t_arr = ();
          foreach my $colname (@$selected_columns_arr) {
            push @$t_arr, $datahash->{$colname};
          }
          push @{$datamap->{rows}}, $t_arr;
        }
        $c->res->body(to_json($datamap));
        return;
      }
      else {
        $c->res->body(to_json({'err'=> 'Samples not available for download!'}));
        return;
      }
    }
  }



  # Getting the number of rows.
  $search_str = "SELECT COUNT(*) FROM ($search_str_start $search_substr $download_selected_search_substr $download_substr $site_search) AS TEMP";
  #print Dumper $search_str;
  try {
    $sth = $c->config->{gps_dbh}->prepare($search_str) or $datamap->{err} = "$!";
    $sth->execute() or $datamap->{err} = "$!";
    $datamap->{total} = $sth->fetchrow_array;
  }
  catch {
    my $res = {'err' => 'Error occured while retrieving data', 'errMsg' => qq{$_}};
    $c->res->body(to_json($res));
    return;
  };
  $sth->finish;
  # print Dumper $datamap;
  $c->res->header("Cache-Control", "no-cache, no-store, must-revalidate"); # HTTP 1.1.
  $c->res->header("Pragma", "no-cache"); # HTTP 1.0.
  $c->res->header("Expires", 0); # Proxies.
  $c->res->body(to_json($datamap));

}

sub getColumnPrefix {
  my $col = shift;
  return ($col =~ /^gmd/)? 'M': (($col =~ /^gsd/)? 'S': (($col =~ /^gss/)? 'SC':'U'));
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
