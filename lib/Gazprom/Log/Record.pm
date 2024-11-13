package Gazprom::Log::Record;

use strict;
use warnings;

use Data::Dumper;

use constant FLAG_FIELD_IDX => 3;

my $_DATA = {};

sub init {
    my $pkg = shift;
    my %params = @_;
    die "dbh is required" unless $params{dbh};

    $_DATA->{dbh} = $params{dbh};
}

sub flag_from_string {
    my $pkg = shift;
    my $line = shift or die "line is required";

    my @rec = split(' ', $line, 5);
    return $rec[FLAG_FIELD_IDX];
}

sub from_string {
    my $pkg = shift;
    die "Not implemented!";
}

sub to_string {
	my $self = shift;

	local $Data::Dumper::Indent = 0;
	local $Data::Dumper::Sortkeys = sub {
		my ($hash) = @_;
		my %refval = ('' => -3, 'HASH' => -2, 'ARRAY' => -1);
		return [ sort {
			# prefer ref(val) "" to "HASH" to "ARRAY" to anything else
			$refval{ref $hash->{$a}} <=> $refval{ref $hash->{$b}}
			# and then sort lexicographically
			|| $a cmp $b 
		} keys %$hash ];
	};
	my $obj_str = Dumper($self);
	$obj_str =~ s/'(\w+)' => /$1=>/g;
	$obj_str =~ s/^\$VAR1 = //;
	return $obj_str;
}

sub save {
    my $self = shift;
    die "Not implemented!";
}

1;
