package Gazprom::Log::FileParser;
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

use Data::Dumper;
use IO::File;

use Gazprom::DB;
use Gazprom::Log::Record;
use Gazprom::Log::MessageRecord;
use Gazprom::Log::MessageDeliveryRecord;
use Gazprom::Log::AdditionalAddressRecord;
use Gazprom::Log::FailedDeliveryRecord;
use Gazprom::Log::DelayedDeliveryRecord;

use constant FLAG_FIELD_IDX => 3;

sub parse_records {
    my $pkg = shift;
    my %params = @_;

    my $config = $params{config} or die "config argument is required";
    my $logger = $params{logger} or die "logger argument is required";
    my $datafile = $params{path} or die "path argument is required";

    die "File not found: $datafile" unless (-e $datafile);

    # Init DB and Record classes
    Gazprom::DB->init(config => $config);
    Gazprom::Log::Record->init(dbh => Gazprom::DB->get_connection());

    $logger->info("Parsing data file: $datafile");
    my $data_fh = IO::File->new($datafile, "r") or
        die "Cannot open file $datafile for reading";

    my $rec_idx = 0;
    while (!$data_fh->eof()) {
        my $line = $data_fh->getline();
        $rec_idx++;
        $logger->debug("Record Index: $rec_idx");
        $logger->debug(sprintf("Record Data: %s", $line));

        # Let's look at what we got here, let's check if we got a flag field
        my @rec = split(' ', $line, 5);
        if ($rec[FLAG_FIELD_IDX]) {
            my $class = '';
            given($rec[FLAG_FIELD_IDX]) {
                $class = 'MessageRecord' when /\<\=/;
                $class = 'MessageDeliveryRecord' when /\=\>/;
                $class = 'AdditionalAddressRecord' when /\-\>/;
                $class = 'FailedDeliveryRecord' when /\*\*/;
                $class = 'DelayedDeliveryRecord' when /\=\=/;
                default {
                    $logger->warn(sprintf("Bad flag! (%s)", $rec[FLAG_FILED_IDX]));
                    continue;
                }
            }
            $class = "Gazprom::Log::$class";
            $log_rec = $class->from_string($line);

        } else {
            $log_rec = Gazprom::Log::Record->from_string($line);
        }
        $log_rec->save();
    }

    $data_fh->close();
}

1;

