﻿#!/usr/bin/perl

print "Content-Type: text/html; charset=utf-8\n\n";

use CGI qw ( :standart);
use CGI::Carp qw ( fatalsToBrowser );  



require HTML::Parser;
 require HTML::TokeParser;
 use Encode;
# use warnings;

require "../lib/def.pl";
require "../lib/parse_lib.pl";



my %varinfo;  

	#		40702810252090106788
	$varinfo{dbh}=condb("localhost","0000","root","280286","sh_downloads_zol");
	
	print "test1\n\n";
	#	&seach_link_table_page_and_catalog(\%varinfo,'105778');
	#	exit;
	#&perenos_res_html_to_table(\%varinfo,'');
	#&download_table_page_and_catalog(\%varinfo,'http://www.e-disclosure.ru');
	#exit;

	
	#&parse_email_table_page_and_catalog(\%varinfo,'');
	#print &get_email_in_url_table_page_and_catalog(\%varinfo,'http://www.furazh.ru/sendemail/?email= yNUVynmI94O090nBL7b3Ag%3D%3D');
	#exit;
	#print "Prom test\n\n";

	my $url="http://www.furazh.ru/declar/?id=";
	#for my $iu (2700000..3700000)3667209
	#for my $iu (2700000..2800000)
	
	#{
	#	my $url2=$url.$iu;
	#	print "ss".$url2."\n";
	#	&set_link_table_page_and_catalog(\%varinfo,$url2);
	
	
	#}
	
	
	#exit;

	#&parse_clas_table_page_and_catalog(\%varinfo,'');
	
	
		

###	скачивание данных
while (1)
{
	#&download_table_page_and_catalog(\%varinfo,'furazh.ru/declar');
	&parse_clas_table_page_and_catalog(\%varinfo,'');
	print "zhdem 2s\n";
	sleep(2);
	#exit;
	
}	

#	&parse_clas_table_page_and_catalog(\%varinfo,'');
		print "test2 \n\n";
	

	#update `page_and_catalog` SET `flag_downloads`=0 WHERE 1 and `url` like '%http://doska.zol.ru/?nearby_regions=On&%'
	
		
sub parse_email_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	#my $id_string=$_[1];
	
	
			my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `id`,`t_mail_pic_link` FROM `zol_doska_contragent` WHERE `t_mail` IS NULL AND `t_mail_pic_link` IS NOT NULL  and `t_mail_pic_link` like '%fur%' limit 0,150000;","hash","pr");
	
	for my $col(0..$fol-1)
	{
	
			my %hash_vinfo;
		$hash_vinfo{id} = $$hhs[$col]{id};
		$hash_vinfo{url} = $$hhs[$col]{t_mail_pic_link};
		$hash_vinfo{url} =~ s/hidetext/hidemail/g;

		$hash_vinfo{url} =~ s/ //g;
		print $hash_vinfo{url}." <br>";
	
		my $res = get_page(\%hash_vinfo,'');
	
		$hash_vinfo{res_code}=$res->code;
		$hash_vinfo{res_html} = $res->content; 
		
	
		#my $line=$hash_vinfo{res_html};
		#		print $hash_vinfo{url}." ___ $line ____";
	
		my $var_email_string = &get_email_in_url_table_page_and_catalog($varn,$hash_vinfo{url});
		
		
		#if ($line  =~ /\w+?\@(\w+?\.)+\w+?/)
		#if ($line =~ /\b[\w.-]+@[\w.-]+.\w{2,4}\b/g)
		if ($var_email_string =~ /\b[\w.-]+@[\w.-]+.\w{2,4}\b/g)
		{
			print $&."$hash_vinfo{id} - $hash_vinfo{url} DDDDSSSS<br>\n";
			#my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `zol_doska_contragent` SET `t_mail`='".$&."' where `t_mail_pic_link` = \'".$$hhs[$col]{t_mail_pic_link}."\'","ins","do");
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `zol_doska_contragent` SET `t_mail`='".$var_email_string."' where `id` = \'".$$hhs[$col]{id}."\'","ins","do");
			#exit;
		} 
 
		#exit;
	}
}
	
