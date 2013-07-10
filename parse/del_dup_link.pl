#!/usr/bin/perl

print "Content-type: text/html\n\n";

# use warnings;

require "../lib/def.pl";


my %varinfo;  
$varinfo{dbh}=condb("192.168.126.4","0000","root","280286","grabber");

$parametr=0;

	
	my ($fol,$hhs) = &get_query($varinfo{dbh},"SELECT `url`,count(`id`) as cv FROM cash where 1 group by `url` order by `cv`","hash","pr");
if ($fol > 0) {

while ($parametr < 32870) {

if ($$hhs[$parametr]{'cv'} > 1) {	

	$hash1{url}=$$hhs[$parametr]{'url'};
    	my $limit = $$hhs[$parametr]{'cv'}-1;
print "$$hhs[$parametr]{'url'} - $limit - $$hhs[$parametr]{'cv'}\n\n";


	my ($fol1,$hhs1) = &get_query($varinfo{dbh},"delete from cash where `url` = \'$$hhs[$parametr]{'url'}\' order by `id` desc limit $limit","ins","pr");
}

$parametr++;
}

	
}
exit;

    
print "-- ";