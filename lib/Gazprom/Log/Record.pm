package Gazprom::Log::Record;

use strict;
use warnings;

use constant FLAG_FIELD_IDX => 3;

my $_DATA = {};

sub init {
    my $pkg = shift;
    my %params = @_;
    die "dbh is required" unless $params{dbh};

    $_DATA->{dbh} = $params{dbh};
}

sub flag_from_string {
    my $pkg = shift;
    my $line = shift or die "line is required";

    my @rec = split(' ', $line, 5);
    return $rec[FLAG_FIELD_IDX];
}

sub from_string {
    my $pkg = shift;
    die "Not implemented!";
}

sub save {
    my $self = shift;
    die "Not implemented!";
}

1;