sub get_email_in_url_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	my $var_url_string=$_[1];

	
	$var_url_string =~ s/hidetext/hidemail/g;

	$var_url_string =~ s/ //g;
	
	
	
	
	my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT * FROM `url_hash_to_mail` WHERE `url` like '$var_url_string' limit 0,1;","hash","pr");
	
	if ($fol > 0)
	{
		#print $fol."opa".$$hhs[0]{email};
		return $$hhs[0]{email};
		
	}
	else{
		my %hash_vinfo;
		$hash_vinfo{id} = 1;
		$hash_vinfo{url} = $var_url_string;

		#print $hash_vinfo{url}." <br>";
		
		my $res = get_page(\%hash_vinfo,'');
	
		$hash_vinfo{res_code}=$res->code;
		$hash_vinfo{res_html} = $res->content;
	
		my $line=$hash_vinfo{res_html};
		#		print $hash_vinfo{url}." ___ $line ____";
	
		
		#if ($line  =~ /\w+?\@(\w+?\.)+\w+?/)
		if ($line =~ /\b[\w.-]+@[\w.-]+.\w{2,4}\b/g)
		{
			$hash_vinfo{t_mail}=$&;
			print $&."$hash_vinfo{id} - $hash_vinfo{url} DDDDSSSS<br>\n";
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"INSERT INTO `url_hash_to_mail` (`url`,`email`,`datetime_create`) values ('$hash_vinfo{url}','$hash_vinfo{t_mail}',CURRENT_TIMESTAMP)","ins","do");
			#exit;
			return $hash_vinfo{t_mail};
		}
	}
	
	
	
}	
	
	
	
