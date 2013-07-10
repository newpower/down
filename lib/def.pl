
#################################################################################
# Perl ::		�������������� ����������				#
# =============================================================================	#
#	������ ��������	���������� � ������ �� ����������� � �������		#
#	�����������: �������� ������� �������� (600541@mail.ru)			#
# ���� � ������� �����								#
#################################################################################

#  print "OK!!!<br>Config: $$config{login_admin}<br>Lang: $lang<br>Templ: $templ";exit;

#print "Content-Type: text/html\n\n";

use DBI;
#use strict;
#use warnings;

@glob_serv=("192.168.136.135","0000","root","280286","grabber");
# ���������� � ����� ������
sub condb
{
	my ($dbhost,$dbport,$dbuname, $dbpass, $dbname)=@_;
	# SQl ����������
	
#my $dbhost = "localhost";


#my $dbname = "db_vipdo_21";
 #my $dbpass = "01534886";	


	my $dsn	= "DBI:mysql:database=$dbname;host=$dbhost";
	#print $dsn;
	my $dbh	= DBI->connect($dsn, "$dbuname","$dbpass",{'RaiseError' => 1, 'mysql_compression' => 1}) || die (print "Can't connect: ::errstr");

	return	$dbh;
		
}
sub addslashes {

    my $entry = shift @_;
    $entry =~ s/[\'\"\\]/\\$&/gis;
    return $entry;

} 

sub get_link
{
	my (%handle,$name,$value)=@_;
	my $string_val;
	for (keys %handle){
		if ($_ eq $name) {if ($value eq '') {$string_val="$name=$value&$string_val";}
		}
	elsif ($_ eq 'krand_val') {}
	else {$string_val="$_\=$handle{$_}&$string_val";}
	}
	my $rand_val=rand;
	$string_val ="$string_val\krand_val=$rand_val&";
	#print "$string_val";
	return	$string_val;
}

sub check_user
{
	my ($dbhandle,$dop)=@_;
&read_get();
if ($FORM{sn} eq '') {return 0;}
#print $FORM{sn};
#print "SELECT * FROM `users` where `name` = '$FORM{sn}'";
	my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT `id` FROM `users` where `name` = '$FORM{sn}'","hash","pr");
if ($fol1 > 0) {
	return	1;
	}
else {
return	0;
}
}

# ��������� ������ ������� �� ������ (��� �� ������� � ������)
# 1- ������ �������, 2-������ 
#&get_dostup_type($marker,'report');
sub get_dostup_type
{
	my ($marker_dostupa,$string)=@_;
	my (@var_mas);
	if ($string) {
	
		for (keys %{$$marker_dostupa[0]}) {
		#print "$marker_dostupa $_";
			if ((substr ("$_",0,length($string)) eq $string) and ($$marker_dostupa[0]{$_})) {
				push(@var_mas,$_);
				#print "$_ <br>"; 
			}
		}
	}
#print $#var_mas+1;
return @var_mas;
		
}

#��������� ������������ � ����
#1-������ � �� 
#
sub set_user
{
	my ($dbhandle,$dop)=@_;
&read_get();
if ($FORM{sn} eq '') {return 0;}
#print "INSERT INTO `users` (`name`) VALUES	('$FORM{sn}')";
		my ($fol1,$hhs1) = &get_query($dbhandle,"INSERT INTO `users` (`name`) VALUES	('$FORM{sn}')","ins","pr");
		my ($fol1,$hhs1) = &get_query($dbhandle,"INSERT INTO `users_stat` (`user` , `type`, `string` ) VALUES	('$FORM{sn}','registration','$FORM{sc}')","ins","pr");	
return &check_user($dbhandle);
		
}

sub check_acl
{
	my ($dbhandle,$param)=@_;
	&read_get();
if ($FORM{sn} eq '') {return 0;}
if (&check_user($dbhandle)) {
my ($fol1,$hhs1);
	if ($param eq 'supervisor') {
	print 'supervisor';
	($fol1,$hhs1)=&get_query($dbhandle,"SELECT * FROM `users` where `name` = 'supervisor'","hash","pr");
	} 
	else{
		($fol1,$hhs1) = &get_query($dbhandle,"SELECT * FROM `users` where `name` = '$FORM{sn}'","hash","pr");
	}
	if ($fol1 > 0)  {
		return	$hhs1;
	}

}
return	0;
}
#��������� ������ ����� ���� �����
#
#
sub get_number_kass
{
	my ($dbhandle,$id_heap)=@_;
	if ((&check_user($dbhandle)) and ($id_heap ne '')) {
		my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT * FROM `heap` where `id` = '$id_heap';","hash","pr");
		if ($fol1 > 0)  {
			return	$$hhs1[0]{'KASSA'};
		}
	}


return	"errorKASSA $podrazdelenie - $date";
}
#��������� ����� ������� �� �������������
##
#
sub get_id_heap
{
	my ($dbhandle,$podrazdelenie,$date)=@_;
	my (@mac_val,$ir);
if ((&check_user($dbhandle)) and ($podrazdelenie ne '') and ($date ne '')) {
		my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT DISTINCT `id_heap` FROM body where `podrazdel`='$podrazdelenie' and `date` = '$date'","hash","pr");
if ($fol1 > 0)  {
	for ($ir=0;$ir<$fol1;$ir++) {
		push (@mas_val,$$hhs1[$ir]{'id_heap'});
	}
	return	@mas_val;
	}

}
return	"errorIDheap $podrazdelenie - $date","errorIDheap $podrazdelenie - $date","errorIDheap $podrazdelenie - $date";
}
#��������� ���� ��� ����� ���������, ����� � ������
#
#
sub get_stat_date
{
	my ($dbhandle,$podrazdelenie,$date)=@_;
	&read_get();

if ((&check_user($dbhandle)) and ($podrazdelenie ne '') and ($date ne '')) {
		my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT sum(`sum_vsego`), sum(`sum_cft`), sum(`kol_tovarov`),COUNT(`id`) FROM body where `podrazdel`='$podrazdelenie' and `date` = '$date'","hash","pr");
if ($fol1 > 0)  {
my $sum_vsego=sprintf "%10.2f", $$hhs1[0]{'sum(`sum_vsego`)'}-$$hhs1[0]{'sum(`sum_cft`)'};
	return	$sum_vsego,$$hhs1[0]{'sum(`kol_tovarov`)'},$$hhs1[0]{'COUNT(`id`)'};
	}

}
return	"error $podrazdelenie - $date","error $podrazdelenie - $date","error $podrazdelenie - $date";
}

#��������� ���� ��� ����� ���������, ����� � ������ �� �����
#
#
sub get_stat_date_hour
{
	my ($dbhandle,$podrazdelenie,$dateot,$datedo,$time)=@_;
	&read_get();
#print "SELECT sum(`sum_vsego`), sum(`sum_cft`), sum(`kol_tovarov`),COUNT(`id`) FROM body where `podrazdel`='$podrazdelenie' and `date` between '$dateot' and '$datedo' and `time` between '$time:00:00' and '$time:59:59'";

if ((&check_user($dbhandle)) and ($podrazdelenie ne '') and ($dateot ne '') and ($datedo ne '') and ($time ne '')) {
		my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT sum(`sum_vsego`), sum(`sum_cft`), sum(`kol_tovarov`),COUNT(`id`) FROM body where `podrazdel`='$podrazdelenie' and `date` between '$dateot' and '$datedo' and `time` between '$time:00:00' and '$time:59:59'","hash","pr");
if ($fol1 > 0)  {
my $sum_vsego=sprintf "%10.2f", $$hhs1[0]{'sum(`sum_vsego`)'}-$$hhs1[0]{'sum(`sum_cft`)'};
	return	$sum_vsego,$$hhs1[0]{'sum(`kol_tovarov`)'}+1-1,$$hhs1[0]{'COUNT(`id`)'};
	}

}
return	"error \$podrazdelenie - $date","error $podrazdelenie - $date","error $podrazdelenie - $date";
}

#��������� ��������� ��������� �� ������
#
#
sub get_magazin_dostupa
{
	my ($dbhandle,$marker_dostupa)=@_;
	my ($iu,@my_mas1);
		my ($fol1,$hhs1) = &get_query($dbhandle,"SELECT * FROM podrazdelenie","hash","pr");
		for ($iu=0;$iu<$fol1;$iu++) {
				if ($$marker_dostupa[0]{"monitor-$$hhs1[$iu]{podrazdelenie}"}) {
			
					push(@my_mas1,$$hhs1[$iu]);
				#		print "+ $$hhs1[$iu]{'id'} - $my_mas1[0]{'id'} +";
				}
		}
				return @my_mas1;
}
# �������� ������� ������
sub get_temp
{
	my ($type,$dbh,$config,$text,$lang,$templ);
	$type= shift();
	$dbh = shift();	
	$config	= shift();	
	$text	= shift();
	$lang = shift();
	$templ = shift();
	
	if (!($lang)) {
	$lang =	&get_cvalue("lang_$type",$dbh,$config);	
			}
	if (!($templ)) {
	 $templ =	&get_cvalue("template_$type",$dbh,$config);
	}
#my %lang_hash = %{&get_config($dbh,"lang_$type","$lang","ORDER BY `index` DESC")};



my $template;
		




 # open the html template

  $template = HTML::Template->new(filename => "../templates/$templ/index.tmpl",
                                     case_sensitive => 1);
 
 #�������� ���� �� �� ���� ���� �� ������
use HTTP::Date;
 $template->param(expires => &time2str);



#######################################################################################

  # fill in some parameters


  
 for my $var(qw(LEFT RIGHT MAIN)){
  my @delta;
my ($folh,$lh) = &get_query($dbh,"SELECT * FROM `lang_$type` WHERE `type` LIKE '$var' ORDER BY `lang_dop`","hash","pr");


for my $lang_hash(@$lh) {
	   if ($$lang_hash{type} ne 'MAIN')  {push(@delta,{ NAME => "$$lang_hash{lang_key}", VALUE => $$lang_hash{"lang_".$lang} });}
	else {				
 $template->param($$lang_hash{lang_key} => $$lang_hash{"lang_".$lang});
}

}

##for (@{$delta[0]}){print %{$_}};            
##print "<br>";                               
 $template->param($var => \@delta);  
 
}
	if ($text) {
	my ($fol,$hh) = &get_query($dbh,"SELECT * FROM `content_$type` WHERE `lang` LIKE '".$lang."' AND `key` LIKE '$text'","hash","pr");

if ($$hh[0]{dop} eq 'FORMA'){

	 $$hh[0]{text}=&getforma($dbh,$config,$templ,$lang,$type,$text);
	}

for (qw(TITLE DESCRIPTION KEYWORDS)){ $template->param($_ => $$hh[0]{$_});}

 $template->param("TEXT" => [
 				{"TEXT_HEADER" => "$$hh[0]{text2}",
 				"TEXT_TEXT" => "$$hh[0]{text}",
 				"TEXT_AUTHOR" => "$$hh[0]{text3}"},
 				]);  
	}
	
	return  $template;
 
}

sub get_forma_select_value 
{
		


}



# Create form wich sql base and set  html tags
sub getforma 
{
		my ($dbh,$config,$templ,$lang,$type,$text)=@_;
		  my (@dforma,@tforma);
		my  $templateforma = HTML::Template->new(filename => "../templates/$templ/forma.tmpl"); 
	
	my ($fol,$hhs) = &get_query($dbh,"SELECT * FROM `lang_$type` WHERE `type` LIKE '$text' ORDER BY `lang_dop`","hash","pr");
	my $forma_value=$$config{forma_value};
	my $forma_disabled=$$config{forma_disabled};
	
	for (0..$fol){
			
		if ($$hhs[$_]{lang_key} eq 'FORMA') {
				if ($$hhs[$_]{dop2} eq 'select'){
					my $opt = &get_config($dbh,"lang_$type","$lang"," AND `type` LIKE '$text\_$$hhs[$_]{dop1}\_select_value'");
					my $str1;
					for (keys %$opt){
						$str1=join (" ", ($str1,"<option value=$_>$$opt{$_}</option>")) 
					#push(@tforma,{ 	NAME => $_, 	VALUE => $$opt{$_} }); 
					}
					$$forma_value{$$hhs[$_]{dop1}}=$str1;
				}
		#	if ($$hhs[$_]{dop2} eq 'textarea'){
		#		push(@tforma,{ 
		#		OPISANIE => $$hhs[$_]{"lang_".$lang}, 
		#		VALUE => "$$forma_value{$$hhs[$_]{dop1}}",
                #
		#		NAME => "$$hhs[$_]{dop1}" });
				
				if ($$hhs[$_]{dop2} eq 'checkbox'){$$forma_value{$$hhs[$_]{dop1}}='true';}
				push(@dforma,{ 
				"$$hhs[$_]{dop2}" => "$$hhs[$_]{dop2}",
				OPISANIE => "$$hhs[$_]{'lang_'.$lang} ", 
				TYPE => "$$hhs[$_]{dop2}", 
				HELP => "$$hhs[$_]{help}",
				DISABLED => "$$forma_disabled{$$hhs[$_]{dop1}}",
				VALUE => $$forma_value{$$hhs[$_]{dop1}},
				NAME => "$$hhs[$_]{dop1}" });
		#	
		#		
		#		
		#		}
		#	else 
		#	{
		#if ($$hhs[$_]{dop2} eq 'checkbox'){$$forma_value{$$hhs[$_]{dop1}}='true';}
		#	push(@dforma,{ 
		#		OPISANIE => "$$hhs[$_]{'lang_'.$lang} ", 
		#		TYPE => "$$hhs[$_]{dop2}", 
		#		HELP => "$$hhs[$_]{help}",
		#		DISABLED => "$$forma_disabled{$$hhs[$_]{dop1}}",
		#		VALUE => "$$forma_value{$$hhs[$_]{dop1}}",
		#		NAME => "$$hhs[$_]{dop1}" });
		#	}
		} else  { $templateforma->param($$hhs[$_]{lang_key} => $$hhs[$_]{"lang_".$lang}); }
		
		
		}
		 $templateforma->param("FORMA" => \@dforma,"TEXTAREA" => \@tforma);  



		return $templateforma->output;
}




sub get_config
{
	my ($dbh,$config,$fol,$hhs,%confighash,$lang,$config_lang,$sort);
	
	$dbh = shift();	
	$config	= shift();	
	$lang= shift();	
	$sort = shift();	

	($fol,$hhs) = &get_query($dbh,"SELECT *	FROM `$config` WHERE 1 $sort","hash","pr");

	$config_lang ="lang\_$lang";	

		if (substr($config, 0, 4) eq "lang"){	
			my $config_key="lang_key";
		  for (0..($fol-1))
				{
			
		#	$config_value="$config_lang"; #(� lang ���� val)
			$confighash{$$hhs[$_]{$config_key}} = $$hhs[$_]{$config_lang};	
		#	print "$config_key^{$$hhs[$_]{$config_key}}^$$hhs[$_]{$config_value}^";
				}
		}
		else {
	      	  for (0..($fol-1))
				{
		$confighash{$$hhs[$_]{'config_key'}} = $$hhs[$_]{'config_value'};
				}
		}
	
	return \%confighash;
}

sub get_cvalue
{
	my ($dbh,$str,$config,$cookie);	

	($str,$dbh,$config)=@_;	
	$cookie	= &readcookies();
	if (!($$cookie{$str})){	
				if (!(exists($$config{"version"}))) {$config = &get_config($dbh);}
				 $$cookie{$str}=$$config{$str};	
				 use CGI::Cookie;
				   my $c = new CGI::Cookie(-name    =>	$str,	  -value   =>  $$cookie{$str},	 -expires =>  '+3M');

				print "Set-Cookie: $c\n";
  
				}
	return $$cookie{$str};
	
}


#������	����
sub readcookies	
{
		my @cookiearray	= split(";", $ENV{'HTTP_COOKIE'});
	my $cookiename;	
	my $cookievalue;
	my %cookiehash;	

	foreach	$_ (@cookiearray) {
		($cookiename, $cookievalue) = split ("=", $_);
  $cookiename =~ s/ //g;
	$cookiehash{$cookiename} = $cookievalue;
	}
return \%cookiehash;
}

#proverka cookie dannih	
sub locat {
	my ($way)=@_;
print "Location: $$config{url}/$$config{$way}\n\n";
#exit;
#my $oshibka=0;
#
#
#if ( $login =~ /^\w*$/ ) { } else {$oshibka=1;}	
#
#
#$pas2 =	crypt ($$total[0]{password}, 'aq');
#if ($pas ne $pas2) {$oshibka=1;}
exit;
}

sub vhod
{
	my ($dbh,$config) = @_;	


my $cookie = &readcookies();

my ($error);



$error=&check_len_hash($cookie,[login,password],$config,$errorhash);
for (@$error){locat($config,"way_input");}

my ($fol,$hhs) = &get_query($dbh,"SELECT * FROM `users_base` WHERE `login` LIKE '$$cookie{login}' LIMIT 0 , 1","hash","pr");
if (!($fol)) {locat($config,"way_input")}

if ($$cookie{password} ne crypt($$hhs[0]{password}, 'aq')) {&locat($config,"way_input")}
	return @$hhs[0];
}

#poluchenie dannih
sub read_get {
 my $buffer = "$ENV{QUERY_STRING}";
 my @pairs = split(/&/,	$buffer);
 my %FORM;
 foreach $pair (@pairs)	{
  ($name, $value) = split(/=/, $pair);
  $name	=~ tr/+/ /;
  $name	=~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $value =~ tr/+/ /;
  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $value =~ s/<!--(.|\n)*-->//g;
  $value =~ s/</&lt;/g;	
  $value =~ s/>/&gt;/g;	
  $value =~ s/\cM/ /g;
  $value =~ s/\n/\<br\>/g;
  $value =~ s/\|/ /g;
  $value =~ tr/	/ /s;
  $value =~ s/<([^>]|\n)*>//g;
  $FORM{$name} = $value;

 }
 return \%FORM;
}


## ������ ������ ���������
sub set_link {
	my $base = shift();
$base =~ s/\S*\w+@\w+\S*/<a href=\"mailto:$&\">$&<\/a>/gi;
$base =~ s/\S*\w+@\w+\S*/<a href=\"mailto:$&\">$&<\/a>/gi;
$base =~ s/\s*http:\/\/\S*/<a href=\"$&\" target=\"_blank\">$&<\/a>/gi;
$base =~ s/\s*ftp:\/\/\S*/<a href=\"$&\" target=\"_blank\">$&<\/a>/gi;
return $base;	
}

#Obrabotka vrem	
sub timeconv {
	my $time = shift();
	my $days=int($time);
	$time =	($time-days)*24;
	my $hours = int($time);	
	$time =	($time-$hours)*60;
	my $minutes = int($time);
	$time =	($time-$minutes)*60;
	my $seconds = int($time);
	return ($days,$hours,$minutes,$seconds);
}

#Generaciy vrem	
sub get_time {
 my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);	
 $mon++;
 $year+=1900;
 if ($mday<10) { $mday="0$mday"; }
 if ($mon<10) {	$mon="0$mon"; }	
 if ($min<10) {	$min="0$min"; }	
my $date="$year-$mon-$mday";
my $time="$hour:$min:$sec";	
my $datetime="$date $time";
 return	$datetime;
# $cur_all_day=$mday+$mon*30+$year*365;
}
sub get_date {
 my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);	
 $mon++;
 $year+=1900;
 if ($mday<10) { $mday="0$mday"; }
 if ($mon<10) {	$mon="0$mon"; }	
 if ($min<10) {	$min="0$min"; }	
