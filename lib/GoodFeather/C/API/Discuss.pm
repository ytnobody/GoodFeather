package GoodFeather::C::API::Discuss;
use strict;
use warnings;
use utf8;
use GoodFeather::M::DB::Discuss;
use GoodFeather::M::Cache;

sub create {
    my $c = shift;

    my $valid = $c->form(
        description  => ['NOT_NULL', ['LENGTH', 1, 140]],
        post_by      => ['NOT_NULL', ['LENGTH', 1, 32]],
    );
    return {status => 400, message => $valid->get_error_messages} if $valid->has_error;

    my $discuss = GoodFeather::M::DB::Discuss->create(
        description => $c->param('description'),
        post_by     => $c->param('post_by'),
    );
    return {discuss => $discuss};
}

sub fetch {
    my $c = shift;
    my $id = $c->path_param('id');

    return {status => 403, message => 'id is required'} unless $id;

    my $discuss = GoodFeather::M::Cache->get("discuss:$id") || GoodFeather::M::DB::Discuss->fetch($id);
    GoodFeather::M::Cache->set("discuss:$id", $discuss, 300) if $discuss;
    return $discuss ? {discuss => $discuss} : {status => 404, message => 'discuss not found'};
}

sub search {
    my $c = shift;

    my $valid = $c->form(query => ['NOT_NULL', ['LENGTH', 1, 140]]);
    return {status => 400, message => $valid->get_error_messages} if $valid->has_error;

    my $query = $c->param('query');
    my @rows = GoodFeather::M::DB::Discuss->search_by_word($query);
    return {rows => scalar(@rows), discusses => [@rows]};
}

sub recent {
    my $c = shift;

    my @rows = GoodFeather::M::DB::Discuss->recent;
    return {discusses => [@rows]};
}

sub add_name {
    my $c = shift;

    my $valid = $c->form(name => ['NOT_NULL', ['LENGTH', 1, 140]]);
    return {status => 400, message => $valid->get_error_messages} if $valid->has_error;

    my $id = $c->path_param('id');
    my $name = $c->param('name');

    my $res = eval { GoodFeather::M::DB::Discuss->add_name($id, $name) };
    return 
        defined @$ ? {status => 500, message => $@} : 
        !$res ? {status => 500, message => 'already named'} :
        {result => $res} 
    ;
}

1;