sub parse_clas_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	my $id_string=$_[1];
	my $flag_show_podrob=$_[2];
	my $kolich_strok_obrabotki=$_[3];
	
	
	
	if ($id_string ne '') { $id_string="and `pc`.`id` = \'".$id_string."\'";}
		my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `pc`.`id` as `id`,`pc`.`url` as `url`,`ph`.`res_html` as `res_html` FROM `page_and_catalog` as `pc`
				LEFT JOIN `page_html_2` as `ph`	ON 
				`pc`.`id`=`ph`.`id` where
				`pc`.`flag_downloads` =1 and `pc`.`flag_use`=0 $id_string limit 0,1500;","hash","pr");
	
	for my $col(0..$fol-1)
	{
		my %hash_vinfo;
		$hash_vinfo{url} = $$hhs[$col]{url};
		$hash_vinfo{id} = $$hhs[$col]{id};
		print $hash_vinfo{id};
		$hash_vinfo{res_html} = $$hhs[$col]{res_html};
		my $count_vsego;
		my $count_seach;
		my $count_new;
		
		my %hash_rekvisit;
		
		my $pos=index($hash_vinfo{url}, '.zol.ru/Prodazha/');
		my $pos2=index($hash_vinfo{url}, '.zol.ru/Pokupka/');
		my $pos3=index($hash_vinfo{url}, '.zol.ru/Uslugi-spros/');
		my $pos4=index($hash_vinfo{url}, '.zol.ru/Uslugi-predlozhenie/');
		
		#Obrabotka dlya saita fermer.ru
		my $pos5=index($hash_vinfo{url}, 'fermer.ru/');
		

	
		if ($pos5 >= 0)
		{
	
			$tex_ish =$hash_vinfo{res_html};
			my $var_index =index($tex_ish, '</table></div>');
			
			$tex_ish =substr($tex_ish,$var_index);
			$tex_ish =~ s/\'/"/g;
			#зарегистрируйтесь
						my $var_index2 =index($tex_ish, 'Для комментирования');
			#$var_index2=200;
			$tex_ish =substr($tex_ish,0,$var_index2);
			$tex_ish2=$tex_ish ;
			
			$tex_ish =~ s/\<\/div\>\n    <div class="field-items">\n            <div class="field-item odd">/+/g;
			$tex_ish =~ s/\&nbsp\;//g;
			
			#$tex_ish =~ s/\n//g;
						
						
			$p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
		
			while (my $token = $p1->get_tag("h2")) 
			{
				#my $url1 = $token->[1]{href} || "-";
				my $text = $p1->get_trimmed_text("/h2");
				#my @m_mas = split(/\+/,$text);
				$hash_rekvisit{'t_message_title'}=$text;
				last;
			
			}
			
			while (my $token = $p1->get_tag("div")) 
			{
				my $url1 = $token->[1]{class} || "-";
				my $text = $p1->get_trimmed_text("/div");
				#my @m_mas = split(/\+/,$text);
				my @m_mas = split(/\+/,$text);
				if ($m_mas[0] eq 'Цена, руб.:')	
				{
					if (length($m_mas[1]) > 244)
					{
						$m_mas[1]=substr($m_mas[1],0,244);
					}
					
					$hash_rekvisit{'t_cost'}=$m_mas[1];
				}			
				if ($m_mas[0] eq 'Населенный пункт (город, село, поселок):')	
				{
					if (length($m_mas[1]) > 244)
					{
						$m_mas[1]=substr($m_mas[1],0,244);
					}
					$hash_rekvisit{'t_region'}=$m_mas[1];
				}			
				if (($m_mas[0] eq 'E-mail :') and ($line =~ /\b[\w.-]+@[\w.-]+.\w{2,4}\b/g))
				{
					$hash_rekvisit{'t_mail'}=$m_mas[1];
				}			
				if ($m_mas[0] eq 'Контакты (телефон, ICQ, Skype и др.):')	
				{
					if (length($m_mas[1]) > 244)
					{
						$m_mas[1]=substr($m_mas[1],0,244);
					}
					$hash_rekvisit{'t_tel'}=$m_mas[1];
					
				}
					
				if (index($text, 'Tags:') == 0)
				{
					my @m_mas2 = split(/\:/,$text);
					$hash_rekvisit{'t_catigoriya'}=$m_mas2[1];
				}				
				
				#if ($url1 eq 'footer')
				#{		
				#	my @m_mas = split(/\+/,$text);	
				#	if ($m_mas[0] eq 'Регион:')	{$hash_rekvisit{'t_region'}=$m_mas[1];}					
				#	
				#	
				#
				#}	
				#last;
			}	
			
			$p2 = HTML::TokeParser->new(\$tex_ish2) || die "Can't open: $!";
			$p2->empty_element_tags(1);  # configure its behaviour
			while (my $token = $p2->get_tag("span")) 
			{
				my $url1 = $token->[1]{class} || "-";
				my $text = $p2->get_trimmed_text("/span");
				
				if (index($text, 'Posted at ') == 0)
				{
					my @m_mas3 = split(/ /,$text);
					my @m_mas_time = split(/\//,$m_mas3[5]);
					#print "$m_mas3[5] $m_mas_time[0]  VV<br>";
					
					$text = $m_mas_time[2]."-".$m_mas_time[0]."-".$m_mas_time[1]." ".$m_mas3[2];
					#print "time ".$text;
					#exit;
					$hash_rekvisit{'t_razmesheno'}="STR_TO_DATE( '".$text."', ' %Y-%m-%d %H:%i' )";
				
				}
				#print "$text $url1 MM MM <br>";
				
			}
						$p2 = HTML::TokeParser->new(\$tex_ish2) || die "Can't open: $!";
			$p2->empty_element_tags(1);  # configure its behaviour
			my $var_text;
			my $var_count;
			while (my $token = $p2->get_tag("p")) 
			{
				my $url1 = $token->[1]{class} || "-";
				my $text = $p2->get_trimmed_text("/p");
				$var_count++;
				if ($var_count > 2)
				{
					$var_text=$var_text.$text;
				}
				#print "$text \</br>";
				#print "$text $url1 MM MM <br>";
				
			}
			$hash_rekvisit{'t_message'} = $var_text;
			
			
			
		}
		
		my $pos6=index($hash_vinfo{url}, 'furazh.ru/');
		if ($pos6 > 0) 
		{
			my $kat_group = "1"; 
			my $tex_ish =$hash_vinfo{res_html};
			$tex_ish = Encode::decode('cp1251', $tex_ish);
			$tex_ish = Encode::encode('utf8', $tex_ish);
			#print $tex_ish;
			#exit;

			my $var_index =index($tex_ish, '<div style="text-align:center;font-weight:600;">');
			$tex_ish =substr($tex_ish,$var_index);
			
			my $var_index2 =index($tex_ish, 'Объявление размещено в разделах');
			#$var_index2=200;
			$tex_ish =substr($tex_ish,0,$var_index2);
					$tex_ish =~ s/\<\/span\>/^/g;
			$tex_ish =~ s/\<\/font\>/+/g;
			$tex_ish =~ s/\&nbsp\;/ /g;
			$tex_ish =~ s/\<a href\=\"javascript\:sendemail\(\"/ /g;
			$tex_ish =~ s/\"\)\;\"\>/ /g;
			
			#id, c_name, t_region, t_mail, t_mail_pic_link, t_tel, t_razmesheno, t_read, t_catigoriya, t_message, t_message_title	
			my $p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
		
			while (my $token = $p1->get_tag("a")) 
			{
				my $url1 = $token->[1]{href} || "-";
				my $text = $p1->get_trimmed_text("/a");
				#my @m_mas = split(/\+/,$text);
				$hash_rekvisit{'t_message_title'}=$text;
				last;
			
			}
			while (my $token = $p1->get_tag("p")) 
			{
				my $url1 = $token->[1]{valign} || "-";
				my $text = $p1->get_trimmed_text("/p");
				#my @m_mas = split(/\+/,$text);
				
					$hash_rekvisit{'t_message'}=$text;
					last;
			
				
			}	
			$tex_ish =~ s/\<br\>/\<\/span\>/g;
			$tex_ish =~ s/\<BR\>\<BR\>/\<\/span\>\<span\>/g;
			$tex_ish =~ s/\<BR\>/\<\/span\>/g;
			$p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
			while (my $token = $p1->get_tag("span")) 
			{
				my $url1 = $token->[1]{color} || "-";
				my $text = $p1->get_trimmed_text("span");
				#my @m_mas = split(/\+/,$text);
				
				my @m_mas = split(/\^/,$text);	
				#print "$m_mas[0] $m_mas[1] $text <br>";
				if ($m_mas[0] eq 'Автор:')	{$hash_rekvisit{'c_name'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Телефон:')	{$hash_rekvisit{'t_tel'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Регион:')	{$hash_rekvisit{'t_region'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Размещено:')	
				{
					
					$hash_rekvisit{'t_razmesheno'}="STR_TO_DATE( '".$m_mas[1]."', ' %d.%m.%Y %H:%i' )";
				}					
				if ($m_mas[0] eq 'Email:')	
				{
					$hash_rekvisit{'t_mail_pic_link'}="http://www.furazh.ru/sendemail/?email=".$m_mas[1];
					$hash_rekvisit{'t_mail'}=&get_email_in_url_table_page_and_catalog($varn,$hash_rekvisit{'t_mail_pic_link'});
				}					
				if ($m_mas[0] eq 'Категория:')	{$hash_rekvisit{'t_catigoriya'}=$m_mas[1];}					
				#print "$m_mas[0] -- $m_mas[1] <br><br><br>";
	
			}	
		}
		
		
		
		if (($pos > 0) or ($pos2 > 0) or ($pos3 > 0) or ($pos4 > 0))
		{
			my $kat_group = "1"; 
			$tex_ish =$hash_vinfo{res_html};
			$tex_ish = Encode::decode('cp1251', $tex_ish);
			$tex_ish = Encode::encode('utf8', $tex_ish);

			
			my $var_index =index($tex_ish, '<div align="center" style="margin:5px;">');
			$tex_ish =substr($tex_ish,$var_index);
			my $var_index2 =index($tex_ish, 'Адрес объявления:&nbsp');
			#$var_index2=200;
			$tex_ish =substr($tex_ish,0,$var_index2);
			
			
			$tex_ish =~ s/\<\/span\>/+/g;
			$tex_ish =~ s/\<\/font\>/+/g;
			$tex_ish =~ s/\&nbsp\;/ /g;
			
			
			#id, c_name, t_region, t_mail, t_mail_pic_link, t_tel, t_razmesheno, t_read, t_catigoriya, t_message, t_message_title	
			$p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
		
			while (my $token = $p1->get_tag("h2")) 
			{
				#my $url1 = $token->[1]{href} || "-";
				my $text = $p1->get_trimmed_text("/h2");
				#my @m_mas = split(/\+/,$text);
				$hash_rekvisit{'t_message_title'}=$text;
				last;
			
			}
			
			while (my $token = $p1->get_tag("td")) 
			{
				my $url1 = $token->[1]{valign} || "-";
				my $text = $p1->get_trimmed_text("/td");
				#my @m_mas = split(/\+/,$text);
				if ($url1 eq 'top')
				{		
					$hash_rekvisit{'t_message'}=$text;
					last;
			
				}	
			}		
			while (my $token = $p1->get_tag("span")) 
			{
				my $url1 = $token->[1]{class} || "-";
				my $text = $p1->get_trimmed_text("/a");
				#my @m_mas = split(/\+/,$text);
				if ($url1 eq 'footer')
				{		
					my @m_mas = split(/\+/,$text);	
					if ($m_mas[0] eq 'Регион:')	{$hash_rekvisit{'t_region'}=$m_mas[1];}					
					
					
			
				}	
				last;
			}	
			$p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
			while (my $token = $p1->get_tag("font")) 
			{
				my $url1 = $token->[1]{color} || "-";
				my $text = $p1->get_trimmed_text("br");
				#my @m_mas = split(/\+/,$text);
				
				my @m_mas = split(/\+/,$text);	
				if ($m_mas[0] eq 'Автор:')	{$hash_rekvisit{'c_name'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Телефон:')	{$m_mas[1] =$m_mas[2]; $hash_rekvisit{'t_tel'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Размещено: ')	
				{
					
					$hash_rekvisit{'t_razmesheno'}="STR_TO_DATE( '".$m_mas[1]."', ' %d.%m.%Y %H:%i' )";
				}					
				if ($m_mas[0] eq 'Число просмотров')	{$hash_rekvisit{'t_read'}=$m_mas[1];}					
				if ($m_mas[0] eq 'Категория: ')	{$hash_rekvisit{'t_catigoriya'}=$m_mas[1];}					
				#print "$m_mas[0] -- $m_mas[1] <br><br><br>";
	
			}	
			$p1 = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
			$p1->empty_element_tags(1);  # configure its behaviour
			while (my $token = $p1->get_tag("img")) 
			{
				my $url1 = $token->[1]{src} || "-";
				#my $text = $p1->get_trimmed_text("/a");
				
				$hash_rekvisit{'t_mail_pic_link'}=$url1;
				my $pos=index($hash_vinfo{url}, 'http://doska.zol.ru/?module=hidemail&email=');
				if ($pos > 0)
				{
					last;
				}
				

			}	

					
			print "**** id [ $hash_vinfo{id} ] $var_index $var_index2 $hash_rekvisit{'t_region'} * \$tex_ish Адрес объявления:\n\n";
			
					#id, c_name, t_region, t_mail, t_mail_pic_link, t_tel, t_razmesheno, t_read, t_catigoriya, t_message, t_message_title
			
		}
		
			my ($str_per1, $str_per2, $str_per3,$count_seach);	
			for (keys %hash_rekvisit){
				$str_per1=$str_per1."\`$_\`,";
				if ($_ eq 't_razmesheno')
				{
					$str_per2=$str_per2."$hash_rekvisit{$_},";
				}
				else
				{
					$str_per2=$str_per2."\'$hash_rekvisit{$_}\',";
				}
				$str_per3=$str_per3."\`$_\` = \'$hash_rekvisit{$_}\' and";
				$count_seach++;
				print "$_ - $hash_rekvisit{$_} <br>";
			}
			
			chop($str_per1);
			chop($str_per2);
			$str_per3=$str_per3." \'1\'";
		
			
			if ($count_seach > 0)
			{
				#print $count_seach." CCC <br>";
				my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"DELETE from `zol_doska_contragent` WHERE `id` = \'".$hash_vinfo{id}."\'","ins","do");
				my $str_per2 = "INSERT INTO `zol_doska_contragent` ($str_per1,`id`) values ($str_per2,\'".$hash_vinfo{id}."\')";
				$str_per2 =~ s/\\'/+\'/g;
				#print $str_per2;
				my ($fol3,$hhs3) = &get_query($$varn{"dbh"},$str_per2,"ins","do");
				#print $str_per2;
				#exit;
			}
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `page_and_catalog` SET `flag_use`='1' where `id` = '$hash_vinfo{id}'","ins","do");
			print "\n vse ok $hash_vinfo{id}  parametrov $count_seach ustanovlen flag_use=1 $hash_vinfo{url}<br><br>\n";
	
	}
	
	print "<meta http-equiv=\"refresh\" content=\"1\"; url=\"http://127.0.0.1/cgi-bin/parse/zernotrader_downloader_1.pl\">";
}


sub perenos_res_html_to_table
{
	## (varn,)
	my $varn=$_[0];
	my $id_string=$_[1];
	
	if ($id_string ne '') { $id_string="and `pc`.`id` = \'".$id_string."\'";}
	print "Poluchaem stranici <br>\n\n";
	my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `id`,`url`,`res_html`, `date_downloads` FROM `page_and_catalog` where `flag_downloads` = '1' and `res_html` != '200' limit 0,10000;","hash","pr");
	
	for my $col(0..$fol-1)
	{
		my %hash_vinfo;
		$hash_vinfo{url} = $$hhs[$col]{url};
		$hash_vinfo{id} = $$hhs[$col]{id};
		#$hash_vinfo{res_html} = $$hhs[$col]{res_html};
		$hash_vinfo{date_downloads} = $$hhs[$col]{date_downloads};
		print "ID perenesen $$hhs[$col]{id} $$hhs[$col]{url} <br>\n\n";
		my ($fol8,$hhs8) = &get_query($varinfo{dbh},"INSERT INTO `page_html_2` (`id`,`url`,`res_html`,`date_downloads`) values ('".$$hhs[$col]{id}."','".$$hhs[$col]{url}."','".$$hhs[$col]{res_html}."','".$$hhs[$col]{date_downloads}."')","ins","pr");
		my ($fol8,$hhs8) = &get_query($$varn{dbh},"UPDATE `page_and_catalog` SET `res_html`='200'  where `id` = \'".$$hhs[$col]{id}."\' limit 1","ins","pr");
		
		
	}
	
}





sub seach_link_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	my $id_string=$_[1];
	
	if ($id_string ne '') { $id_string="and `pc`.`id` = \'".$id_string."\'";}
			my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `pc`.`id` as `id`,`pc`.`url` as `url`,`ph`.`res_html` as `res_html` FROM `page_and_catalog` as `pc`
				LEFT JOIN `page_html_2` as `ph`	ON 
				`pc`.`id`=`ph`.`id` where
				`pc`.`flag_downloads` =1 $id_string limit 0,15000;","hash","pr");
	#my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `id`,`url`,`res_html` FROM `page_and_catalog` where `flag_downloads` =1 $id_string limit 0,15000;","hash","pr");
	
	for my $col(0..$fol-1)
	{
		my %hash_vinfo;
		$hash_vinfo{url} = $$hhs[$col]{url};
		$hash_vinfo{id} = $$hhs[$col]{id};
		$hash_vinfo{res_html} = $$hhs[$col]{res_html};
		my $count_vsego;
		my $count_seach;
		my $count_new;
		
		

		use URI;
		#print "$hash_vinfo{url}";
		#my $url0 = URI->new($hash_vinfo{url});
		#my $host   = $url0->host();
		my($scheme, $authority, $path, $query, $fragment) =	$hash_vinfo{url} =~ m|(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*)(?:\?([^#]*))?(?:#(.*))?|;
		#print "$scheme, $authority, $path, $query, $fragment";
		$p = HTML::TokeParser->new(\$hash_vinfo{res_html}) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour		
		while (my $token = $p->get_tag("a")) 
		{
			my $url1 = $token->[1]{href} || "-";
			my $text = $p->get_trimmed_text("/a");
			my($scheme2, $authority2, $path2, $query2, $fragment2) =	$url1 =~ m|(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*)(?:\?([^#]*))?(?:#(.*))?|;
			
			if (length($authority2) == 0)
			{
				$url1=$scheme.":\/\/".$authority.$url1;
			}
			
			#print " ++ $url0  -- $host ++  $url1 ++<br>"; 	
			
			$count_vsego++;

			$pos=index($url1, '.zol.ru/Prodazha/');
			$pos2=index($url1, '.zol.ru/Pokupka/');
			$pos3=index($url1, '.zol.ru/Uslugi-spros/');
			$pos4=index($url1, '.zol.ru/Uslugi-predlozhenie/');
			$pos5=index($url1, '.zol.ru/?nearby_regions');
			$pos6=index($url1,'any.aspx?id');
			$pos7=index($url1,'fermer.ru/gazeta');
			$pos8=index($url1,'fermer.ru/spros');
			$pos9=index($url1,'fermer.ru/gazeta?page=');
			$pos10=index($url1,'fermer.ru/spros?page=');
			$pos11=index($url1,'furazh.ru/declar/?id=');
			if ($pos6 > 0)
			{
				#print "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";
				@m_mas3 = split(/\=/,$url1);
				$url1="http://www.e-disclosure.ru/portal/requisite.aspx?id=".$m_mas3[1];
				##print $url1." -- -- \n\n <br>";
				
			}
			if (index($url1,'fermer.ru') >=0)
			{
				if ((index($url1,'comment') >= 0) or (index($url1,'order=') >=0) or (index($url1,'sort=') >=0) or (length($url1) > 35))
				{
					$pos7=0;
					$pos8=0;
					$pos9=0;
					$pos10=0;
					#print "$url1 ==== =\n\n";
				}
			}
			#print "$pos7 - $pos7 = fermer =  $url1 -- \n<br>";
			
			#http://www.e-disclosure.ru/portal/main.aspx?type=16 http://www.e-disclosure.ru/portal/company.aspx http://www.e-disclosure.ru/portal/requisite.aspx?id=2386
			#http://pskov.zol.ru/Prodazha/Maslo-podsolnechnoe-optom-podsolnechnik-s-dostavkoj_Prodam_3614104.html
			#http://penza.zol.ru/Pokupka/Kupim-semena-gorchitsy-pelyushki-lyupina-k-bobov-svekly_Kuplu_semena_3614065.html
			#http://belgorod.zol.ru/Uslugi-spros/Spros-na-uslugi_3614074.html
			#http://rostov.zol.ru/Uslugi-predlozhenie/Transportnye-uslugi_3614100.html
			#http://doska.zol.ru/?nearby_regions=On&nearby_countries=On&without_exact_fo=On&page=5
			#print "$pos $pos2 $pos3 $url1\n\n";
			if (($pos >= 0) or ($pos2 >= 0) or ($pos3 >= 0) or ($pos4 >= 0) or ($pos5 >= 0) or ($pos6 >= 0) or ($pos7 >= 0) or ($pos8 >= 0) or ($pos9 >= 0) or ($pos10 >= 0) or ($pos11 >= 0))
			{
				$count_seach++;
				#print "$pos - $url1\t$1text\n <br>";
				#push(@url_list,$url1);
				$count_new+=&set_link_table_page_and_catalog($varn,$url1);
			}	

		}
		print "$hash_vinfo{url} -  count vsego $count_vsego count naideno $count_seach count new $count_new \n\n";
			
	}
	


}	

sub set_link_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	my $link=$_[1];
	
	
	#print $link."\n\n";
	
	$fol=0;
	#my ($fol,$hhs) = &get_query($$varn{dbh},"	SELECT `id`,`url` FROM `page_and_catalog` where `url` =\'".$link."\' and `id` > 0 $str_site limit 0,1500;","hash","pr");
	if ($fol == 0)
	{
		
		#my $fol8 = 1;
		my ($fol8,$hhs8) = &get_query($varinfo{dbh},"INSERT INTO `page_and_catalog` (`url`,`flag_downloads`,`flag_use`,`date_add_url`) values ('".$link."','0','0',CURRENT_TIMESTAMP)","ins","pr");
		if ($fol8 == 1)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	
	}

}

sub download_table_page_and_catalog
{
	## (varn,)
	my $varn=$_[0];
	my $str_site=$_[1];
	
	if ($str_site ne '') 
	{
		$str_site="and `url` like \'%".$str_site."%\'";
	}
	print "	SELECT `id`,`url` FROM `page_and_catalog` where `flag_downloads` =0 and `flag_use`=0 and `id` > 0 $str_site limit 0,750;";
	my ($fol,$hhs) = &get_query($$varn{dbh},"	SELECT `id`,`url` FROM `page_and_catalog` where `flag_downloads` =0 and `flag_use`=0 and `id` > 0 $str_site limit 0,4750;","hash","pr");

	for my $col(0..$fol-1)
	{
		my %hash_vinfo;
		$hash_vinfo{url} = $$hhs[$col]{url};
		$hash_vinfo{id} = $$hhs[$col]{id};
		
		print "<br> Downloads page $hash_vinfo{id} -- $hash_vinfo{url} <br>Next \n\n";
		

		
		my $res = get_page(\%hash_vinfo,'');
	
		$hash_vinfo{res_code}=$res->code;
		$hash_vinfo{res_html} = $res->content; 
		#$varinfo{res_html} = Encode::decode('utf8', $varinfo{res_html});
		#$varinfo{res_html} = Encode::encode('cp1251', $varinfo{res_html});
		#$varinfo{res_html} = Encode::decode('cp1251', $varinfo{res_html});
		#$varinfo{res_html} = Encode::encode('utf8', $varinfo{res_html});
		
		
		$hash_vinfo{res_html} =~ s/\'/\"/g;
  
  	
		my ($fol8,$hhs8) = &get_query($$varn{dbh},"UPDATE `page_and_catalog` SET `flag_downloads`=1, `date_downloads` = CURRENT_TIMESTAMP, `res_code` = \'".$hash_vinfo{res_code}."\',`res_html`=\'200\' where `id` = \'".$hash_vinfo{id}."\' limit 1","ins","pr");
	
	my ($fol8,$hhs8) = &get_query($varinfo{dbh},"DELETE FROM `page_html_2` WHERE `id` = '".$hash_vinfo{id}."' limit 1;","ins","pr");
	my ($fol8,$hhs8) = &get_query($varinfo{dbh},"INSERT INTO `page_html_2` (`id`,`url`,`res_html`,`date_downloads`) values ('".$hash_vinfo{id}."','".$hash_vinfo{url}."','".$hash_vinfo{res_html}."', CURRENT_TIMESTAMP);","ins","pr");
	#	my ($fol8,$hhs8) = &get_query($$varn{dbh},"UPDATE `page_and_catalog` SET `res_html`='200'  where `id` = \'".$$hhs[$col]{id}."\' limit 1","ins","pr");
	
		#&seach_link_table_page_and_catalog($varn,$hash_vinfo{id});
		#&parse_page_zol(\%varinfo);
	
	}



}	
	
	
	
sub parse_zernotrader_from_base
{
	
	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `id`,`text`,`url` FROM t_page where `flag_downloads` =1 and `flag_use`='0' and `id` > 0 limit 0,1500;","hash","pr");
	#my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `id`,`text`,`url` FROM t_page where `id` = '2101' limit 0,1;","hash","pr");

	for my $col(0..$fol-1)
	{
		$varinfo{url} = $$hhs[$col]{url};
		$varinfo{id} = $$hhs[$col]{id};
		$varinfo{res_html} = $$hhs[$col]{text}; 
		$varinfo{res_html} = Encode::decode('cp1251', $varinfo{res_html});
		$varinfo{res_html} = Encode::encode('utf8', $varinfo{res_html});
		
		
		&parse_company(\%varinfo);
	
	}

}

sub parse_company
{
	my $varn=$_[0];
	my $text;

	my $tex_ish='';
	my %hash_rekvisit;
		
		
	$text=$text."Obrabotka zapisi ".$$varn{id}."\n";
	$tex_ish =$$varn{res_html};

	
	

	

		my $kat_group = "1"; 

		$tex_ish =~ s/\<\/td\>\<td\>/+/g;
		my $var_index =index($tex_ish, '<div class="main">');
		$tex_ish1 =substr($tex_ish,$var_index);
		my $tex_ish2 =substr($tex_ish1,0,200);
		
		$p1 = HTML::TokeParser->new(\$tex_ish2) || die "Can't open: $!";
		$p1->empty_element_tags(1);  # configure its behaviour
		
		while (my $token = $p1->get_tag("h2")) {
			#my $url1 = $token->[1]{href} || "-";
			my $text = $p1->get_trimmed_text("/h2");
			#my @m_mas = split(/\+/,$text);
			$hash_rekvisit{'name'}=$text;
			
			}
		
		

		
		
		
		$p = HTML::TokeParser->new(\$tex_ish1) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour
		
		while (my $token = $p->get_tag("tr")) {
			#my $url1 = $token->[1]{href} || "-";
			my $text = $p->get_trimmed_text("/tr");
			my @m_mas = split(/\+/,$text);
				
			
				
				
				if ($m_mas[0] eq 'ИНН/КПП')	{$hash_rekvisit{'inn-kpp'}=$m_mas[1]; }
				if ($m_mas[0] eq 'Юридический адрес')	{$hash_rekvisit{'ur-adr'}=$m_mas[1];}
				if ($m_mas[0] eq 'Почтовый адрес')	{$hash_rekvisit{'post-adr'}=$m_mas[1];}
				if ($m_mas[0] eq 'Телефон')	{$hash_rekvisit{'tel'}=$m_mas[1];}
				if ($m_mas[0] eq 'Факс')	{$hash_rekvisit{'fax'}=$m_mas[1];}
				if ($m_mas[0] eq 'E-mail')	{$hash_rekvisit{'e-mail'}=$m_mas[1];}
				if ($m_mas[0] eq 'URL')	{$hash_rekvisit{'url'}=$m_mas[1];}
				if ($m_mas[0] eq 'Информация')	{$hash_rekvisit{'info'}=$m_mas[1];}
				
			
			}

		#id, name, inn-kpp, ur-adr, post-adr, tel, fax, e-mail, info
			my ($str_per1, $str_per2, $str_per3);	
			for (keys %hash_rekvisit){
				$str_per1=$str_per1."\`$_\`,";
				$str_per2=$str_per2."\'$hash_rekvisit{$_}\',";
				$str_per3=$str_per3."\`$_\` = \'$hash_rekvisit{$_}\' and";
			
			}
			chop($str_per1);
			chop($str_per2);
			$str_per3=$str_per3." \'1\'";
				
				

			my ($fol7,$hhs7) = &get_query($$varn{dbh},"SELECT * FROM `t_catalog` where $str_per3 LIMIT 0,1;","hash","pr");
			#print "= $fol7 = 0 - $hash_rekvisit{'name'} 1 - $hash_rekvisit{'inn-kpp'} 2 - $hash_rekvisit{'ur-adr'} 3 - $hash_rekvisit{'post-adr'} 4 5 6 7 ";
	

		if (($fol7 == 0) and ($hash_rekvisit{'name'} ne '')) 
		{
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"}," INSERT INTO `t_catalog` ($str_per1) values ($str_per2)","ins","do");
			#print "INSERT INTO `t_catalog` ($str_per1) values ($str_per2)";
			print "Добавлен контрагент $$varn{id} ****  *** INN*- $hash_rekvisit{'inn-kpp'} *INN** $hash_rekvisit{'e-mail'} $hash_rekvisit{'name'}  **<br><br>\n\n\n";
				
		}
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `t_page` SET `flag_use`='1' where `id` = '$$varn{id}'","ins","do");
		print "\n vse ok $$varn{id} flag_use=1 <br><br>\n";

				
	##		my @m_mas = split(/\+/,$text);
    ##
	##		if ((length($m_mas[0]) > 3) and (length($m_mas[1]) <= 0) and (length($m_mas[0]) <= 255)) 
	##		{
	##			$kat_group=$m_mas[0];
	##			$count_posit=$count_har*100;
	##			#print "22".length($m_mas[1])."";
	##			$count_har++;
	##		}
	##		#if (length($m_mas[0]) > 3) {
	##		#print "=?= $m_mas[0] =P=  $m_mas[1]  - $kat_group $count_posit<br>";
	##		#}
	##		if ((length($m_mas[1]) > 0) and (length($m_mas[0]) > 0)) {
	##			$count_posit++;
	##			if (length($m_mas[0]) >254) {$m_mas[0]='no';print "ddd";}
	##		
	##			my $n_trans=get_name_translit($m_mas[0]);
	##			push(@col_list,$m_mas[0]);
	##			$col_hash{$n_trans}=$m_mas[1];
	##			$col_hash_group{$n_trans}=$kat_group if not exists $col_hash_group{$n_trans};
    ##
	##			$col_hash_position{$n_trans}=$count_posit if not exists $col_hash_position{$n_trans};
	##			#print "=?= $n_trans =X= $m_mas[0] =P=  $col_hash{$n_trans}  GROUP: $col_hash_group{$n_trans} POS: $col_hash_position{$n_trans}<br>";
	##		}
	##		#$varinfo{column_name}=$m_mas[0];

}
	
	
	
sub get_link
{
	my $url="http://fermer.ru/gazeta?page=";
	for my $iu (60..683)
	{
		my $url2=$url.$iu;
		print "ss";
		my ($fol8,$hhs8) = &get_query($varinfo{dbh},"INSERT INTO `page_and_catalog` (`url`,`flag_downloads`,`flag_use`) values ('".$url2."','0','0')","ins","pr");


	}
	print "Dobavleni ssilki ===================================";
}



exit;
1;