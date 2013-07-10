#!/usr/bin/perl -w
##
##  k_general - здесь будут собираться основные функции для работы с сайтом
## для вызова из остальных файлов
##

require "../lib/k_DB.pl";
require "../lib/k_USEFULL.pl";

sub chk_user_login
{
	my $SQL="";
	my %hCOOKIES;
	my $U_ID = get_client_id();

	return 1;

}



1;