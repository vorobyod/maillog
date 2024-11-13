package Gazprom::Log::MessageDeliveryRecord;

use strict;
use warnings;

use base qw( Gazprom::Log::Record );

sub from_string {
    my $pkg = shift;
    die "Not implemented";
}

sub match_flag {
    my $pkg = shift;
    my $flag = shift or die "flag required";

    return ($flag eq '=>') ? 1 : 0;
}

1;
