﻿#!/usr/bin/perl
# 
#!/usr/bin/perl
# 

#################################################################################
# Perl :: 					#
# ============================================================================= #
#################################################################################

use CGI qw ( :standart);
use CGI::Carp qw ( fatalsToBrowser );  



require HTML::Parser;
 require HTML::TokeParser;
 use Encode;
# use warnings;

require "../lib/def.pl";
require "../lib/parse_lib.pl";
	my %varinfo;
	$varinfo{dbh}=condb("localhost","0000","root","280286","sh_downloads_zol");
print "Content-Type: text/html; charset=utf-8\n\n";

	#&one_run(\%varinfo,'test stroka');
	#exit;
 
 ($id,$proc,$rr,$tt)= &dic_region_seach_str_in_table(\%varinfo,'Московская обл, Москва');
	my ($fol,$hhs) = &get_query($varinfo{dbh},"	SELECT * FROM `dic_region` where `id` = '$id' and 1 order by `id` desc limit 0,100;","hash","pr");
			&view_table1($hhs);
	
	


sub one_run
{
	my $varn=$_[0];
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT `d`.`id` as `id`, `d`.`name` as `name`,`d`.`socr` as `socr`, `dr`.`name` as `parent_name`, `dr`.`socr` as `parent_socr` FROM `dic_region` `d`
left join `dic_region` `dr` on `d`.`parent_id` = `dr`.`id` where 1 limit 0,1000000;","hash",'pr');


#	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT `d`.`id` as `id`, `d`.`name` as `name`, `dr`.`name` as `parent_name` FROM `dic_region` `d`
#left join `dic_region` `dr` on `d`.`parent_id` = `dr`.`id` where `d`.`parent_id` is not NULL and `d`.`name_full_adres` is NULL;","hash",'pr');
	
#	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT `d`.`id` as `id`, `d`.`name` as `name`, `dr`.`name` as `parent_name`, `dr2`.`name` as `parent_name2` FROM `dic_region` `d`
#left join `dic_region` `dr` on `d`.`parent_id` = `dr`.`id` 
#left join `dic_region` `dr2` on `dr`.parent_id` = `dr2`.`id` where `d`.`parent_id` is not NULL and `d`.`name_full_adres` is NULL;","hash",'pr');
	#&view_table1($hhs32);
	for my $col(0..$fol32)
	{
		#$$hhs32[$col]{id};
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"UPDATE `dic_region` SET `name_full_adres`='$$hhs32[$col]{parent_name} $$hhs32[$col]{parent_socr} $$hhs32[$col]{name} $$hhs32[$col]{socr}' where `id` = '$$hhs32[$col]{id}'","ins","do");
			
	}
	print "vse ok"

}


