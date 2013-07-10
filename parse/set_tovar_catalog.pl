#!/usr/bin/perl

print "Content-type: text/html\n\n";
require HTML::Parser;
 require HTML::TokeParser;
 use Encode;
# use warnings;

require "../lib/def.pl";
require "../lib/parse_lib.pl";



my %varinfo;  
#$varinfo{dbh}=condb("192.168.126.5","0000","root","280286","grabber");
#$varinfo1{dbh}=condb("192.168.126.4","0000","root","280286","grabber");
	$varinfo{dbh}=condb("192.168.126.4","0000","root","280286","grabber");

	
$parametr=1;

while ($parametr > 0) {	
my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `id`,`text`,`url` FROM cash where (`url` like 'http://market.yandex.ru/model.xml?hid%' or `url` like 'http://market.yandex.ru/model.xml?modelid%') and `dounload` =1 and `status`=0 and `id` > 328140 limit 16,10000;","hash","pr");
#my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT `id`,`text`,`url` FROM cash where `id` = '51285' limit 0,1","hash","pr");

for my $col(0..$fol-1){ 
		$varinfo{url} = $$hhs[$col]{url};
		$varinfo{id} = $$hhs[$col]{id};
		
		$varinfo{res_html} = $$hhs[$col]{'text'}; 
		#	print parse_page_link(\%varinfo);
	print "<br><br>Next";

	if ((length($varinfo{res_html}) > 50) and (index($varinfo{res_html}, 'DansGuardian')) < 0){
		
		parse_page_yandex(\%varinfo);

		print "Obrabotana model".$varinfo{model_name}."\n";
		if ((length($varinfo{column_hash}{model_name}) <=254)and (length($varinfo{column_hash}{model_name}) > 0)){
		set_column(\%varinfo);
		
		set_catalog(\%varinfo);
		save_model_to_base(\%varinfo);
		#exit;
			my ($fol8,$hhs8) = &get_query($varinfo{dbh},"UPDATE `cash` SET `status`=1,`model_name`=\'".$col_hash{model_name}."\' where `id` = \'".$varinfo{id}."\' limit 1","ins","pr");
		}
		else
		{
			my ($fol8,$hhs8) = &get_query($varinfo{dbh},"UPDATE `cash` SET `status`=2 where `id` = \'".$varinfo{id}."\' limit 1","ins","pr");
		}
	}
	#else {my ($fol8,$hhs8) = &get_query($varinfo{dbh},"UPDATE `cash` SET `status`=0 where `id` = \'".$$hhs[$col]{'id'}."\' limit 1","ins","pr");
}
if ($fol == 0) {print "Ozhidaem, Net zapisei $fol";sleep(100);}
#exit;
}