my $date="$year-$mon-$mday";

 return	$date;
# $cur_all_day=$mday+$mon*30+$year*365;
}
sub convert_time {
	$time = shift;
	$var_m = shift;
 my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($time);	
 $mon++;
 $year+=1900;
 
 if ($mon<10) {	$mon="0$mon"; }	
 if ($min<10) {	$min="0$min"; }	
 if ($var_m){$mon = $$var_m{$mon};}
my $date=" $mday $mon $year";
 #  $time="$hour:$min:$sec";	
my $datetime="$date ";
# return	$$var_m{01};
 return	$datetime;
}
#proverka e-mail
sub email_check	{
 # �������� E-mail �����
 local($email) = $_[0];	

 if($email =~ /\w+?\@(\w+?\.)+\w+?/){
  return(0);
 } else	{
  return(1);
 }
}


#process e-mail	
sub sentemail {	
	my($reception, $to, $subject, $message,	$type, $kodirovka, $dop) = @_;
# ��������� ���������������� ����������, ����� wintokoi(<����������>)
sub wintokoi {
    my $pvdcoderwin=shift;
    $pvdcoderwin=~ tr/\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF/\xE1\xE2\xF7\xE7\xE4\xE5\xF6\xFA\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF2\xF3\xF4\xF5\xE6\xE8\xE3\xFE\xFB\xFD\xFF\xF9\xF8\xFC\xE0\xF1\xC1\xC2\xD7\xC7\xC4\xC5\xD6\xDA\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD2\xD3\xD4\xD5\xC6\xC8\xC3\xDE\xDB\xDD\xDF\xD9\xD8\xDC\xC0\xD1/;
return $pvdcoderwin;
} 

if ($kodirovka eq 'win') {        
	$subject=wintokoi($subject);
        $message=wintokoi($message);
        		}
my $mailprog = '/usr/sbin/sendmail';

open(MAIL,"|$mailprog -t");

print MAIL "To: $to\n";
print MAIL "From: $recipient\n";
print MAIL "Subject: $subject\n";
 print MAIL "MIME-Version: 1.0\n";
 print MAIL "Content-Type: text/html\; charset=\"koi8-r\"\n";
 print MAIL "$message";
  close (MAIL);
  
#print "pismo $message pismo";

}


