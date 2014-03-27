package GoodFeather::C::Root;
use strict;
use warnings;
use utf8;

sub index {
    my $c = shift;
    { template => 'index.tt' };
}

1;

