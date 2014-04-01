package GoodFeather::M::DB::Comment;
use strict;
use warnings;
use parent 'GoodFeather::M::DB';
use utf8;

sub table {'comments'};

sub search_by_discuss_id {
    my ($class, $discuss_id) = @_;
    $class->search({discuss_id => $discuss_id}, {order_by => 'created_at DESC'});
}

1;
