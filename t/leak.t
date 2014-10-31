#!/usr/bin/env perl
#
# Test fix for RT #49872
#

use strict;
use Test::More;
use Env::C;

if (is_known_leaky_platform()) {
    plan skip_all => "setenv() is known to leak on this platform";
}

unless (-f '/proc/self/statm') {
    plan skip_all => 'this test requires /proc/self/statm';
}

Env::C::setenv(TZ => 'GMT');

my $start_size = memusage();

for (1..300000) {
    $ENV{TZ} = 'GMT';
    $ENV{TZ} = '';
}

my $end_size = memusage();

cmp_ok $end_size, '==', $start_size, 'setenv does not leak';

done_testing;

sub is_known_leaky_platform {
    # freebsd < 5.19.6 uses PL_use_safe_putenv, which leaks, but is necessary
    # to avoid SIGV
    return 1 if $^O eq 'freebsd' and $] < 5.019006;

    return 0;
}

sub is_memusage_supported {
    return 1 if -f "/proc/self/statm";
}

sub memusage {
    my $pid = $$;

    my ($size) = split /\s+/, slurp('/proc/self/statm');

    return $size;
}

sub slurp {
    my $file = shift;

    local $/ = undef;

    open my $fh, '<', $file or die "failed to open $file: $!";

    my $content = <$fh>;

    return $content;
}
