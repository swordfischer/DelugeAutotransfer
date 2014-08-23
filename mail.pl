#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use Net::SMTP::SSL;

sub send_mail {
	my $from		=		$_[0];
	my $fromname	=		$_[1];
	my $password	=		$_[2];
	my $smtpserver  =		$_[3];
	my $to			=		$_[4];
	my $subject		=		$_[5];
	my $body		=		$_[6];
	my $smtp;
	if (not $smtp = Net::SMTP::SSL->new($smtpserver,
		Port => 465,
		Debug => 0)) { die "[SMTP] Could not connect to server\n"; }
		$smtp->auth($from, $password)
			or die "[SMTP] Authentication failed!\n";
		$smtp->mail($from . "\n");
		my @recipients = split(/,/, $to);
		foreach my $recp (@recipients) {
			$smtp->to($recp . "\n");
			$smtp->data();
			$smtp->datasend("From: $fromname <" . $from . ">\n");
			$smtp->datasend("To: " . $to . "\n");
			$smtp->datasend("Subject: " . $subject . "\n");
			$smtp->datasend("\n");
			$smtp->datasend($body . "\n");
			$smtp->dataend();
			$smtp->quit;
		}
	1;
}
1;
