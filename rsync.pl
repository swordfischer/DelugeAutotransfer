#!/usr/bin/perl
use utf8;
use strict;
use warnings;

use File::Rsync;

our $date;

sub rsync {
	my $spath	=	$_[0];
	my $sname	=	$_[1];
	my $duser	=	$_[2];
	my $dhost	=	$_[3];
	my $dport	=	$_[4];
	my $ddest	=	$_[5];
	my $rsync	=	File::Rsync->new( {'recursive' => '1' } );
	$rsync->exec( {
			src		=>		"$spath/$sname",
			dest	=>		"$duser\@$dhost:$ddest",
			port	=>		"$dport",
	} ) or die return 0;
	1;
}
1;
