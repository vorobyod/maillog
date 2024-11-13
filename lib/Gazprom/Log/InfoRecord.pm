package Gazprom::Log::InfoRecord;

use strict;
use warnings;

use base qw( Gazprom::Log::LogRecord );
use Gazprom::Log::LogRecord;

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

1;
