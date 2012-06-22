use strict;
#use warnings;

use Test::More tests => 7;
use Env::C;

# getenv
my $key = "USER";
my $val_orig = Env::C::getenv($key);
is $val_orig, $ENV{$key}, "getenv matches perl ENV for $key";

# unsetenv
Env::C::unsetenv($key);
my $val = Env::C::getenv($key);
is $val, undef, "$key is no longer set in C env";

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

cmp_ok scalar @$env, '==', scalar keys %ENV;

my @perl_env = map { "$_=$ENV{$_}" } keys %ENV;
is_deeply [sort @$env], [sort @perl_env];
