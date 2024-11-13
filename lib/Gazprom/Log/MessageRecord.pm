package Gazprom::Log::MessageRecord;

use strict;
use warnings;

use base qw(Gazprom::Log::Record);
use Gazprom::Log::Record;

use Try::Tiny;

my $_DATA = {
    table => 'message'
};

sub from_string {
    my $pkg = shift;
    my $string = shift or die "string is required";

    my @rec = split(' ', $string, 6);
    my ($message_id) = $rec[5] =~ /id=(.*)$/;
    my $self = {
        created_at => join(' ', @rec[0 .. 1]),
        id => $message_id,
        int_id => $rec[2],
        str => join(' ', @rec[2 .. 5])
    };
    bless $self, $pkg;
    return $self;
}

sub match_flag {
    my $pkg = shift;
    my $flag = shift or die "flag required";

    return ($flag eq '<=') ? 1 : 0;
}

sub save {
    my $self = shift;

    my $dbh = Gazprom::Log::MessageRecord->SUPER::get_db_connection();
    my $table = $_DATA->{table};
    my $sql = "INSERT INTO $table(created, id, int_id, str) VALUES (?, ?, ?, ?)";
    try {
        my $sth = $dbh->prepare($sql) or die $dbh->errstr();
        $sth->execute(
            $self->{created_at},
            $self->{id},
            $self->{int_id},
            $self->{str}
        ) or die $sth->errstr();
    } catch {
        $dbh->rollback();
        die sprintf("Cannot insert record %s !!! Reason: %s",
            $self->to_string(), $_);
    };
    $dbh->commit();
}

1;
