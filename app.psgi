use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), 'lib'), 
);
use GoodFeather;

use Plack::Builder;
use Plack::Session::Store::Cache;
use Cache::Memcached::Fast;

my $run_env       = $ENV{PLACK_ENV} eq 'development' ? 'local' : $ENV{PLACK_ENV};
my $basedir       = dirname(__FILE__);
my $config_file   = File::Spec->catfile($basedir, 'config', $run_env.'.pl');
my $config        = require($config_file);
my $cache         = Cache::Memcached::Fast->new($config->{'Cache'});
my $session_store = Plack::Session::Store::Cache->new(cache => $cache);
my $app           = GoodFeather->run(%$config);

builder {
    enable_if { $ENV{PLACK_ENV} =~ /^($:local|dev)$/ } 'StackTrace', force => 1;
    enable 'Static', (
        root => $basedir,
        path => qr{^/static/},
    );
    enable 'Session', (cache => $session_store);
    enable 'CSRFBlock';
    $app;
};