#�������� ������
sub sort_keys {	
	
	my ($temphash,$orderref) = (shift,shift);
	my (%temp,@final); 
	for (keys %$temphash){$temp{$_}=1}; 
	for (@{$orderref}){if ($temp{$_}){push (@final,$_);delete $temp{$_}}};
	return (@final,keys %temp)
}

#�������� ������
sub view_table1 {

	my ($hhs,$order,$link1)	= @_;

	print "<table border=1 bordercolor=blue CELLPADDING=3 CELLSPACING=0><tr>";	
	#for (keys %{$$hhs[0]})	{

	#my @order=('id','caption','opisanie','url','url_add','tema','country');	
				    
				    
	for (&sort_keys($$hhs[0],$order)) {
		if ($link1 ne '') {
		use URI;
			   $url = URI->new($link1);
	  
	
		$FORM{krand_val}=rand;
		$FORM{sort}=$_;
	    $url->query_form(%FORM); 
		
		print "<td><center><a href=\".\\$url\">$_</a></center></td>";
	
	#		print "<td><center>$link{'$_'}</center></td>";	
		}
		else {
		print "<td><center>$_</center></td>";	
		}
	}
	for $i(@{$hhs}){
		print "</tr><tr>";



		#for (keys %{$$hhs[$i]}) {


		for (&sort_keys($i,$order)) {
	

			if ($_ eq "id")	{
					print "<td><b>	<a href=send3.pl?id=",$$i{$_},"&action1=mod&input_board=$input_board>",$$i{$_}," </a></b>";
					print "<br> <a href=send4.pl?id=$mod{$_}&action1=mod&input_board=$input_board target=_blank>��������</a></td> "; 
			}
			else {

				#������	�����	
				#$$i{$_}=&set_link($$i{$_});
				
				print "<td>",$$i{$_}," </td>";
			}
	
		}	
	#print "</tr>";	
	print "</tr>";

	}
	print "</table>";
}

