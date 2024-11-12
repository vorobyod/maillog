package Gazprom::DB;

use strict;
use warnings;

use DBI;

my $_DATA = {};

sub init {
    my $pkg = shift;
    my %params = @_;

    my $config = $params{config} or die "config argument is required";
    $_DATA->{config} = $config->{database} or
        die "database section not found in supplied config data";
}

sub get_connection {
    my $pkg = shift;
    my $config = $_DATA->{config};

    my $dsn = sprintf("dbi:Pg:dbname=%s;host=%s;port=%s",
        $config->{db_name},
        $config->{db_host},
        $config->{db_port}
    );
    my %options = (
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 0
    );
    my $dbh = DBI->connect($dsn, $config->{db_user}, $config->{db_password}, \%options) or
        die "Cannot connect to DB! Error: ".$DBI::errstr;
    return $dbh;
}

1;
