package Gazprom::DB;

use strict;
use warnings;

my $config = '';

sub init {
    my $pkg = shift;
    my %params = @_;

    $config = $params{config} or die "config argument is required";
}

1;
