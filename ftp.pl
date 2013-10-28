#!/usr/bin/perl
use utf8;
use strict;
use warnings;

use Net::FTP::Recursive;

our $date;

sub ftp {
	my $spath		=		$_[0];
	my $sname		=		$_[1];
	my $duser		=		$_[2];
	my $dpass		=		$_[3];
	my $dhost		=		$_[4];
	my $ddest		=		$_[5];

if ( -f "$spath/$sname" ) {
	chdir ("$spath")
		or die "$date - [MODULE / FTP] Cannot change directory: $!";
	our	$ftp	=	Net::FTP->new("$dhost", Debug => 0, Passive => 1)
					or die "$date - [MODULE / FTP] Cannot connect to $dhost: $@";
}
elsif ( -d "$spath/$sname" ) {
	chdir ("$spath/$sname")
		or die "$date - [MODULE / FTP] Cannot change directory: $!";
	our	$ftp	=	Net::FTP::Recursive->new("$dhost", Debug => 0, Passive => 1)
					or die "$date - [MODULE / FTP] Cannot connect to $dhost: $@";
}
	our $ftp;
		$ftp	->	login("$duser", "$dpass")
					or die "$date - [MODULE / FTP] Cannot login ", $ftp->message;
		if ( !$ftp->cwd("$ddest") ) {
			if ( -d "$spath/$sname") {
			$ftp	->	mkdir("$sname")
						or die "$date - [MODULE / FTP] Cannot create directory ", $ftp->message;
			}
		}
		$ftp	->	cwd("$ddest")
					or die "$date - [MODULE / FTP] Cannot change working directory ", $ftp->message;
		$ftp	->	cwd("$sname")
					or die "$date - [MODULE / FTP] Cannot change working directory ", $ftp->message;
		if ( -d "$spath/$sname") {
			$ftp	->	rput("$spath/$sname")
						or die "$date - [MODULE / FTP] Cannot put ", $ftp->message;
		}
		elsif ( -f "$spath/$sname") {
			$ftp	->	put("$spath/$sname")
						or die "$date - [MODULE / FTP] Cannot put ", $ftp->message;
		}
		$ftp	->	quit;
	1;
}
1;
