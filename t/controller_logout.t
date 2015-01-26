use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DBConnect';
use DBConnect::Controller::logout;

ok( request('/logout')->is_success, 'Request should succeed' );
done_testing();
