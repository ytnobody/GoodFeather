{
    appname => 'GoodFeather',
    'Plugin::FormValidator::Lite' => {
        function_message => 'en',
        constants => [qw/Email/],
    },
    ErrorPage => {
        template => 'error.tt',
    },
};

