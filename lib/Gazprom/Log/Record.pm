package Gazprom::Log::Record;

use strict;
use warnings;

my $_DATA = {
    table => 'log'
};

sub init {
    my $pkg = shift;
    my %params = @_;
    die "dbh is required" unless $params{dbh};

    $_DATA->{dbh} = $params{dbh};
}

sub from_string {
    my $pkg = shift;
    my $string = shift or die "string is required";

    my @rec = split(' ', $string, 4);
    my $self = {
        created_at => join(' ', @rec[0 .. 1]),
        int_id => $rec[2],
        str => join(' ', @rec[2 .. 3]),
        address => ''
    };
    bless $self, $pkg;
    return $self;
}

sub save {
    my $self = shift;
    die "Not implemented!";
}

1;
