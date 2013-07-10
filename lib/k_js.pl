#!/usr/bin/perl -w
##
##  k_js - ответ на запросы от JS
##

require "../lib/k_DB.pl";
require "../lib/k_header.pl";
require "../lib/k_general.pl";
require "../lib/k_USEFULL.pl";

my %param = get_params();

for my $key {keys %param}
{
  print "$key=%param{$key},";
}

#unless(exists($param{'action'}) or defined($param{'action'})) {return 0;}

#if($param{'action'} eq "login")
#{
#  good_login();
#}



1;