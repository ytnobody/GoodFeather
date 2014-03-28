package GoodFeather::C::Discuss;
use strict;
use warnings;
use utf8;

use GoodFeather::M::DB::Discuss;

sub form {
    {template => 'discuss/form.tt'};
}

sub detail {
    my $c = shift;
    my $id = $c->path_param('id');
    my $discuss = GoodFeather::M::DB::Discuss->fetch($id) || return $c->res_404;
    {template => 'discuss/detail.tt', discuss => $discuss};
}

1;
