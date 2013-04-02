#!/usr/bin/env perl
#
# Test fix for RT #49872
#

use strict;
use Test::More;
use Env::C;

my $Statm = "/proc/$$/statm";

plan skip_all => "this test requires $Statm" unless -f $Statm;

Env::C::setenv(TZ => 'GMT');

my $start_size = proc_size();

for (1..300000) {
    $ENV{TZ} = 'GMT';
    $ENV{TZ} = '';
}

cmp_ok $start_size, '==', proc_size(), 'setenv does not leak';

done_testing;

sub proc_size {
    local $/ = undef;

    my ($size) = split /\s+/, slurp($Statm);

    return $size;
}

sub slurp {
    my $file = shift;

    open my $fh, '<', $file or die "failed to open $file: $!";

    my $content = <$fh>;

    return $content;
}
