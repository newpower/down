#!/usr/bin/perl

#view errors to browser
use CGI qw ( :standart);
use CGI::Carp qw ( fatalsToBrowser );  

require "../lib/def.pl";
require "../lib/parse_lib.pl";

	$varinfo{dbh}=condb("localhost","0000","root","280286","sh_downloads_zol");
	$varinfo2{dbh}=condb("localhost","0000","root","280286","sub_email");
print "Content-Type: text/html; charset=utf-8\n\n";

use MIME::Lite;
	
#&test_send(\%varinfo);
&send_message_from_base(\%varinfo2);
sub test_send
{
	my $varn=$_[0];
	
	$$varn{smtp}='agro2b.nawww.ru';
	$$varn{authuser}='admin@agro2b.nawww.ru';
	$$varn{authpass}='1234567aA';
	$$varn{from}='admin@agro2b.nawww.ru';
	$$varn{to}='vipdo@yandex.ru';
	$$varn{subject}='Subject to do';
	$$varn{data}='Message only';
	$$varn{charset}='UTF-8';
	$$varn{id}=rand();
	
	&mime_send_message($varn);
}
	
sub send_message_from_base
{
	my $varn=$_[0];
	#my $my_str1=get_name_translit($_[1]);
	my $per=rand();
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM message_send ms
left join `config_email_box` ceb on `ms`.`from` = `ceb`.`email` where `flag_send` = '0';","hash",'pr');
	for my $col(0..$fol32-1)
	{
		my $error_flag;
		my $error_string;
		
			foreach $k (split(/ /,'smtp authuser authpass from to subject data charset id'))
			{
				if ((length($k) < 1) or (length($$hhs32[$col]{$k}) < 1))
				{
					$error_flag++;
					$error_string=$error_string."Parametr $k ne ustanovlen  Znachenie $$hhs32[0]{$k} \n\n <BR><BR>";
					
				}
				print $k." - $$hhs32[$col]{$k}\n\n";
				$$varn{$k}=$$hhs32[$col]{$k};
			}
			
			
		if ($error_flag ==0)
		{
			
			&mime_send_message($varn);
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `message_send` SET `flag_send`='1',`date_send` = CURRENT_TIMESTAMP where `id` = \'".$$hhs32[$col]{id}."\'","ins","do");
			
		}
		else
		{
			print $error_string;
		}
		sleep(20);
	
	}
  
	
}

sub mime_send_message
{
	my $varn=$_[0];

	my  $msg = MIME::Lite->new(
        From     => $$varn{from},
        To       => $$varn{to},
        Subject  => $$varn{subject},
        Data     => $$varn{data}
    );

    $msg->attr('content-type.charset' => $$varn{charset});
    $msg->add('X-Comment' => "ID^ $$varn{id}");
	$msg->send('smtp', "$$varn{smtp}", 'AuthUser'=> "$$varn{authuser}", 'AuthPass'=> "$$varn{authpass}" ,'Debug'=>'1');
}

