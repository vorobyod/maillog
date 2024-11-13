package Gazprom::Log::FailedDeliveryRecord;

use strict;
use warnings;

use base qw( Gazprom::Log::LogRecord );
use Gazprom::Log::LogRecord;

sub match_flag {
    my $pkg = shift;
    my $flag = shift or die "flag required";

    return ($flag eq '**') ? 1 : 0;
}

1;
