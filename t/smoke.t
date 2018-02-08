use strict;
#use warnings;

use Test::More tests => 9;
use Env::C;

# we assume $ENV{USER} exists, but that might not be the case (e.g.: in
# docker).  If not present, just use root.
unless (exists $ENV{USER}) {
    $ENV{USER} = 'root';
    Env::C::setenv('USER', 'root');
}

# on Windows, things work a bit differently. Some %ENV items will not be
# present in the C environment.  We work around this by copying the missing
# items to the C environment.
if ($^O =~ /^MSWin/) {
    # on windows the getenv() names are not upper cased, so we have to get all
    # of the C environment variable names and upcase them for comparison
    # against %ENV
    my %setkeys =
        map { uc($_) => 1 }
        map { (split '=', $_, 2)[0] } @{ Env::C::getallenv() };

    for my $key (sort keys %ENV) {
        unless ($setkeys{$key}) {
            note "Windows: copying missing %ENV value for $key to the C environment";
            Env::C::setenv($key, $ENV{$key});
        }
    }
}

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
is $val, $val_new, "reinstated $key in C env";

my $overwrite = "barbaz";
Env::C::setenv($key, $overwrite, 0);
$val = Env::C::getenv($key) || '';
is $val, $val_new, "do not overwrite $key with explicitly false override";

Env::C::setenv($key, $val_new, 1);
$val = Env::C::getenv($key) || '';
is $val, $val_new, "overwrite $key with explicitly true override";

# restore
Env::C::setenv($key, $val_orig);
$val = Env::C::getenv($key) || '';
is $val, $val_orig, "restored $key (using setenv with implicit override)";

my $env = Env::C::getallenv();

# Windows env names are not all upper cased.  We need to upcase them so the test will match.
# See https://github.com/mschout/env-c/issues/2
if ($^O =~ /^MSWin/) {
    $env = [
        map { join '=', uc $_->[0], $_->[1] }  # join back to uc(name)=value
        map { [split '=', $_, 2] }             # split into [name, value]
        @$env
    ];
}

note '# ', scalar(@$env), ' env entries';
ok @$env;

cmp_ok scalar @$env, '==', scalar keys %ENV;

my @perl_env = map { "$_=$ENV{$_}" } keys %ENV;

is_deeply [sort @$env], [sort @perl_env];
