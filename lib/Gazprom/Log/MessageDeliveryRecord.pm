package Gazprom::Log::MessageDeliveryRecord;

use strict;
use warnings;

use base qw( Gazprom::Log::LogRecord );
use Gazprom::Log::LogRecord;

sub from_string {
    my $pkg = shift;
    my $string = shift or die "string is required";

    my $self = {};

    if ($string =~ /:blackhole: \</) {
        # Special parse case - blackhole mail router{
        my @rec = split(' ', $string, 7);
        my ($address) = $rec[5] =~ /\<(.*)\>/;
        $self = {
            created_at => join(' ', @rec[0 .. 1]),
            int_id => $rec[2],
            str => join(' ', @rec[2 .. 6]),
            address => $address
        };
    } else {
        # Normal delivery log records
        $self = $pkg->SUPER::from_string($string);
    }

    bless $self, $pkg;
    return $self;
}

sub match_flag {
    my $pkg = shift;
    my $flag = shift or die "flag required";

    return ($flag eq '=>') ? 1 : 0;
}

1;
