use strict;
#use warnings;

use Test::More tests => 5;
use Env::C;

# getenv
my $key = "USER";
my $val_orig = Env::C::getenv($key) || '';
is $val_orig, $ENV{$key}, "getenv matches perl ENV for $key";

# unsetenv
diag "unsetting an env";
Env::C::unsetenv($key);
diag "getting it";
my $val = Env::C::getenv($key);
is $val, undef, "$key is no longer set in C env";

# setenv
my $val_new = "foobar";
Env::C::setenv($key, $val_new);
diag "called setenv";
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
