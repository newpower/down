#!/usr/bin/perl -w
##
##  k_header - вывод тега <HEAD>
##

require "../lib/k_DB.pl";
require "../lib/k_general.pl";
require "../lib/k_USEFULL.pl";

sub no_login
{
	return "	<FORM NAME=\"login_form\" ACTION=\"/cgi-bin/mag/site/lib/k_js.pl\" METHOD=\"POST\">\n".
"				<INPUT TYPE=\"text\" NAME=\"login_log\" style=\"width:30%;\" placeholder=\"Логин\">\n".
"				<INPUT TYPE=\"password\" NAME=\"login_pass\" style=\"width:30%;\" placeholder=\"Пароль\">\n".
"				<INPUT TYPE=\"submit\"  NAME=\"login_send\" VALUE=\"Войти\" style=\"width:50;\">\n".
"			</FORM>\n";
}

sub good_login
{
	return "	<TABLE style=\"width:100%;\">\n".
"				<TR>\n".
"				<TD style=\"width:33%;\">\n".
"				<A href=\"\">Tmp_1</A>\n".
"				</TD>\n".
"				<TD style=\"width:33%;\">\n".
"				<A href=\"\">Tmp_1</A>\n".
"				</TD>\n".
"				<TD style=\"width:33%;\">\n".
"				<A href=\"\">Tmp_1</A>\n".
"				</TD>\n".
"				</TR>\n".
"			</TABLE>\n";
}

sub get_header
{	
	return no_login();
}

1;