use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DBConnect';
use DBConnect::Controller::login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
