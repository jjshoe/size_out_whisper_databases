#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

my $whisper_bin = '/usr/local/bin/whisper-create.py';
my $junk_whisper_file = '/tmp/junk.wsp';
my $intervals;
my $checks = 1;
my $machines = 1;
my $help;
my $total_size;

GetOptions
(
	'help|?' => \$help,
	"whisper_bin=s" => \$whisper_bin,
	"checks=i" => \$checks,
        "machines=i" => \$machines,
) or pod2usage(2);

if ($help)
{
	pod2usage(1);
}

foreach my $argument (@ARGV)
{
	my @intervals;
	
	if ($argument =~ /,/)
	{
		@intervals = split(',', $argument);
	}
	else
	{
		push(@intervals, $argument);
	}

	foreach my $interval (@intervals)
	{
		$intervals->{$interval} = 1;
	}
}

foreach my $interval (sort time_unit keys(%{$intervals}))
{
	system("$whisper_bin $junk_whisper_file $interval > /dev/null");
		
	if (-e $junk_whisper_file)
	{
		my $size = (-s $junk_whisper_file) * $checks * $machines;
		$total_size += $size;

		print "$interval " . human_size(size => $size) . "\n";
		unlink($junk_whisper_file);
	}
}

print "\n";
print "Size per check: " . human_size(size => $total_size / $checks) . "\n";
print "Size per machine: " . human_size(size => $total_size / $machines) . "\n";
print "Total size: " . human_size(size => $total_size) . "\n";

sub unravel_units
{
	my %in = @_;

	my $unit = $in{'unit'};
        my $time = $in{'time'};

	if ($unit eq 's')
	{
		return $time;
	}
	elsif ($unit eq 'm')
	{
		return $time * 60;
	}
	elsif ($unit eq 'h')
	{
		return $time * 60 * 60;
	}
	elsif ($unit eq 'd')
	{
		return $time * 60 * 60 * 24;
	}
	elsif ($unit eq 'y')
	{
		return $time * 60 * 60 * 24 * 365;
	}
}

sub human_size
{
	my %in = @_;
	my $size = $in{'size'};
	my $n = 0;

	++$n and $size /= 1024 until $size < 1024;
	return sprintf "%.2f %s", $size, ( qw[ bytes KB MB GB TB PB] )[ $n ];
}

sub time_unit
{
	if (($a =~ /s:/ && $b =~ /[mdy]:/) || ($a =~ /m:/ && $b =~ /[dy]:/) || ($a =~ /d:/ && $b =~ /[y]:/))
	{
		return -1;
	} 
	elsif (($a =~ /y:/ && $b =~ /[smd]:/) || ($a =~ /d:/ && $b =~ /[sm]:/) || ($a =~ /m:/ && $b =~ /s:/))
	{
		return 1;
	}
	else
	{
		# Same unit, sort by number pre-unit
		$a =~ /^(\d+)[smdy]:/;		
		my $left_number = $1;
		
		$b =~ /^(\d+)[smdy]:/;		
		my $right_number = $1;
	
		return $left_number <=> $right_number;
	}
}

__END__
=head1 NAME
size_out_whisper_database.pl - Get the size of various retention policies

=head1 SYNOPSIS

size_out_whisper_database.pl [options] retention_policy

  Options:
    --help              Brief help message
    --checks            Number of checks on a machine
    --machines          Number of machines the policy applies to
    --whisper_bin       Specify whisper-checks binary path

=head1 OPTIONS

=over 8

=item B<--help>

Prints a brief help message and exits

=item B<--checks>

The number of checks you're running on a single machine

=item B<--machines> 

The number of machines the specified retention policy applies to

=item B<--whisper_bin>

Specify the location of your whisper-checks binary

=back

=cut
