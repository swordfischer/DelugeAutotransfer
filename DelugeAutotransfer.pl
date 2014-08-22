#!/usr/bin/perl
use utf8;
use strict;
use warnings;
use Cwd;

use POSIX;
use YAML::Tiny;

my $pwd				=   cwd();
my $config 			=	YAML::Tiny->read("$pwd/config.yml")
					or die YAML::Tiny->errstr;
our $date			=	strftime "%F %T", localtime $^T;

my $logfile			= 	$config->[0]->{general}->{logfile};
my $connections		=	$config->[0]->{connections};

my $torrent_id		=	$ARGV[0];
my $torrent_name	=	$ARGV[1];
my $torrent_path	=	$ARGV[2];
   $torrent_path    =~  s/\/\z//;

## Start logging
open (STDERR, ">>", $logfile);
open (LOG, ">>",  $logfile) or die "Couldn't open $logfile: $!\n";

print LOG "$date - [COMPLETED] $torrent_path/$torrent_name\n"; 
for my $users (sort keys %{$connections}) {
	my $userblock	= $connections->{$users};
	my $login		= $userblock->{'login'};
	my $password	= $userblock->{'password'};
	my $destination	= $userblock->{'destination'};
	my $host		= $userblock->{'host'};
	my $port		= $userblock->{'port'};
	my $transfer	= $userblock->{'transfer'};
	my $email		= $userblock->{'email'};
	my $transmethod = $userblock->{'method'};
	if ( $email ) {
		require "$pwd/mail.pl"
		or die "$date - [MODULE] Unable to load module EMAIL\n";
	}
	if ( $transmethod =~ m/ftp/) {
		require "$pwd/ftp.pl"
		or die "$date - [MODULE] Unable to load module FTP\n";
	}
	if ( $transmethod =~ m/rsync/) {
		require "$pwd/rsync.pl"
		or die "$date - [MODULE] Unable to load module RSYNC\n";
	}
	for (sort @{$transfer}) {
		for my $match_name (sort keys %{$_}) {
				my $snatch		=	$_->{$match_name}->{match};
				my $location	=	$_->{$match_name}->{location};
				$match_name 	=~	tr/_/ /;
				$users			=~	tr/_/ /;
				if ( $torrent_name =~ m/$snatch/i ) {
					my $subject = "Torrent Transferred ($match_name)";
					my $content	= "Hello $users.\n$torrent_name has been successfully transferred to you.";
					if ($location) { $destination = $destination."$location/"; }
				if ($transmethod =~ m/ftp/) {
					print LOG "$date - [STARTING] ($transmethod) - $torrent_name to $users\n";
					&ftp($torrent_path, $torrent_name, $login, $password, $host, $destination)
						or die "$date - [FAILED] ($transmethod) - $torrent_name to $users\n";
					}
					elsif ($transmethod =~ m/rsync/) {
					print LOG "$date - [STARTING] ($transmethod) - $torrent_name to $users\n";
					&rsync($torrent_path, $torrent_name, $login, $host, $port, $destination)
						or die "$date - [FAILED] ($transmethod) - $torrent_name to $users\n";
					}
				print LOG "$date - [TRANSFERRED] ($transmethod) - $torrent_name to $users\n";
				&send_mail($email, $subject, $content ) if ($email);
				
			} 
		}
	}
}
