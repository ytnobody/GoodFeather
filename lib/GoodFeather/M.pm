package GoodFeather::M;
use strict;
use warnings;
use Nephia::Incognito;

sub c {
    my $class = shift;
    Nephia::Incognito->unmask('GoodFeather');
}

1;

