package GoodFeather::M::Cache;
use strict;
use warnings;
use parent 'GoodFeather::M';
use Cache::Memcached::Fast;

our $AUTOLOAD;

my $cache;

sub AUTOLOAD {
    my $class = shift;
    my ($method) = $AUTOLOAD =~ m/::([a-z_]+)$/;
    $class->cache->$method(@_);
}

sub cache {
    my $class = shift;
    my $config = $class->c->{config}{Cache};
    $cache ||= Cache::Memcached::Fast->new($config);
    $cache;
}

1;

