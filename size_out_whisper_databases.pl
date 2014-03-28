#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

my $whisper_bin = '/usr/local/bin/whisper-create.py';
my $junk_whisper_file = '/tmp/junk.wsp';
my $intervals;

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

foreach my $interval (keys(%{$intervals}))
{
	system("$whisper_bin $junk_whisper_file $interval > /dev/null");
		
	if (-e '/tmp/junk.wsp')
	{
		print "$interval " . human_size(size => -s $junk_whisper_file) . "\n";
		unlink($junk_whisper_file);
	}
}

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
	return sprintf "%.2f %s", $size, ( qw[ bytes KB MB GB ] )[ $n ];
}