#�������� ������
sub view_table_new {

	my ($hhs,$order,$link1)	= @_;
	my $text;
	$text=$text."<table border=1 bordercolor=blue CELLPADDING=3 CELLSPACING=0><tr bgcolor=00CCFF>";	
	#for (keys %{$$hhs[0]})	{

	#my @order=('id','caption','opisanie','url','url_add','tema','country');	
				    
				    
	for (&sort_keys($$hhs[0],$order)) {
		if ($link1 ne '') {
		use URI;
			   $url = URI->new($link1);

		$FORM{krand_val}=rand;
		$FORM{sort}=$_;
	    $url->query_form(%FORM); 

		$text=$text."<td><center><a href=\".\\$url\">$_</a></center></td>";

	#		print "<td><center>$link{'$_'}</center></td>";	
		}
		else {
		$text=$text."<td><center>$_</center></td>";	
		}
	}
	for $i(@{$hhs}){
		$text=$text."</tr><tr>";
		#for (keys %{$$hhs[$i]}) {
		for (&sort_keys($i,$order)) {
	
			#������	�����	
				#$$i{$_}=&set_link($$i{$_});
				$text=$text."<td>".$$i{$_}." </td>";

	
		}	
	#print "</tr>";	
	$text=$text."</tr>";

	}
	$text=$text."</table>";
	return $text;
}




