package GoodFeather::M::DB;
use strict;
use warnings;
use parent 'GoodFeather::M';
use Otogiri;
use Data::Page::Navigation;

my $db;

sub table {
    my $class = shift;
    die "do not call directly $class";
}

sub db {
    my $class = shift;
    my $config = $class->c->{config}{DBI};
    $db ||= Otogiri->new(%$config);
    unless($db->dbh->ping) {
        $db = Otogiri->new(%$config);
    }
    $db;
}

sub create {
    my ($class, %opts) = @_;
    $class->db->insert($class->table, {%opts});
}

sub update {
    my ($class, $set, $cond) = @_;
    $class->db->update($class->table, $set, $cond);
}

sub search {
    my ($class, $cond, $opts) = @_;
    $class->db->select($class->table, $cond, $opts);
}

sub search_with_pager {
    my ($class, $cond, $opts) = @_;
    my $items_per_page = delete $opts->{rows}  || 10;
    my $current_page   = delete $opts->{page}  || 1;
    my $pages_per_nav  = delete $opts->{pages} || 10;
    my ($total_query, @total_bind) = $class->db->maker->($class->table, ['COUNT(*) AS total'], $cond);
    my ($total) = $class->db->search_by_sql($total_query, [@total_bind], $class->table);
    my @rows = $class->search($class->table, $cond, $opts);
    my $pager = Data::Page->new(
        $total->{total},
        $items_per_page,
        $current_page
    );
    (\@rows, $pager);
}

sub single {
    my ($class, %cond) = @_;
    $class->db->single($class->table, {%cond});
}

sub delete {
    my ($class, %cond) = @_;
    $class->db->delete($class->table, {%cond});
}

sub txn {
    my $class = shift;
    $class->db->txn_scope;
}

sub last_insert_id {
    my ($class, $args) = @_;
    $class->db->last_insert_id($class);
}

1;

