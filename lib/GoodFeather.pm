package GoodFeather;
use strict;
use warnings;
use Data::Dumper ();
use URI;
use Nephia::Incognito;
use Nephia plugins => [
    'FillInForm',
    'FormValidator::Lite',
    'JSON' => {
        enable_api_status_header => 1,
    },
    'View::Xslate' => {
        syntax => 'TTerse',
        path   => [ qw/view/ ],
        function => {
            c    => \&c,
            dump => sub {
                local $Data::Dumper::Terse = 1;
                Data::Dumper::Dumper(shift);
            },
            uri_for => sub {
                my $path = shift;
                my $env = c()->req->env;
                my $uri = URI->new(sprintf(
                    '%s://%s%s',
                    $env->{'psgi.url_scheme'},
                    $env->{'HTTP_HOST'},
                    $path
                ));
                $uri->as_string;
            },
        },
    },
    'ErrorPage',
    'ResponseHandler',
    'Dispatch',
];

sub c () {Nephia::Incognito->unmask(__PACKAGE__)}

app {
    get  '/' => Nephia->call('C::Root#index');
    get  '/discuss/form' => Nephia->call('C::Discuss#form');
    get  '/discuss/:id' => Nephia->call('C::Discuss#detail');

    get  '/api/discuss/create' => Nephia->call('C::API::Discuss#create');
    get  '/api/discuss/search' => Nephia->call('C::API::Discuss#search');
    get  '/api/discuss/recent' => Nephia->call('C::API::Discuss#recent');
    get  '/api/discuss/:id/add_name' => Nephia->call('C::API::Discuss#add_name');
    get  '/api/discuss/:id' => Nephia->call('C::API::Discuss#fetch');
};

1;

