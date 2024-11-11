package Gazprom::Log::Parser;
# -----------------------------------------------------------------------------
#
# Gazprom::Log::Parser - simple sequential read log parser
#
# Pros:
#   + Uses one line of memory max
#
# Cons:
#   - Slow
#


use strict;
use warnings;
use utf8;

use DBI;
use IO::File;

use Gazprom::Log::Record;

sub parse_records {
    my $pkg = shift;
    my %params = @_;

    my $config = $params{config} or die "config argument is required";
    my $logger = $params{logger} or die "logger argument is required";
    my $datafile = $params{path} or die "path argument is required";

    die "File not found: $datafile" unless (-e $datafile);

    $logger->info("Parsing data file: $datafile");
    my $data_fh = IO::File->new($datafile, "r") or
        die "Cannot open file $datafile for reading";

    my $rec_idx = 0;
    while (!$data_fh->eof()) {
        my $line = $data_fh->readline();
        $rec_idx++;
        $logger->debug("Record Index: $rec_idx");
        $logger->debug(sprintf("Record Data: %s", $line));
        my $log_rec = Gazprom::Log::Record->parse_rec($line);
        $log_rec->save();
    }

    $data_fh->close();
}

1;

