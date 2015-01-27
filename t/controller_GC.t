use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DBConnect';
use DBConnect::Controller::GC;

ok( request('/gc')->is_success, 'Request should succeed' );
done_testing();
