#!/usr/bin/perl -w
##
##  k_history - разный код для истории
##

require "../lib/k_DB.pl";
require "../lib/k_USEFULL.pl";


sub chk_user_login
{
	my $SQL="";
	my %hCOOKIES;
	my $U_ID = get_client_id();

	## Идентифицируем пользователя:
	## Проверяем прислал ли пользователь Cookie
	if(exists($ENV{'HTTP_COOKIE'}) and defined($ENV{'HTTP_COOKIE'}))
	{
		%hCOOKIES=split( /; |=/, $ENV{'HTTP_COOKIE'});
	}else
	{
		%hCOOKIES=('U_ID','0');
	}

	if ($hCOOKIES{'U_ID'} eq '0')
	{
		##$SQL = "INSERT INTO `site_sessions` (`U_ID`) VALUES (\'$U_ID\');";
		##db_put_once($SQL);
		##$COOKIES = $COOKIES2;
		##$COOK_NAME = "U_ID";
		##$COOK_VAL = $U_ID;
	}else
	{
	
	}	
}



1;