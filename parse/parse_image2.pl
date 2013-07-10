#!/usr/bin/perl

print "Content-type: text/html\n\n";
require HTML::Parser;
 require HTML::TokeParser;
 use Encode;

#use strict;
#use warnings;



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
#	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `url`,`id` FROM cash where `dounload` = 0 and `url` like 'http://market.yandex.ru/model.xml%' limit ".$var_sdv.",1","hash","pr");
#	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT * FROM catalog where `img1` like 'http://mdata.yandex.net/i?path%' limit ".$var_sdv.",1","hash","pr");
my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT * FROM image where LENGTH(image_big) < 100 limit ".$var_sdv.",1","hash","pr");
#################
	my ($fol2,$hhs2) = &get_query($varinfo{dbh},"SELECT `proxy`,`status` FROM proxy_list where `yandex` = '200' and `active` ='1'  and `yandex_time` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 5 minute) order by `status` limit ".$var_sdv.",1","hash","pr");

	my $pr =$$hhs2[0]{'proxy'}; 
	   $pr ='192.168.126.5:80'; 
	
	my %hash1;
	my $mg='img1';
	if (($fol > 0) and ($fol2 > 0)) {
	print "col $$hhs[0]{id} 1111111111111111\n";
		if (length($$hhs[0]{'img1'}) > 25) {$mg='img1';}
		if (length($$hhs[0]{'img2'}) > 25) {$mg='img2';}
		if (length($$hhs[0]{'img3'}) > 25) {$mg='img3';}
		if (length($$hhs[0]{'img4'}) > 25) {$mg='img4';}
		if (length($$hhs[0]{'img5'}) > 25) {$mg='img5';}
		if (length($$hhs[0]{'img6'}) > 25) {$mg='img6';}
		if (length($$hhs[0]{'img7'}) > 25) {$mg='img7';}
		if (length($$hhs[0]{'img8'}) > 25) {$mg='img8';}
		if (length($$hhs[0]{'img9'}) > 25) {$mg='img9';}
		
		$hash1{url}=$$hhs[0]{$mg};
		$hash1{url}=$$hhs[0]{url_ist};#####################
		#$hash1{url}='http://mdata.yandex.net/i?path=b0817215935_img_id7452420961684130287.jpg';
    	$hash1{id}=$$hhs[0]{'id'};
		$varinfo{url} = $hash1{url};
		$varinfo{id} = $hash1{id};
		$varinfo{var_sdv}=$var_sdv;
		
		my $pr =$$hhs2[0]{'proxy'}; 

		print "$pr $hash1{url}",'-*-*-\n\n';	

	my $res = get_page(\%hash1,$pr);
	$varinfo{res_code}=$res->code;
	$varinfo{res_html} = $res->content; 

		
	my $status;
if ($res->is_success){
			
		if ((length($varinfo{res_html}) > 100)  and (index($varinfo{res_html}, 'DansGuardian') < 0)) { 
			$status=$$hhs2[0]{'status'}-1;
			
			
			my ($big,$medium,$small)=get_image_size(\%varinfo);
				
		
	#	print "INSERT into `image` (image_big, model_name, caption, url_ist, image_medium, image_small) values ('','0','text',\'$varinfo{url}\','".$medium."','".$small."');";
#my ($fol5,$hhs5) = &get_query($varinfo{dbh},"INSERT into `image` (image_big, model_name, caption, url_ist, image_medium, image_small) values (\'".addslashes($big)."\' ,'".$$hhs[0]{model_name}."','".$$hhs[0]{catalog}."',\'$varinfo{url}\','".addslashes($medium)."','".addslashes($small)."');","ins","pr");
#my ($fol51,$hhs51) = &get_query($varinfo{dbh},"	SELECT `id` FROM image where `url_ist` like '".$varinfo{url}."' limit 0,1","hash","pr");

my ($fol6,$hhs6) = &get_query($varinfo{dbh},"UPDATE `image` SET `image_big` = '".addslashes($big)."',`image_medium` = '".addslashes($medium)."',`image_small` = '".addslashes($small)."' where `id`='".$$hhs[0]{id}."' limit 1;","ins","pr");
#my ($fol6,$hhs6) = &get_query($varinfo{dbh},"UPDATE `catalog` SET `".$mg."` = '".$$hhs51[0]{id}."' where `id`='".$$hhs[0]{id}."' limit 1;","ins","pr");
			 
		#exit;	
		##	my ($fol2,$hhs2) = &get_query($varinfo{dbh},"UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1 where `url` = \'".$hash1{url}."\' limit 1;","ins","pr");
			print "\n \n  Page ADD, Kod : ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old: ==\n\n";
		##		print parse_page_link(\%varinfo);
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
		if (index($varinfo{res_html}, 'http://company.yandex.ru/') > 0) {
		$varinfo{res_code}=200;
		#print "UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1,`status`=8 where `url` = \'".$varinfo{url}."\' limit 1;";
		#my ($fol2,$hhs2) = &get_query($varinfo{dbh},"UPDATE `cash` SET `text` = '".$varinfo{res_html}."', `dounload`=1,`status`=8 where `url` = \'".$varinfo{url}."\' limit 1;","ins","pr");
			print "\n \n  Oshibka so storoni servera 404 ot yandex, Kod error: ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old:".$$hhs2[0]{'status'}." ==\n\n";
		}
		else
			{
			$status=$$hhs2[0]{'status'}+1;
			print "\n \n  Oshibka so storoni servera, Kod error: ".$varinfo{res_code}." URL: ".$hash1{url}." ID: ".$hash1{id}." \n";
			print "== ststus new:".$status." Old:".$$hhs2[0]{'status'}." ==\n\n";
		}
   }
   
	#my ($fol3,$hhs3) = &get_query($varinfo{dbh},"update `proxy_list` set `yandex`='".$varinfo{res_code}."', `yandex_time` =CURRENT_TIMESTAMP, `status`='".$status."' where `proxy` = '".$$hhs2[0]{'proxy'}."'","ins","pr");



 }

else
{
	sleep(100);
print "No page for parse";
	sleep(100);
$parametr=0;
}

}

exit;
sub addslashes {

    my $entry = shift @_;
    $entry =~ s/[\'\"\\]/\\$&/gis;
    return $entry;

} 
  
print "-- ";