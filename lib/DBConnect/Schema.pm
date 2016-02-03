use utf8;
package DBConnect::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';
extends 'DBIx::Class::Schema::Loader';

__PACKAGE__->load_namespaces;
__PACKAGE__->loader_options(
  preserve_case => 1
);

# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-06-06 12:00:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GLtiEGagOIyoamdMhQDE+A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
