package Gazprom::Log::LogRecord;

use strict;
use warnings;

use base qw(Gazprom::Log::Record);
use Gazprom::Log::Record;

use Try::Tiny;

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

sub save {
    my $self = shift;

    my $dbh = Gazprom::Log::LogRecord->SUPER::get_db_connection();
    my $table = $_DATA->{table};
    my $sql = "INSERT INTO $table(created, int_id, str, address) VALUES (?, ?, ?, ?)";
    try {
        my $sth = $dbh->prepare($sql) or die $dbh->errstr();
        $sth->execute(
            $self->{created_at},
            $self->{int_id},
            $self->{str},
            $self->{address}
        ) or die $sth->errstr();
    } catch {
        $dbh->rollback();
        die sprintf("Cannot insert record %s !!! Reason: %s",
            $self->to_string(), $_);
    };
    $dbh->commit();
}

1;