sub get_dop {

#�������� ���
my @dop;
$dop[0]="������";
$dop[1]="������������";	
$dop[2]="���������";
$dop[3]="��������������";
$dop[4]="������";
$dop[5]="����������";
$dop[6]="����� - �����,	PC, ��������";
$dop[7]="������";
$dop[8]="������	��� ���� � ����, ��������, ������";


return @dop;
}

#��������� ��� ����������
# ������ �������� ������, ������ ����� ��������� (mass,hash) ������ ���	pr � do	
sub get_query
{
	my ($dbh,$string,$otvet,$dd)=@_;
	###print "Content-Type: text/html\n\n";
	print "$string <br>\n";
	if ($dd	eq 'do') {
		 $sth =	$dbh->do($string);
	}
else
	{
		#print "-- $dd --- $string";
		 $sth =	$dbh->prepare($string);	
		$sth->execute();

	}
if ($DBI::err)
	{
	print "<br><br><font color=red>	Warning:</font><font color=green> $DBI::errstr </font><font color=red> Zapros:</font><font color=green>	$string	</font><br><br>\n";
	#&sentemail($email_admin, $email_admin, "������ �����c� ��", "Warning: (v	zaprose	\{$string\} oshika) $DBI::errstr", "text", "win", $dop);
	}

if ($otvet eq 'mas')
	{
		while ($arr=$sth->fetchrow_array()){push @total,$arr};
		
		 	my $vsego = $sth->rows;
		 $sth->finish();
		return ($vsego,\@total);	
	}
elsif ($otvet eq 'ins')
	{
			
		return (1,1);
	}
else
	{
		my (%arr,@resarr);
		while ($arr=$sth->fetchrow_hashref()){push @resarr,$arr};
			 	my $vsego = $sth->rows;	
		 $sth->finish();
		# 	my $vsego = $sth->rows;	
		return ($vsego,\@resarr);
	}
}




#�������� �������� ����	�������� ��������
$cdop[0]="style=\"BACKGROUND: deepskyblue\" ";
$cdop[1]="style=\"BACKGROUND: #FFA07A\"	";
$cdop[2]="style=\"BACKGROUND: gold \" ";
$cdop[3]="style=\"BACKGROUND: #999999\"	";
$cdop[4]="style=\"BACKGROUND: deepskyblue\" ";
$cdop[5]="style=\"BACKGROUND: #FF0099\"	";
$cdop[6]="style=\"BACKGROUND: #ffdab9\"	";
$cdop[7]="style=\"BACKGROUND: #edb0ed\"	";
$cdop[8]="style=\"BACKGROUND: deepskyblue\" ";

#�������� �������� ����������

$static[0]='�����������	� ������� (������)';
$static[1]='����������� � ������� (������� ���)';
$static[2]='������ ��� ����� ������ (��� �����������)';
$static[3]='���� (������������)';
$static[4]='��������� ������ ������� (������)';
$static[5]='��������� ������ �������';
$static[6]='���������� email (������) � �����';
$static[7]='��������� email � �����';
$static[8]='��������� e-mail (error) � �����';
$static[9]='�������������� �������� ������';
$static[90]='�������������� �������� ������ (������ ������ ������)';
$static[10]='�������� e-mail (error) � �����';
$static[11]='�������� e-mail  � �����';
$static[12]='���������� ���������� (error)';
$static[13]='���������� ���������� ';
$static[14]='��������� ����� (error) ';
$static[15]='��������� ���������� ';
$static[16]='��������� ���������� (error)';
$static[17]='��������� ����������';
$static[18]='��������� ���������� (���������)';
$static[19]='��������� ���������� ����������';
$static[20]='��������� ���������� ���������� (error)';
$static[21]='����� �� �������';

sub inlen{
	#for (@_){print $_,","}
	return ((defined $_[1] and $_[0]<$_[1])?(-1):((defined $_[2] and $_[0]>$_[2])?1:0))
}

