package DBConnect::Controller::JsonUtilityServices;
use Moose;
use namespace::autoclean;
use JSON;
use WWW::Mechanize;
use DBConnect::Controller::SearchGpsDB;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

DBConnect::Controller::JsonUtilityServices - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


# Get json formatted data for GPS project site - googlemap GeoJSON API
# This function takes a column name in gps_metadata column and
# generates a json with its disticnt column values and no. of entries
sub getSampleCount :Path('/json/meta/') {
  my ( $self, $c, @args ) = @_;
  my $map = [];
  if(scalar @args > 0) {
    # Get the column name
    my $colname_search = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{gps_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCount_Country() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{gps_dbh} = $dbh;
    }

    my $q = qq {
      SELECT
        m.$colname_search,
        count(m.$colname_search) as $colname_search\_count,
        c.gco_latitude,
        c.gco_longitude
      FROM gps_sequence_scape s, gps_metadata m, gps_results r, gps_coordinates c
      WHERE m.gmd_public_name = s.gss_public_name
      AND c.gco_location = m.gmd_country
      AND s.gss_sanger_id = r.grs_sanger_id
      AND r.grs_lane_id = s.gss_lane_id
      AND r.grs_decision<>0
      AND m.$colname_search IS NOT NULL
      AND m.$colname_search <> ""
      GROUP BY $colname_search;
    };

    my $sth = $c->config->{gps_dbh}->prepare($q);
    $sth->execute;
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      my $t_map = {};
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        $t_map = {};
        $t_map->{$row->{'gmd_country'}}->{sample_count} = $row->{gmd_country_count};
        $t_map->{$row->{'gmd_country'}}->{lat} = $row->{gco_latitude};
        $t_map->{$row->{'gmd_country'}}->{lng} = $row->{gco_longitude};
        push @{$map}, $t_map;
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Column name not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Column name argument missing');
  }
}

sub getCoordinates :Path('/json/coordinates/') {
  my ( $self, $c, @args ) = @_;
  my $map = [];
  if(scalar @args > 0) {
    # Get the column name
    my $location = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{gps_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCount_Country() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{gps_dbh} = $dbh;
    }

    my $q = qq {
      SELECT
        gco_location,
        gco_latitude,
        gco_longitude
      FROM
        gps_coordinates
      WHERE
        gco_location = ?
    };

    my $sth = $c->config->{gps_dbh}->prepare($q);
    $sth->execute($location);
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      my $t_map = {};
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        $t_map = {};
        $t_map->{$row->{'gco_location'}}->{lat} = $row->{gco_latitude};
        $t_map->{$row->{'gco_location'}}->{lng} = $row->{gco_longitude};
        push @{$map}, $t_map;
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Country not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Country argument missing');
  }
}

# Get json - column + count (Same as the function getSampleCount() in this package,
# but to make it authorised access, we are removing 'json/' form the url)
# This function takes a column name in gps_metadata column and
# generates a json with its disticnt column values and no. of entries
sub getSampleCountAuthorised :Path('/count/meta/') {
  my ( $self, $c, @args ) = @_;
  my $map = {};
  if(scalar @args > 0) {
    # Get the column name
    my $colname_search = $args[0];
    # Reconnect to db if connection available
    if(!$c->config->{gps_dbh}->ping) {
      my $attr = {
          mysql_auto_reconnect => $c->config->{mysql_auto_reconnect},
          AutoCommit => $c->config->{AutoCommit}
      };
      $c->log->warn("Re-connected @ getSampleCountAuthorised() ".$c->config->{dsn});
      my $dbh = DBI->connect($c->config->{dsn},$c->config->{user},$c->config->{password}, $attr);
      $c->config->{gps_dbh} = $dbh;
    }

    my $prefix = DBConnect::Controller::SearchGpsDB::getColumnPrefix($colname_search);

    my $q = qq {
      SELECT
        $prefix.$colname_search,
        count($prefix.$colname_search) as $colname_search\_count
        FROM gps_sequence_scape as SC
        LEFT JOIN gps_sequence_data as S
            ON SC.gss_lane_id = S.gsd_lane_id
        LEFT JOIN gps_results as U
            ON (SC.gss_lane_id = U.grs_lane_id AND SC.gss_sanger_id = U.grs_sanger_id)
            OR (SC.gss_lane_id IS NULL AND SC.gss_sanger_id = U.grs_sanger_id)
        LEFT JOIN gps_metadata as M
            ON SC.gss_public_name = M.gmd_public_name
        GROUP BY $prefix.$colname_search
    };

    my $sth = $c->config->{gps_dbh}->prepare($q);
    $sth->execute;
    # Create a resultset with a groupby clause
    if($sth->rows > 0) {
      while(my $row = $sth->fetchrow_hashref) {
        # Creating a hash of column value and count
        if(defined $row->{$colname_search}) {
          $map->{$row->{$colname_search}}->{sample_count} = $row->{$colname_search.'_count'};
        }
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body('Column name not found');
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body('Column name argument missing');
  }
}

# Populate search drop down
sub populateSearch :Path('/populate_search/') {
  my ( $self, $c, @args ) = @_;
  if (scalar @args > 0) {
    my $colname_search = ();
    push @$colname_search, $args[0];

    my $search_data = {};
    my $qString = &DBConnect::Controller::SearchGpsDB::createQuery($search_data, $colname_search, 'search', $c);
    my $map = {};

    # Get unique list
    $qString =~s/SELECT/SELECT DISTINCT/i;
    my $rs = &DBConnect::Controller::SearchGpsDB::getSearchResults($qString, $c);

    if($rs && $rs->{rows}) {
      # Process JSON to create an array of hash
      foreach my $val (@{$rs->{rows}}) {
        # Creating a hash of column value and count
        push @{$map->{$colname_search->[0]}}, $val->{$colname_search->[0]};
      }
      # Send back json
      $c->res->body(to_json($map));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body(to_json({'error' => 'No data found'}));
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body(to_json({'error' => 'Column name argument missing'}));
  }
}

# Get all rows for selected columns
sub getColumnData :Path('/get_column_data/') {
  my ( $self, $c, @args ) = @_;
  my $postData = $c->request->body_data;
  my $colArr = $postData->{select_columns};

  if ($#$colArr >= 0) {
    my $search_data->{search_input} = ($postData->{search_input} ne '')? decode_json($postData->{search_input}) : ();
    my $qString = &DBConnect::Controller::SearchGpsDB::createQuery($search_data, $colArr, 'search', $c);
    my $rs = &DBConnect::Controller::SearchGpsDB::getSearchResults($qString, $c);
    if($rs) {
      # Send back json
      $c->res->body(to_json($rs));
    }
    else {
      # If no column found then show the 404 template
      $c->res->body(to_json({'error' => 'No data found'}));
    }
  }
  else {
    # If no arguments then show the 404 template
    $c->res->body(to_json({'error' => 'Column name argument missing'}));
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
