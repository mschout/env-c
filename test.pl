use strict;
#use warnings;

use Test;

BEGIN { plan tests => 6 };
use Env::C;
ok 1 ;

# getenv
my $key = "USER";
my $val_orig = Env::C::getenv($key) || '';
print "# [$key] '$val_orig'\n";
ok $val_orig eq $ENV{$key} ? 1 : 0;

# unsetenv
Env::C::unsetenv($key);
my $val = Env::C::getenv($key) || '';
print "# [$key] expecting '', got '$val'\n";
ok $val eq '' ? 1 : 0;

# setenv
my $val_new = "foobar";
Env::C::setenv($key, $val_new);
$val = Env::C::getenv($key) || '';
print "# [$key] expecting '$val_new', got '$val'\n";
ok $val eq $val_new ? 1 : 0;

# restore
Env::C::setenv($key, $val_orig);
$val = Env::C::getenv($key) || '';
print "# [$key] expecting '$val_orig', got '$val'\n";
ok $val eq $val_orig ? 1 : 0;

my $env = Env::C::getallenv();
print "# ", scalar(@$env), " env entries\n";
#print join "\n", @$env;
ok @$env;
