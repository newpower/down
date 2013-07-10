#!/usr/bin/perl

print "Content-type: text/html\n\n";
require HTML::Parser;
 require HTML::TokeParser;
 use Encode;
# use warnings;

require "../lib/def.pl";
require "../lib/parse_lib.pl";



my %varinfo;  

			
	$varinfo{dbh}=condb("localhost","0000","root","280286","sh_downloads");
	
	
	
	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `id`,`text`,`url` FROM t_page where `flag_downloads` =1 and `flag_use`='0' and `id` > 0 limit 0,50;","hash","pr");

	for my $col(0..$fol-1){
		$varinfo{url} = $$hhs[$col]{url};
		$varinfo{id} = $$hhs[$col]{id};
		$varinfo{res_html} = $$hhs[$col]{text}; 
		$varinfo{res_html} = Encode::decode('cp1251', $varinfo{res_html});
		#$varinfo{res_html} = Encode::encode('utf8', $varinfo{res_html});
		
		
		&parse_company(\%varinfo);
	
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
				
			
				
				
				if ($m_mas[0] eq 'ИНН/КПП')	{$hash_rekvisit{'inn-kpp'}=$m_mas[1];}
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


		if (($fol7 == 0) and ($hash_rekvisit{'name'} ne '')) 
		{
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"}," INSERT INTO `t_catalog` ($str_per1) values ($str_per2)","ins","do");
			#print "INSERT INTO `t_catalog` ($str_per1) values ($str_per2)";
			print "Добавле нвый контрагент  ****  ****- $hash_rekvisit{'inn-kpp'} $hash_rekvisit{'e-mail'} $hash_rekvisit{'name'} $tex_ish2 **\n";
				
		}
	#	my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `t_page` SET `flag_use`='1' where `id` = '$$varn{id}'","ins","do");
		print "vse ok $$varn{id} flag_use=1\ n";

				
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
	##		#print "=�= $m_mas[0] =P=  $m_mas[1]  - $kat_group $count_posit<br>";
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
	##			#print "=�= $n_trans =X= $m_mas[0] =P=  $col_hash{$n_trans}  GROUP: $col_hash_group{$n_trans} POS: $col_hash_position{$n_trans}<br>";
	##		}
	##		#$varinfo{column_name}=$m_mas[0];

}
	
	
	
sub get_link
{
	my $url="http://www.zernotrader.ru/modules/companies/?page=0&id=";
	for my $iu (0..3700)
	{
		my $url2=$url.$iu;
	
		my ($fol8,$hhs8) = &get_query($varinfo{dbh},"INSERT INTO `t_page` (`url`,`flag_downloads`,`flag_use`) values ('".$url2."','0','0')","ins","pr");


	}
	print "Dobavleni ssilki ===================================";
}



exit;
1;