sub dic_region_seach_str_in_table
{
	my $varn=$_[0];
	#my $my_str1=get_name_translit($_[1]);
	my $my_str1=$_[1];
	my $table = $_[2];
	my $proc;
	my %hash_word=();
	my %hash_count_ves=();
		
		#obrabaticam vhod stroku
		$my_str1 =~ s/область/обл/g;
		$my_str1 =~ s/\,//g;
		$my_str1 =~ s/\ /_/g;
		
		
		&delete_all_keys_dic_region($varn);
		
	#	print "SELECT * FROM `dic_region_seach_table_results` where `str_seach` = '".$my_str1."' order by `proc` desc limit 0,1;";
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `dic_region_seach_table_results` where `str_seach` = '".$my_str1."' order by `proc` desc limit 0,1;","hash",'pr');
	if ($fol32 > 0) {$id_model=$$hhs32[0]{id_table}; $proc=$$hhs32[0]{proc};}
	else
	{
		my @mas_vrem2 = split(/_/,$my_str1);
		$my_str1 =~ s/\_/ /g;
		my @mas_vrem3;
		for (@mas_vrem2) {push (@mas_vrem3, $_) if length($_)>0; }
		push (@mas_vrem2, $my_str1);
		my $iu;
			for ($iu=0;$iu<$#mas_vrem3-1;$iu++) {if ($mas_vrem3[$iu] ne '')  {push (@mas_vrem2, $mas_vrem3[$iu]." ".$mas_vrem3[$iu+1]);}}
			for (@mas_vrem2) {$hash_word{"$_"}=$_ if length($_)>0; }
			@mas_vrem2=();
			
			#ПОЛУЧАЕМ ВЕС СЛОВ
			get_word_count_dic_region($varn,\%hash_word);
			for (keys %hash_word)
			{
				#print "$hash_word{$_} $_ \n";
				if ($hash_word{$_} > 0.1) {
							my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT `id`,`level` FROM `dic_region` where `name_full_adres` like '%".$_."%';","hash",'pr');
							#add_massive(\%hash_count_ves,$hhs32,$fol32,$hash_word{$_});
							#print "$_ < $hash_word{$_} >";
							my $iu;
					for ($iu=0;$iu<$fol32;$iu++) 
					{
						my $sub_var43=$$hhs32[$iu]{id};
						$hash_count_ves{$sub_var43}=$hash_count_ves{$sub_var43}+$hash_word{$_};
						$hash_count_region_level{$sub_var43}=$$hhs32[$iu]{level};
						#print "<< $sub_var43 $hash_count_ves{$sub_var43} $iu>> ";
					}	
				
				}
			
			}
			 ($id_model,$proc)=get_max_element_in_massive2_dic_region(\%hash_count_ves,\%hash_count_region_level);
			my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT into `dic_region_seach_table_results` (`str_seach`, `id_table`,`proc`,`datetime_add`) values ('".$my_str1."','".$id_model."','".$proc."', CURRENT_TIMESTAMP);","ins","pr");

	}
		
	return ($id_model,$proc,\%hash_word,\%hash_count_ves);
}

 sub get_max_element_in_massive2_dic_region
{
	#procedura ustanovki katalogov
	#Obshaya peremennaya
	my $hash_word_val=$_[0];
	my $hash_count_region_level==$_[1];
	my $max_value=0;
	my $id_max=0;
		for (keys %$hash_word_val)
		{
			
			$$hash_word_val{$_}=$$hash_word_val{$_}*(1+(20/($hash_count_region_level{$_}+1)/100));
			if ($$hash_word_val{$_} > $max_value) {$max_value=$$hash_word_val{$_};$id_max=$_;}
			#print "<br>".$_." ".$$hash_word_val{$_}."<br>";
		
		}
	#print $max_value;		
	return $id_max,$max_value;
}
	sub delete_all_keys_dic_region
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];

my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"delete FROM `dic_region_word_key`;","ins",'pr');
my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"delete FROM `dic_region_seach_table_results`;","ins",'pr');
				

}

	sub get_word_count_dic_region
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];
my $hash_word_val=$_[1];
my $min_value=10000;
my $sum_var=0;
my $new_sum_var=0;
	
	
	
		for (keys %$hash_word_val)
			{
				my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `dic_region_word_key` where `word` = '".$_."' limit 0,1;","hash",'pr');
					if ($fol32 > 0) {$$hash_word_val{$_}=$$hhs32[0]{cost}}
					else
					{
						my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT count(id) as `cost` FROM `dic_region` where `name_full_adres` like '%".$_."%' limit 0,1;","hash",'pr');
						#print "SELECT count(id_model) as `cost` FROM `parse_prise_catalog` where `model_name` like '%".$_."%' or `catalog` like '%".$_."%' limit 0,1;";
						$$hash_word_val{$_}=$$hhs32[0]{cost};
						print $$hhs32[0]{cost}."++++++++++++++++++++++++++++++++";
						my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT into `dic_region_word_key` (`word`, `cost`,`datetime_add`) values ('".$_."','".$$hhs32[0]{cost}."',CURRENT_TIMESTAMP);","ins","pr");

					}
					if (($$hash_word_val{$_} < $min_value) and ($$hash_word_val{$_} > 0)) {$min_value=$$hash_word_val{$_};}
				#print "$$hash_word_val{$_} - < $_ >";
				$sum_var=$sum_var+$$hash_word_val{$_};
			}
		if ($sum_var > 0) {
		
			for (keys %$hash_word_val)
			{
				if ($$hash_word_val{$_} > 0) {
					$$hash_word_val{$_}= $sum_var/$$hash_word_val{$_};
					$new_sum_var=$new_sum_var+$$hash_word_val{$_};
					#$$hash_word_val{$_}= $$hash_word_val{$_}/($sum_var/100);
					#print "$$hash_word_val{$_} - < $_ >";
					}
			}
				if ($min_value > 1) {$new_sum_var=$new_sum_var+($new_sum_var/100*$min_value);}
			for (keys %$hash_word_val)
			{	
				if ($$hash_word_val{$_} > 0) {
					$$hash_word_val{$_}= $$hash_word_val{$_}/($new_sum_var/100);
					#print "$$hash_word_val{$_} - < $_ >";
					}
			}		
		}
		
		#print "<br><br>";
		#return %hash_word;	
			
}


print "All oc";