sub check_len_hash{
	my ($hash,$hhs,$config,$errorhash)=@_;
		my (@error);
	
	for $boo(@$hhs){
		#print $boo,"<br>";
		my $temp4=$$hash{$boo};
		#print "temp4-",$temp4,".";
		my $temp=inlen(length($temp4),$$config{$boo."_value_min"},$$config{$boo."_value_max"});
		#print $boo,"-",$temp;
		if ($temp) {
			my $temp3=($temp==1)?"max":"min";
			my $temp2=$$errorhash{$boo."_value_".($temp3)};
			push (@error,\($temp2?$temp2:($$errorhash{erstring}." ".$boo." ".$temp3)))
		} #else {
			$data{$boo}=$temp4;
#		}
	}
		return (\@error)
}

sub check_len{
	my ($mycgi,$hhs,$config,$errorhash)=@_;

	my (%data);
	for $boo(@$hhs){
		$data{$boo}=$mycgi->param($boo);
		}
		$error=&check_len_hash(\%data,$hhs,$config,$errorhash);

	return (\%data,$error)
}

sub wrong_sym{
	return (($_[0] ne chr(150) and ($_[0] lt chr(33) or $_[0] gt chr(126) and $_[0] lt chr(192)))?1:0)
}


sub check_password{
	for my $i(0..length($_[0])-1){
		if (wrong_sym(substr($_[0],$i,1))){$flag=1;last}
	}
	return $flag;
}



sub generate_password{
	my $word;
	for (0..$_[0]-1){
		my $boo;
		until (!&wrong_sym($boo)) {
			$boo=chr(int(rand(256)));#print $boo,"\n"
		}
		substr($word,$_,1)=$boo
	}
	return $word;
}

sub convert {
	my $value = shift();				

  $value =~ tr/+/ /;
  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

  return $value;				
}

sub show_table{
	my ($hash,$templ);
	
	$hash = shift();
	$templ = shift();
	
		my  $template = HTML::Template->new(filename => "../templates/$templ/table.tmpl"); 
	$template->param(%$hash);
	  return $template->output;
}		
sub show_error{
	my ($hash,$templ);
	
	$hash = shift();
	$templ = shift();
	
		my  $template = HTML::Template->new(filename => "../templates/$templ/error.tmpl"); 
	$template->param(%$hash);
	  return $template->output;
}
sub show_information{
	my ($hash,$templ);
	
	$hash = shift();
	$templ = shift();
	
		my  $template = HTML::Template->new(filename => "../templates/$templ/information.tmpl"); 
	$template->param(%$hash);
	  return $template->output;
}
sub exitform
{	
	

	return	"<hr color=blue size=1 weight=200>&copy; 2008-(09), �����������: <i><u>�������� �.�.</i></u> CA version 2.05<hr color=blue size=1 weight=200>";
	
}

sub priv_error
{
	my ($dbhandle,$dop)=@_;


		my ($fol1,$hhs1) = &get_query($dbhandle,"INSERT INTO `users_stat` (`user` , `type`, `string` ) VALUES	('$FORM{sn}','err_premission','Dostup $dop - PC $FORM{sc}')","ins","pr");	
print "� ��� ������������ ����!!!";
		
}
sub get_client_id {
my ($g3tz,$cr,$auth0z);
	foreach $g3tz ($ENV{"REMOTE_ADDR"}, $ENV{"HTTP_USER_AGENT"}, $ENV{"HTTP_ACCEPT_LANGUAGE"}, $ENV{"HTTP_HOST"})
	{
		foreach $cr (split("", $g3tz))
		{
		$auth0z+= ord($cr);
		}
	}
return $auth0z;
}

sub get_standart
{
	my %value;
	$value{type}=shift();

	$value{text}=shift();

	$value{dbh} = condb("192.168.136.135","0000","root","280286","grabber");
	my @pa = split(/\?/,	$ENV{REQUEST_URI});
	$ENV{QUERY_STRING}=$pa[1]; 
	$value{form_data}=read_get();
	
	#print $$varn{form_data}{type},$varn{form_data};
	
	$value{config} = get_config_new();
	$value{id_client} = get_client_id;

   	#$value{date} =&vhod($value{dbh},$value{config});


	$value{lang} =	'ru';
	$value{templ} =	'default_site';



	return \%value;
}
sub get_config_new
{
#obyavlyarm vse peremennie
	my (%confighash);


	$confighash{version} = '0.5.1';
	$confighash{template_site} = 'default_site';
	$confighash{number_tov_on_page} = 20;
	return \%confighash;
}
sub read_seach {

my $varn=$_[0];
my ($iu,$string);


}
sub get_magazins {

my $varn=$_[0];
my $host=$_[1];
my ($fol3,$hhs3) = &get_query($$varn{dbh},"SELECT * FROM `magazins` where `domain`='".$host."' limit 0,1","hash","pr");

	if ($fol3 == 1)
		{
			return $$hhs3[0]{short_caption};
		}
	else
		{
			return 'mag1';
		}
}

