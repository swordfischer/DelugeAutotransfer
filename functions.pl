#!/usr/bin/perl
use warnings;
use strict;
use utf8;
use Net::SMTP::SSL;
use File::Rsync;

sub send_mail {
my $to          =       $_[0];
my $subject     =       $_[1];
my $body        =       $_[2];
my $from        =       'sendfromhere@domain.tld';
my $password    =       'usethispassword';
my $smtp;
if (not $smtp = Net::SMTP::SSL->new('smtp.gmail.com',
	Port => 465,
	Debug => 0)) { die "Could not connect to server\n"; }
	$smtp->auth($from, $password)
		or die "Authentication failed!\n";
	$smtp->mail($from . "\n");
	my @recipients = split(/,/, $to);
	foreach my $recp (@recipients) {
		$smtp->to($recp . "\n");
		$smtp->data();
		$smtp->datasend("From: SFDC Torrent Information <" . $from . ">\n");
		$smtp->datasend("To: " . $to . "\n");
		$smtp->datasend("Subject: " . $subject . "\n");
		$smtp->datasend("\n");
		$smtp->datasend($body . "\n");
		$smtp->dataend();
		$smtp->quit;
	}
1;
}
sub rsync {
my $rsync       =       File::Rsync->new( {'recursive' => '1' } );
my $spath	=	$_[0];
my $sname 	=	$_[1];
my $duser 	=	$_[2];
my $dhost	=	$_[3];
my $ddest	=	$_[4];
$rsync->exec( {
       		src     =>      "$spath/$sname",                                                                        
        	dest    =>      "$duser\@$dhost:$ddest",                                                                         
	} ) or die return 0;
1;
}
1;   
