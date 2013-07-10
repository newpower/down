#!/usr/bin/perl
# Измените на верный путь к Perl на вашем сервере

#################################################################################
# Perl :: 					#
# ============================================================================= #
#################################################################################

# Подключаем файл с HTML кодами и настройками
require "../lib/def.pl";
# Template Module



print "Content-Type: text/html; charset=windows-1251\n\n";
my $text;
#if (&check_password('$ENV{QUERY_STRING}') != 1)	{$text=$ENV{QUERY_STRING}} if ($text eq '') {$text="index"}

my $value=&get_standart("site","$text");


use HTTP::Request::Common;
require LWP::UserAgent;
  srand($$ & time ^ $$);
  $|=1; 
#  $put = "/home/hostsite/public_html/cgi-bin/clicker";

# Открытия счетчиков
# open(SCHET, "$put/schet.lst"); 
#   @schetchiki = <SCHET>; 
# close(SCHET); 

# Открытие прокси листа


 # open(PROXY, "pervii.lst") or die print 'dd'; 
 #   @proxies = <PROXY>; 
 #   chomp(@proxies); 
 # close(PROXY); 

$id = 0;
#foreach $url (@schetchiki) {
 my $url='http://market.yandex.ru/catalog.xml?hid=90594';
 while (1) {
my ($fol,$hhs) = &get_query($$value{dbh},"SELECT `proxy`,`status` FROM proxy_list where `yandex` != '200' and `active` ='1'  and `yandex_time` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 12 hour) order by `status` limit 0,1","hash","pr");
if ($fol > 0) {
my $pr =$$hhs[0]{'proxy'}; 
 
 $pr =~ s/ |\t//g; 
  $suc=1; 

   $ua = new LWP::UserAgent; 
   $ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)"); 
   $ua->timeout(15); 
      $ua->proxy(['http'], "http://$pr"); 
 print "<br>http://$pr \n";
   $h1 = new HTTP::Headers 
 Accept => 'application/vnd.ms-excel, application/msword, image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-comet, */*', 
   User_Agent => 'Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)', 
   Referer => 'http://market.yandex.ru/'; 
   $req1 = new HTTP::Request ('GET', $url, $h1); 
   $response=$ua->request($req1); 
   $suc=$response->is_success; 
  ($suc) || print $response->code; 

 
	
	($suc) && print "+"; 
	 my $status;
	 if ($suc) { 
	 $status=$$hhs[0]{'status'}-1;
   } else
   {
    $status=$$hhs[0]{'status'}+1;
   }
print $response->code.$response->code.$response->code.$response->code.$response->code."Status:".$$hhs[0]{'status'}." ";
	my ($fol3,$hhs3) = &get_query($$value{dbh},"update `proxy_list` set `yandex`='".$response->code."', `yandex_time` =CURRENT_TIMESTAMP, `status`='".$status."' where `proxy` = '".$$hhs[0]{'proxy'}."'","ins","pr");

 	

   

	#exit;

}
else {sleep(100);}

}
#}




    exit; 