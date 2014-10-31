#!/usr/bin/env perl
#
# Test fix for RT #49872
#

use strict;
use Test::More;
use Env::C;

if (is_known_leaky_platform()) {
    plan skip_all => "setenv is known to leak on this platform";
}

unless (eval { require Proc::ProcessTable }) {
    plan skip_all => "this test requires Proc::ProcessTable";
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
    return 1 if $^O eq 'freebsd' and $] <= 5.019006;
    return 0;
}

sub memusage {
    my $pid = $$;

    my $proc = Proc::ProcessTable->new;

    my %fields = map { $_ => 1 } $proc->fields;
    return 0 unless exists $fields{'pid'};

    for my $ps (@{$proc->table}) {
        if ($ps->pid eq $pid) {
            return $ps->size;
        };
    };
}