sub parse_page_yandex 
{
my $varn=$_[0];
my $text;

		my $tex_ish='';
		my @catalg_list=();
		my @image_list=();
		my @col_list=();
		my %col_hash = ();
		my %col_hash_group = ();
		my %col_hash_position = ();
		$text=$text."Obrabotka zapisi ".$$varn{id}."\n";
		$tex_ish =$$varn{res_html};

		my $kon_var = index($tex_ish, 'Сообщить об ошибке в описании');
		if ($kon_var > 0) {$tex_ish =substr($tex_ish,0,$kon_var)}

		$p = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour

		#while (my $token = $p->get_tag("img")) {
		#	my $url1 = $token->[1]{src} || "-";
		#	$pos=index($url1, 'http://mdata.yandex.net/i?path=');
		#	if (!$pos){ #print "$pos - $url1\t$1text\n <br>";
		#		push(@image_list,$url1);
		#	}	
		#}	
		
		#Poluchaem imena katalogov
  
		$p = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour		
		while (my $token = $p->get_tag("a")) {
			my $url1 = $token->[1]{href} || "-";

			my $text = $p->get_trimmed_text("/a");
						$pos=index($url1, 'http://mdata.yandex.net/i?path=');
			if (!$pos){ #print "$pos - $url1\t$1text\n <br>";
				push(@image_list,$url1);
			}	
			
			
			$pos0=index($text, 'Эта модель на');
			# print "+++===++++ $text <br>";
			if (!$pos0){  print "+++===++++ $text <br>";	
					$col_hash{url_site}=$url1;
				}
		
			$pos=index($url1, '/catalog.xml?hid=');
			if (!$pos){  #print "$pos - $url1\t$text\n <br>";	
					unshift(@catalg_list,$text);
					$col_hash{catalog}=get_name_translit($text);
				}

		}
		$$varn{image_list}=\@image_list;
		$$varn{catalog_list}=\@catalg_list;

		$p = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour		
		while (my $token = $p->get_tag("h1")) {
			#my $url1 = $token->[1]{href} || "-";

			my $text = $p->get_trimmed_text("/h1");
			$col_hash{model_name}=$text;
			$$varn{model_name}=$text;
			#print "=-------= $text";
		}
  
		#print "==",index($tex_ish, 'все характеристики'),"==";


		$tex_ish =~ s/\<\/span\>\<\/td\>\<td\>/+/g;
		my $var_index =index($tex_ish, 'Основные характеристики');
		if ($var_index < 0) {
		#$var_index =index($tex_ish, 'все характеристики');
		$var_index =index($tex_ish, '<colgroup span="2"></colgroup><tbody><tr><td colspan="2" class="title">');
		$text=$text.$var_index."____"
		}
		$tex_ish1 =substr($tex_ish,$var_index);

		


		$p = HTML::TokeParser->new(\$tex_ish1) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour	

		my $kat_group = "Основные характеристики"; 
		my $count_posit=0;
		my $count_har=1;
		while (my $token = $p->get_tag("tr")) {
			my $url1 = $token->[1]{href} || "-";
			my $text = $p->get_trimmed_text("/tr");
			my @m_mas = split(/\+/,$text);

			if ((length($m_mas[0]) > 3) and (length($m_mas[1]) <= 0) and (length($m_mas[0]) <= 255)) {
				$kat_group=$m_mas[0];
				$count_posit=$count_har*100;
				#print "22".length($m_mas[1])."";
				$count_har++;
			}
			#if (length($m_mas[0]) > 3) {
			#print "=Х= $m_mas[0] =P=  $m_mas[1]  - $kat_group $count_posit<br>";
			#}
			if ((length($m_mas[1]) > 0) and (length($m_mas[0]) > 0)) {
				$count_posit++;
			if (length($m_mas[0]) >254) {$m_mas[0]='no';print "ddd";}	
			
				my $n_trans=get_name_translit($m_mas[0]);
				push(@col_list,$m_mas[0]);
				$col_hash{$n_trans}=$m_mas[1];
				$col_hash_group{$n_trans}=$kat_group if not exists $col_hash_group{$n_trans};

				$col_hash_position{$n_trans}=$count_posit if not exists $col_hash_position{$n_trans};
				#print "=Х= $n_trans =X= $m_mas[0] =P=  $col_hash{$n_trans}  GROUP: $col_hash_group{$n_trans} POS: $col_hash_position{$n_trans}<br>";
			}
			#$varinfo{column_name}=$m_mas[0];

		}
		
		$$varn{column_list}=\@col_list;
		$$varn{column_hash}=\%col_hash;
		$$varn{col_hash_group}=\%col_hash_group;
		$$varn{col_hash_position}=\%col_hash_position;
	return $text;

}



sub save_model_to_base
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];
my $column_hash = $$varn{column_hash};
my $image_list = $$varn{image_list};
my $hash_field_list =get_field_column($varn);
my ($temp_var,$temp_var2,$count_img);
$temp_var = "(";
$temp_var2 = "(";
$count_img=1;
foreach (@{$image_list}){
$temp_var = $temp_var." `img".$count_img."`, ";
$temp_var2 = $temp_var2." \'".$_."\', ";
$count_img++;
}
$$column_hash{model_name}=substr($$column_hash{model_name},0,254);
for (keys %$column_hash){
	if (length($$column_hash{$_}) > 0){
	#if (length($$column_hash{$_}) > 255) {print "dlina dannih bolee 255";exit;} 
	$temp_var = $temp_var." `".$$hash_field_list{$_}."`, ";
	$temp_var2 = $temp_var2." \'".addslashes($$column_hash{$_})."\', ";
	#$temp_var2 = $temp_var2." \'".substr($$column_hash{$_},0,255)."\', ";
	#print "$_ -- $$column_hash{$_} = $$hash_field_list{$_} =".length($$column_hash{$_})."<br>\n";
	}
}
$temp_var = $temp_var." `status`) ";
$temp_var2 = $temp_var2." \'0\') ";
	my ($fol7,$hhs7) = &get_query($varinfo{dbh},"SELECT * FROM catalog where `model_name`= \'".$$column_hash{model_name}."\' LIMIT 0,1","hash","pr");
	if ($fol7 == 0) 
		{
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"}," INSERT INTO `catalog` $temp_var values $temp_var2","ins","do");
		#print "INSERT INTO `catalog` $temp_var values $temp_var2";
		}
		else {
		print "Takoi tovar est v kataloge";
		}

}

sub set_catalog
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];
#razimiovivaem massiv catalogov
my $cat_list = $$varn{catalog_list};

