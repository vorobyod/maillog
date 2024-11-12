package Gazprom::Log::Record;

use strict;
use warnings;

my $_DATA = {};

sub init {
    my $pkg = shift;
    my %params = @_;
    die "dbh is required" unless $params{dbh};

    $_DATA->{dbh} = $params{dbh};
}

sub from_string {
    my $pkg = shift;
    my $data_str = shift or die "data_str is required";


}

1;
