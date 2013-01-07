#!/usr/bin/perl
use utf8;
use strict;
use warnings;

use POSIX;
use YAML::Tiny;

require "functions.pl";

## Declare variables
my $config 		= 	YAML::Tiny->read('config.yml')
				or die YAML::Tiny->errstr;
my $date		=	strftime "%F %T", localtime $^T;

my $logfile		= 	$config->[0]->{general}->{logfile};
my $connections		=	$config->[0]->{connections};

my $torrent_id		=	$ARGV[0];
my $torrent_name	=	$ARGV[1];
my $torrent_path	=	$ARGV[2];

## Start logging
open (STDERR, ">>", $logfile);
open (LOG, ">>",  $logfile) or die "Couldn't open $logfile: $!\n";

print LOG "$date - [COMPLETED] $torrent_path/$torrent_name\n"; 
## Here we go!
for my $users (sort keys %{$connections}) {
	my $userblock 	= $connections->{$users};
	my $login	= $userblock->{'login'};
	my $destination = $userblock->{'destination'};
	my $host	= $userblock->{'host'};
	my $transfer	= $userblock->{'transfer'};
	my $email	= $userblock->{'email'};
	
	## Iterate over all the RegExes
	for (sort @{$transfer}) {
		for my $match_name (sort keys %{$_}) {
			my $snatch  	=	$_->{$match_name}->{match};
			my $location	=	$_->{$match_name}->{location};
			## Clean up the regex key, and the username, convert _ to spaces.
			$match_name 	=~ 	tr/_/ /;
			$users		=~	tr/_/ /;
			if ( $torrent_name =~ m/$snatch/i ) {
				## Setup the mail subject and content
				my $subject 	=	"Torrent Transferred ($match_name)";
				my $content	=	"Hello $users.\n$torrent_name has been successfully transferred to you.";
				## If there is an alternate download location, change the destination to match this.
				if ($location) { $destination = $destination."$location/"; }
				## Start RSYNC'ing
				&rsync($torrent_path, $torrent_name, $login, $host, $destination)
					or die "$date - [FAILED] - $torrent_name to $users\n";
				print LOG "$date - [TRANSFERRED] $torrent_name to $users\n";
				## Might as well send an email if the user has one.
				&send_mail($email, $subject, $content ) if ($email);
				
			} 
		}
	}
}