sub read_basket {

my $varn=$_[0];
my ($iu,$string);
$string='';
my $var_mag_id=get_magazins($varn,$ENV{HTTP_HOST});
if (($$varn{form_data}{type} eq '') or ($$varn{form_data}{type_view} eq 'full') or ($$varn{form_data}{type_view} eq 'full2')) {


my ($fol3,$hhs3) = &get_query($$varn{dbh},"SELECT `cm`.`cost_".$var_mag_id."` as `cost`,`c`.`img1` as `img`,`b`.`id_tovar` as `id_tovar`,`b`.`model_name` as `model_name`,sum(`count`) as `count` from `basket` as b
left join `catalog` as c ON `b`.`id_tovar` = `c`.`id` 
left join `catalog_market` `cm` on `b`.`id_tovar` = `cm`.`id` where `id_client`='".$$varn{id_client}."' group by `model_name`","hash","pr");

	if ($fol3 > 0) {
	$string=$string."<h1>���������� ������:</h1><hr width=100% size=2 color=\"#003366\"> " if (($$varn{form_data}{type_view} eq 'full') or ($$varn{form_data}{type_view} eq 'full2'));
	$string=$string."<table border=0>";
		my $sum_pokup;
		for ($iu=0;$iu<$fol3;$iu++) {
		if ($$hhs3[$iu]{'count'} > 0){
			if ($$varn{form_data}{type_view} eq '') {
				$string=$string."<tr><td rowspan=2><img src='./cgi-bin/mag/site/image.pl?id=$$hhs3[$iu]{img}&size=small'></td><td><nobr><a href='./tovr-001-".$$hhs3[$iu]{'id_tovar'}.".html'>".$$hhs3[$iu]{'model_name'}."</a></nobr></td></tr>
				<tr><td>$$hhs3[$iu]{'cost'} ��� * $$hhs3[$iu]{'count'} �� </td></tr>";
				$sum_pokup=$sum_pokup+($$hhs3[$iu]{'cost'}*$$hhs3[$iu]{'count'});
			}
			else
			{
				$string=$string."<tr><td rowspan=2><img src='./cgi-bin/mag/site/image.pl?id=$$hhs3[$iu]{img}&size=medium'></td><td><nobr><a href='./tovr-001-".$$hhs3[$iu]{'id_tovar'}.".html'>".$$hhs3[$iu]{'model_name'}."</a></nobr></td></tr>
				<tr><td>$$hhs3[$iu]{'cost'} ��� * $$hhs3[$iu]{'count'} �� <br>
				<u><span style=\"cursor:pointer\" onclick=\"basketAdd2($$hhs3[$iu]{'id_tovar'},-1,'index');javascript:parent.location='/bask-001.html';\">- 1 �� �� ������</span></u>
				\\ <u><span style=\"cursor:pointer\" onclick=\"basketAdd2($$hhs3[$iu]{'id_tovar'},1,'index');javascript:parent.location='/bask-001.html';\">+ 1 �� � ������</span></u></td></tr>
				";
			#	$string=$string."<nobr>".$$hhs3[$iu]{'model_name'}."  $$hhs3[$iu]{'count'} �� <span style=\"cursor:pointer\" onclick=\"basketAdd2($$hhs3[$iu]{'id_tovar'},1,'index');javascript:parent.location='/bask-001.html';\">+ 1 �� � ������</span>/</nobr><br>";
				$sum_pokup=$sum_pokup+($$hhs3[$iu]{'cost'}*$$hhs3[$iu]{'count'});
			}
		}
		}
		$string=$string."<tr><td></td><td>�����: $sum_pokup ���.</td></tr></table>";
		$string=$string."<a href='/bask-001.html'>��������� �����</a>" if ($$varn{form_data}{type_view} eq '');
		$string=$string."<hr width=100% size=2 color=\"#003366\"> <form method='get'>��� * [������: ������ ���� ��������]<br><input type='text' name=fio size=40>
<br>�������* [������: 8-908-1234567] <br><input type='text' name=telephone size=40>
<br>E-mail [������: client\@mail.ru]<br><input type='text' name=email>
<br>�����* [������: ������-��-����, ��. ������������� 2\2, ��. 5] <br>
<input type='text' name=adress size=80><br>
�������������� ���������� �� ������<br>
<textarea name=moreinf row=15 col=15></textarea><br>
<input type='submit' name='end_button' value='��������� �����'>" if ($$varn{form_data}{type_view} eq 'full');
	}
	#else 
	#{
	$string='������� �����' if (length($string) < 80);
	#}
}
elsif (($$varn{form_data}{type} eq 'add') and ($$varn{form_data}{count} > -100) and ($$varn{form_data}{ID} > 0)) {

my ($fol3,$hhs3) = &get_query($$varn{dbh},"SELECT `model_name` from `catalog` where `id`='".$$varn{form_data}{ID}."' limit 0,1","hash","pr");
if ($fol3 == 1) {
	my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT into `basket` (`magazin`,`id_client`, `count`, `model_name`,`id_tovar`) values ('".$var_mag_id."','".$$varn{id_client}."','".$$varn{form_data}{count}."','".$$hhs3[0]{model_name}."','".$$varn{form_data}{ID}."');","ins","pr");
	$$varn{form_data}{type}='';
	$string = read_basket($varn);
	}
	else {$string = '������ ������ ��� � ����!';}
}
elsif ($$varn{form_data}{type} eq 'end')  {
	my (%err_temp,$err_st);
			$$varn{form_data}{type_view}='full2';
		
		if (($$varn{form_data}{fio} eq '') or (length($$varn{form_data}{fio}) > 255) or (length($$varn{form_data}{fio}) < 3))		{$err_temp{fio}="11<br><font color=red>�� ��������� ��������� ���� '���'</font>";$err_st=1;}
		if (($$varn{form_data}{telephone} eq '') or (length($$varn{form_data}{telephone}) > 255) or (length($$varn{form_data}{telephone}) < 5))		{$err_temp{telephone}="<br><font color=red>�� ��������� ��������� ���� '�������'</font>";$err_st=1;}
		#if ((!(email_check($$varn{form_data}{email})) and ($$varn{form_data}{email} ne '')) or (length($$varn{form_data}{email}) > 255))		{$err_temp{email}="<br><font color=red>�� ��������� ��������� ���� 'E-mail'</font>";$err_st=1;}
		if (($$varn{form_data}{adress} eq '') or (length($$varn{form_data}{adress}) > 700) or (length($$varn{form_data}{adress}) < 12))		{$err_temp{adress}="<br><font color=red>�� ��������� ��������� ���� '�����'</font>";$err_st=1;}
		if (length($$varn{form_data}{moreinf}) > 700)	{$err_temp{moreinf}="<br><font color=red>�� ��������� ��������� ���� '�������'</font>";$err_st=1;}
		if ($err_st == 1)
			{
			$string="".read_basket($varn);
		
			$string=$string."<hr width=100% size=2 color=\"#003366\">
			<form method='get'>��� * [������: ������ ���� ��������] ".$err_temp{fio}." <br><input type='text' name=fio size=40 value=\"$$varn{form_data}{fio}\">
			<br>�������* [������: 8-908-1234567] $err_temp{telephone}<br><input type='text' name=telephone size=40 value=\"$$varn{form_data}{telephone}\">
			<br>E-mail [������: client\@mail.ru]$err_temp{email}<br><input type='text' name=email value=\"$$varn{form_data}{email}\">
			<br>�����* [������: ������-��-����, ��. ������������� 2\2, ��. 5] $err_temp{adress}<br>
			<input type='text' name=adress size=80 value=\"$$varn{form_data}{adress}\"><br>
			�������������� ���������� �� ������ $err_temp{moreinf}<br>
			<textarea name=moreinf row=15 col=15>$$varn{form_data}{moreinf}</textarea><br>
			<input type='submit' name='end_button' value='��������� �����'>";
			}
			else 
			{
				my $rand_val=rand;
				my ($fol5,$hhs5) = &get_query($$varn{"dbh"},"INSERT into `basket_order` (`id_client`, `date_time`, `status`, `status_coment`, `fio`, `telephone`, `e-mail`, `adress`, `dop_inf`, `stamp`,`magazins`) values ('".$$varn{id_client}."',CURRENT_TIMESTAMP,'0','',\'".$$varn{form_data}{fio}."\' ,\'".$$varn{form_data}{telephone}."\' ,\'".$$varn{form_data}{email}."\' ,\'".$$varn{form_data}{adress}."\',\'".$$varn{form_data}{moreinf}."\' ,'".$rand_val."','".$var_mag_id."');","ins","pr");
				my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"SELECT * FROM `basket_order` where `stamp` = '".$rand_val."' limit 0,1;","hash",'pr');
				my ($fol5,$hhs5) = &get_query($$varn{dbh},"insert into `basket_order_list` (id_order, id_tovar, count, cost)
															SELECT '".$$hhs3[0]{id}."',`id_tovar` , `count`,`cost_mag1` FROM `basket` as `b`
left join `catalog_market` as `cm` on `cm`.`id` = `b`.`id_tovar` where `id_client`='".$$varn{id_client}."';","ins","pr");
				my ($fol5,$hhs5) = &get_query($$varn{"dbh"},"DELETE FROM `basket` WHERE `id_client`='".$$varn{id_client}."';","ins","pr");
				my ($fol5,$hhs5) = &get_query($$varn{"dbh"},"INSERT into `users_base_priv` (`prem`, `table`, `id_doc`) values ('".$var_mag_id."_manadger_out','basket_order','".$$hhs3[0]{id}."');","ins","pr");
				
						
				$string=$string."������� �� ���������� ������. � ��������� ����� ���� ������ ����� ����������.";
			}
				
	}

return $string;
}

# Create form wich sql base and set  html tags
sub getforma_new 
{
	my $varn=$_[0];
		my ($dbh,$config,$templ,$lang,$type,$text)=@_;
		 
		 my (@dforma,@tforma);
		my  $templateforma = HTML::Template->new(filename => "../templates/$$varn{templ}/forma.tmpl"); 
	
	my ($fol,$hhs) = &get_query($dbh,"SELECT * FROM `lang_site` WHERE `type` LIKE '$$varn{forma_type}' ORDER BY `lang_dop`","hash","pr");
	my $forma_value=$$config{forma_value};
	my $forma_disabled=$$config{forma_disabled};
	
	for (0..$fol){
			
		if ($$hhs[$_]{lang_key} eq 'FORMA') {
				if ($$hhs[$_]{dop2} eq 'select'){
					my $opt = &get_config($dbh,"lang_$type","$lang"," AND `type` LIKE '$text\_$$hhs[$_]{dop1}\_select_value'");
					my $str1;
					for (keys %$opt){
						$str1=join (" ", ($str1,"<option value=$_>$$opt{$_}</option>")) 
					#push(@tforma,{ 	NAME => $_, 	VALUE => $$opt{$_} }); 
					}
					$$forma_value{$$hhs[$_]{dop1}}=$str1;
				}
		#	if ($$hhs[$_]{dop2} eq 'textarea'){
		#		push(@tforma,{ 
		#		OPISANIE => $$hhs[$_]{"lang_".$lang}, 
		#		VALUE => "$$forma_value{$$hhs[$_]{dop1}}",
                #
		#		NAME => "$$hhs[$_]{dop1}" });
				
				if ($$hhs[$_]{dop2} eq 'checkbox'){$$forma_value{$$hhs[$_]{dop1}}='true';}
				push(@dforma,{ 
				"$$hhs[$_]{dop2}" => "$$hhs[$_]{dop2}",
				OPISANIE => "$$hhs[$_]{'lang_'.$lang} ", 
				TYPE => "$$hhs[$_]{dop2}", 
				HELP => "$$hhs[$_]{help}",
				DISABLED => "$$forma_disabled{$$hhs[$_]{dop1}}",
				VALUE => $$forma_value{$$hhs[$_]{dop1}},
				NAME => "$$hhs[$_]{dop1}" });
		#	
		#		
		#		
		#		}
		#	else 
		#	{
		#if ($$hhs[$_]{dop2} eq 'checkbox'){$$forma_value{$$hhs[$_]{dop1}}='true';}
		#	push(@dforma,{ 
		#		OPISANIE => "$$hhs[$_]{'lang_'.$lang} ", 
		#		TYPE => "$$hhs[$_]{dop2}", 
		#		HELP => "$$hhs[$_]{help}",
		#		DISABLED => "$$forma_disabled{$$hhs[$_]{dop1}}",
		#		VALUE => "$$forma_value{$$hhs[$_]{dop1}}",
		#		NAME => "$$hhs[$_]{dop1}" });
		#	}
		} else  { $templateforma->param($$hhs[$_]{lang_key} => $$hhs[$_]{"lang_".$lang}); }
		
		
		}
		 $templateforma->param("FORMA" => \@dforma,"TEXTAREA" => \@tforma);  



		return $templateforma->output;
}
1;
