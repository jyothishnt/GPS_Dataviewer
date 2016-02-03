use utf8;
package DBConnect::Schema::Result::GpsUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBConnect::Schema::Result::GpsUser

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<gps_users>

=cut

__PACKAGE__->table("gps_users");

=head1 ACCESSORS

=head2 gpu_id

  data_type: 'integer'
  is_nullable: 0

=head2 gpu_username

  data_type: 'text'
  is_nullable: 1

=head2 gpu_password

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 gpu_email_address

  data_type: 'text'
  is_nullable: 1

=head2 gpu_name

  data_type: 'text'
  is_nullable: 1

=head2 gpu_institution

  data_type: 'text'
  is_nullable: 1

=head2 gpu_country

  data_type: 'text'
  is_nullable: 1

=head2 gpu_role

  data_type: 'text'
  is_nullable: 1

=head2 gpu_active

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "gpu_id",
  { data_type => "integer", is_nullable => 0 },
  "gpu_username",
  { data_type => "text", is_nullable => 1 },
  "gpu_password",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "gpu_email_address",
  { data_type => "text", is_nullable => 1 },
  "gpu_name",
  { data_type => "text", is_nullable => 1 },
  "gpu_institution",
  { data_type => "text", is_nullable => 1 },
  "gpu_country",
  { data_type => "text", is_nullable => 1 },
  "gpu_role",
  { data_type => "text", is_nullable => 1 },
  "gpu_active",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gpu_id>

=back

=cut

__PACKAGE__->set_primary_key("gpu_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-02-03 14:23:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JL9fC/YidEypOMR6Nk0m/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
