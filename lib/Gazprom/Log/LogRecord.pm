package Gazprom::Log::LogRecord;

use strict;
use warnings;

use base qw(Gazprom::Log::Record);
use Gazprom::Log::Record;

my $_DATA = {
    table => 'log'
};

sub from_string {
    my $pkg = shift;
    my $string = shift or die "string is required";

    my @rec = split(' ', $string, 6);
    chop($rec[4]) if ($rec[4] =~ /:$/);
    my $self = {
        created_at => join(' ', @rec[0 .. 1]),
        int_id => $rec[2],
        str => join(' ', @rec[2 .. 5]),
        address => $rec[4]
    };
    bless $self, $pkg;
    return $self;
}

1;
