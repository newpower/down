#!/usr/bin/perl

print "Content-type: text/html\n\n";
require HTML::Parser;
 require HTML::TokeParser;
 use Encode;

use strict;
use warnings;


require "../lib/def.pl";
require "../lib/parse_lib.pl";
  

print "-Begin \n";

 use HTTP::Request;
 
my %varinfo=();  
$varinfo{dbh}=condb("192.168.126.4","0000","root","280286","grabber");

my $parametr=1;

my $var_sdv=0;
if ($ARGV[0] > 0) {$var_sdv=$ARGV[0]; print "Primenen parametr ".$ARGV[0]."\n";}

while ($parametr > 0) {
#	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `url`,`id` FROM cash where `dounload` = 0 and `url` like '%/model.xml%' and `url` like '%hid=91464%' limit 0,1","hash","pr");
#	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `url`,`id` FROM cash where `dounload` = 0 and `url` like 'http://market.yandex.ru/model.xml%' limit ".$var_sdv.",1000","hash","pr");
	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `url`,`id` FROM cash where `dounload` = 0 limit ".($var_sdv*2000).",1000","hash","pr");
my $iu;
for ($iu=0;$iu<$fol;$iu++) {
	my ($fol2,$hhs2) = &get_query($varinfo{dbh},"SELECT `proxy`,`status` FROM proxy_list where `yandex` = '200' and `active` ='1'  and `yandex_time` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 5 minute) order by `status` limit ".($var_sdv*5).",1","hash","pr");
my $par1=$fol;
my $par2=$fol2;
	
	my $pr =$$hhs2[0]{'proxy'}; 
	my %hash1;
	if ($fol2 > 0)
	{
		$hash1{url}=$$hhs[$iu]{'url'};
    	$hash1{id}=$$hhs[$iu]{'id'};
		$varinfo{url} = $hash1{url};
		$varinfo{id} = $hash1{id};
		
		
		my $pr =$$hhs2[0]{'proxy'}; 

		print "$pr $hash1{url}",'-*-*-\n\n';	

	my $res = get_page(\%hash1,$pr);
	$varinfo{res_code}=$res->code;
	$varinfo{res_html} = $res->content; 
		$varinfo{res_html} = Encode::decode('utf8', $varinfo{res_html});
		$varinfo{res_html} = Encode::encode('cp1251', $varinfo{res_html});
		
		$varinfo{res_html} =~ s/\'/\"/g;
		
	my $status;
if ($res->is_success){
			if ((index($varinfo{res_html}, 'DansGuardian') > 0) or (index($varinfo{res_html}, 'Now go away') > 0)) { 
			my ($fol3,$hhs3) = &get_query($varinfo{dbh},"update `proxy_list` set `yandex`='".$varinfo{res_code}."', `yandex_time` =CURRENT_TIMESTAMP, `active` ='6' where `proxy` = '".$$hhs2[0]{'proxy'}."'","ins","pr");

			}
		
		if ((length($varinfo{res_html}) > 100)  and (index($varinfo{res_html}, 'DansGuardian') < 0) and (index($varinfo{res_html}, 'Now go away') < 0)) { 
			$status=$$hhs2[0]{'status'}-1;
			my ($fol2,$hhs2) = &get_query($varinfo{dbh},"UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1 where `url` = \'".$hash1{url}."\' limit 1;","ins","pr");
			print "\n \n  Page ADD, Kod : ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old: ==\n\n";
				print parse_page_link(\%varinfo);
			#print parse_page_link(\%varinfo);
	
		} 
		else
		{
			$varinfo{res_code}=699;
			$status=$$hhs2[0]{'status'}+1;
			
			print "\n  Kol_vo strok".length($varinfo{res_html})." Sov:".index($varinfo{res_html}, "DansGuardian")."\n";
			print "\n \n  Oshibka so storoni servera, Kod error: ".$varinfo{res_code}." ".$res->code." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old:".$$hhs2[0]{'status'}." ==\n\n";
			
		}
    }
    else
   {
			#http://company.yandex.ru/
		if (index($varinfo{res_html}, 'http://company.yandex.ru/') > 0) 
		{
			$status=$$hhs2[0]{'status'}-1;
			$varinfo{res_code}=200;
			print "UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1,`status`=8 where `url` = \'".$varinfo{url}."\' limit 1;";
			my ($fol2,$hhs2) = &get_query($varinfo{dbh},"UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1,`status`=8 where `url` = \'".$varinfo{url}."\' limit 1;","ins","pr");
			print "\n \n  Oshibka so storoni servera 404 ot yandex, Kod error: ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			#print "== ststus new:".$status." Old:".$$hhs2[0]{'status'}." ==\n\n";
		}
		else
		{
			$status=$$hhs2[0]{'status'}+1;
			print "\n \n  Oshibka so storoni servera, Kod error: ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old:".$$hhs2[0]{'status'}." ==\n\n";
		}
   }
   
	my ($fol3,$hhs3) = &get_query($varinfo{dbh},"update `proxy_list` set `yandex`='".$varinfo{res_code}."', `yandex_time` =CURRENT_TIMESTAMP, `status`='".$status."' where `proxy` = '".$$hhs2[0]{'proxy'}."'","ins","pr");



 }

else
{

print "No page for parse 1: $par1 2: $par2";
	sleep(100);
$parametr=0;
}
}
}
exit;

  
print "-- ";