if (length($$cat_list[0]) > 0) 
	{
	#print "SELECT `id` FROM catalog_list where `name_catalog_translit` = '".get_name_translit($$cat_list[0])."'";
	my ($fol2,$hhs2) = &get_query($$varn{"dbh"},"SELECT `id` FROM catalog_list where `name_catalog_translit` = '".get_name_translit($$cat_list[0])."'","hash","pr");
	#print $fol2,get_name_translit($$varn{column_name});
	#print " ++$fol2 $$cat_list[0] --";
		if ($fol2 == 0)
		{
		#print "INSERT INTO `catalog_list` (name_ru, name_catalog_translit, name_parant_ru_translit) VALUES ('".$$cat_list[0]."','".get_name_translit($$cat_list[0])."','".get_name_translit($$cat_list[1])."')";
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"INSERT INTO `catalog_list` (name_ru, name_catalog_translit, name_parant_ru_translit) VALUES ('".$$cat_list[0]."','".get_name_translit($$cat_list[0])."','".get_name_translit($$cat_list[1])."')","ins","do");
		}
	shift (@{$cat_list}); 	
	}
if (length($$cat_list[0]) > 0) 
	{	
	set_catalog($varn);
}


}


sub set_column
{
#procedura ustanovki stolbcov tablich
#Obshaya peremennaya
my $varn=$_[0];
my $count=$_[1];

$count=$count+1-1;
#razimiovivaem massiv catalogov
my $cat_list = $$varn{catalog_list};

#raziminovivaem massiv stolbcov
my $column_list = $$varn{column_list};
my $column_hash = $$varn{column_hash};


#$varinfo{col_hash_group}=\%col_hash_group;
#$varinfo{col_hash_position}=\%col_hash_position;

my $count_field;
#poluchaem translit cataloga tovara
my $translit_text_catalog =get_name_translit($$column_hash{catalog});

if (length($$column_list[$count]) > 0) 
	{
	#poluchaem v translite imya stolbcha
	my $translit_text =get_name_translit($$column_list[$count]);
	#print "<br>Stolbec: ". $$column_list[$count]." Группа:".$$varn{col_hash_group}{$translit_text}." Pos:".$$varn{col_hash_position}{$translit_text}."<br><br>";
	

	my ($fol4,$hhs2) = &get_query($$varn{"dbh"},"select `id` FROM `catalog_column` where `name_column_translit` = \'".$translit_text."\' and `name_catalog_translit` = \'".$translit_text_catalog."\'","hash","pr");
		if ($fol4 == 0) 
		{
			my ($fol22,$hhs22) = &get_query($$varn{"dbh"},"select count(`id`) as ccaa FROM `catalog_column` where `name_catalog_translit` = \'".$translit_text_catalog."\'","hash","pr");
			$count_field=$$hhs22[0]{'ccaa'}+1;
			if ($count_field > 104) {print "Pri dobavlenii stolbcha slishkom Bolshoe kolichestvo polei";exit;}
			my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"		INSERT INTO `catalog_column` (name_column_translit, name_column_ru, name_catalog_translit, name_field_column,group_name,posledovatelnost) VALUES ('".$translit_text."','".$$column_list[$count]."','".$translit_text_catalog."', 'inf".$count_field."','".$$varn{col_hash_group}{$translit_text}."','".$$varn{col_hash_position}{$translit_text}."')","ins","do");
		}
		set_column($varn,$count+1);	
	}

	#if (length($$column_list[0]) > 0) 
	#	{
	#	
	#	}		

}

sub get_field_column
    { 
#procedura polucenie imen v stolbchah bd catalog
#Obshaya peremennaya
my $varn=$_[0];
#raziminovivaem massiv stolbcov
my $column_hash = $$varn{column_hash};
my ($iu,%hash);
#poluchaem translit cataloga tovara
my $translit_text_catalog =get_name_translit($$column_hash{catalog});
$hash{model_name}='model_name';
$hash{catalog}='catalog';
$hash{url_site}='url_site';

my ($fol21,$hhs21) = &get_query($$varn{"dbh"},"SELECT name_field_column, name_column_translit FROM `catalog_column` where `name_catalog_translit` = \'".$translit_text_catalog."\'","hash","pr");
	if ($fol21 > 0)
	{
		for ($iu=0;$iu<$fol21;$iu++) {
		#print $$hhs21[$iu]{'name_column_translit'}."--++// $$hhs21[$iu]{'name_field_column'} ---";
		$hash{$$hhs21[$iu]{'name_column_translit'}}=$$hhs21[$iu]{'name_field_column'};
		}
	
	}

return \%hash;
}


