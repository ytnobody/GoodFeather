package GoodFeather::M::DB::Discuss;
use strict;
use warnings;
use parent 'GoodFeather::M::DB';
use Carp;
use GoodFeather::M::DB::Comment;

sub table { 'discuss' }

sub create {
    my ($class, %opts) = @_;
    my $now = time();
    $opts{created_at} = $now;
    $opts{updated_at} = $now;
    $class->SUPER::create(%opts);
}

sub fetch {
    my ($class, $id) = @_;
    my $discuss = $class->single(id => $id);
    if (defined $discuss) {
        my @comments = GoodFeather::M::DB::Comment->search_by_discuss_id($id);
        $discuss->{comments} = [@comments];
    }
    $discuss;
}

sub search_by_word {
    my ($class, $str) = @_;
    return unless $str;

    my $like = sprintf('%%%s%%', $str);
    $class->db->search_by_sql('SELECT * FROM discuss WHERE description LIKE ? LIMIT 30', [$like]);
}

sub recent {
    my $class = shift;
    $class->search({}, {order_by => 'created_at DESC', limit => 30});
}

sub recent_noname {
    my $class = shift;
    $class->search({name => undef}, {order_by => 'created_at DESC', limit => 30});
}

sub recent_named {
    my $class = shift;
    $class->search({name => {'<>' => undef}}, {order_by => 'created_at DESC', limit => 30});
}

sub add_name {
    my ($class, $id, $name) = @_;

    my $row = $class->fetch($id);
    croak(sprintf('discuss with id:%s is not exists', $id)) unless $row;
    croak(sprintf('discuss already named as %s', $row->{name})) if defined $row->{name};

    $class->update({name => $name}, {id => $id});
}

1;

