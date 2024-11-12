package Gazprom::Config;

use strict;
use warnings;

use Config::General;

sub get_config {
    my $pkg = shift;
    my $config_file = shift or die "config filename is required";

    my $conf = Config::General->new($config_file);
    return { $conf->getall() };
}

sub validate {
    my $pkg = shift;
    my $config = shift or die "config hash is required";

    foreach my $param (qw(threads dataset_size)) {
        unless (exists $config->{'parser'}{$param}) {
            die("please provide a value for parser/$param or set it as --${param}");
        }
    }
    foreach my $param (qw(db_host db_port db_user db_password db_name)) {
        unless (exists $config->{'database'}{$param}) {
            die("please provide a value for database/$param or set it as --${param}");
        }
    }
}

1;
