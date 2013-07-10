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


print 'PROXY LIST <form><textarea rows="15" cols="80" name="proxy"></textarea>


<input type="submit" name="send" tabindex="1" value="Отправить"/>';

#print substr('123456789',0,6);
$$value{form_data}{'proxy'} =~ s/ \:/:/g; 
 my @pairs = split(/ /,	$$value{form_data}{'proxy'});
 foreach $pair (@pairs)	{
	  $pair =~ s/ |\t//g; 
		my @pairs2 = split(/:/,	$pair);
	if ((length($pair) > 4) and (length($pairs2[0]) > 3) and (length($pairs2[1]) > 1)) {
	my ($fol,$hhs) = &get_query($$value{dbh},"SELECT `proxy` FROM proxy_list where `proxy` ='".$pair."' limit 0,1","hash","pr");
	print  $pair." stat $fol<br>"; 
	if ($fol == 0) {
		my ($fol3,$hhs3) = &get_query($$value{dbh},"INSERT into `proxy_list` (`proxy`,`yandex`, `yandex_time`,`time_add`) values ('".$pair."','300','1998-01-01 00:00:00',CURRENT_TIMESTAMP);","ins","pr");
	}
	}else {print  $pair." stat $fol<br>"; }

	  
 }
#print $$value{form_data}{'proxy'};

