
use URI;	
#################################################################################

#poluchaem ssilki so stranich dlya yandex
sub get_image_size {
#$$varn{var_sdv} sdvig
#$$varn{res_html} image
#use Image::Magick;
	my $varn=$_[0];
	open(FFF,"> file".$$varn{var_sdv}.".jpeg");
	 binmode FFF;
	print (FFF $$varn{res_html});
	close(FFF);
	
	my	($sw, $sh,$nw,$nh,$q,$x,$in);
	$in =200;
	 $q = Image::Magick->new;
		$x = $q->Read("file".$$varn{var_sdv}.".jpeg");
	#	$q->Set(quality=>75);
		#Получаем размеры картинки
	
	   ($sw, $sh) = $q->Get('width', 'height');
	      if ($sw == 0){       $sw = 1;    }
	      if ($sh == 0){       $sh = 1;    }
	$nw=$in;
    $nh = $nw*$sh/$sw;
	if ($nh > $in){
	$nh = $in;
	$nw = $sw*$nh/$sh;
	}
	
    if ($nw == 0){
       $nw = 1;
    }
	 if ($nh == 0){
       $nh = 1;
    }
	$x = $q->Scale(width=>($nw), height=>($nh)); 
	$x = $q->Write("file2".$$varn{var_sdv}.".jpeg");
	
	
	$in =50;
	 $q = Image::Magick->new;
		$x = $q->Read("file".$$varn{var_sdv}.".jpeg");
	#	$q->Set(quality=>75);
		#Получаем размеры картинки
	
	   ($sw, $sh) = $q->Get('width', 'height');
	   
	      if ($sw == 0){       $sw = 1;    }
	      if ($sh == 0){       $sh = 1;    }
	$nw=$in;
    $nh = $nw*$sh/$sw;
	if ($nh > $in){
	$nh = $in;
	$nw = $sw*$nh/$sh;
	}
	
    if ($nw == 0){
       $nw = 1;
    }
	 if ($nh == 0){
       $nh = 1;
    }
	$x = $q->Scale(width=>($nw), height=>($nh)); 
	$x = $q->Write("file3".$$varn{var_sdv}.".jpeg");
	
	my $str='';
	open(FFF,"< file".$$varn{var_sdv}.".jpeg");
	binmode FFF;
	while (<FFF>)
	{
	$str=$str.$_;
	}
	close(FFF);
	unlink ("file".$$varn{var_sdv}.".jpeg");
	
		my $str2='';
	open(FFF2,"< file2".$$varn{var_sdv}.".jpeg");
	binmode FFF2;
	while (<FFF2>)
	{
	$str2=$str2.$_;
	}
	close(FFF2);
	unlink ("file2".$$varn{var_sdv}.".jpeg");
	
			my $str3='';
	open(FFF3,"< file3".$$varn{var_sdv}.".jpeg");
	binmode FFF3;
	while (<FFF3>)
	{
	$str3=$str3.$_;
	}
	close(FFF3);
	unlink ("file3".$$varn{var_sdv}.".jpeg");
	
	
	return $str,$str2,$str3;
	
}

#poluchaem ssilki so stranich dlya yandex
sub parse_page_link {
	my $varn=$_[0];
	my $html=$$varn{res_html};
	print "Obrabotka $$varn{id}<br> \n";
	if ((length($html) > 100)  and (index($html, 'DansGuardian') < 0))  {
		print "ADD DLINA:".length($html)." Rek_proxy: ".index($html, 'DansGuardian')."\n";
		my $count_add=0;	
		my $count_add1=0;		
				
		$p = HTML::TokeParser->new(\$html) || die "Can't open: $!";
		$p->empty_element_tags(1);  # configure its behaviour		
			  while (my $token = $p->get_tag("a")) {
			my $url1 = $token->[1]{href} || "-";

     			my $text = $p->get_trimmed_text("/a");
			# print "$pos - $url1\t$text\n <br>";
			my $pos=index($url1, 'http');
			my $pos2=index($url1, 'catalog');
			my $pos3=index($url1, 'guru');
			my $pos4=index($url1, 'model.');

				if (($pos < 0) and (($pos2 > 0) or ($pos3 > 0) )) {  
					#print "$pos - http://market.yandex.ru\/$url1\t$text\n <br>";
					$url1="http://market.yandex.ru/$url1";
					$url1 =~ s/ru\/\.\//ru\//g;
					$url1 =~ s/ru\/\//ru\//g;
				

					my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `url` FROM `cash` where `url` = \'$url1\' limit 0,1","hash","pr");
					if ($fol ==0)  {my ($fol5,$hhs5) = &get_query($$varn{dbh},"INSERT into `cash` (`url`, `dounload`, `link`) values (\'$url1\',0,'$text');","ins","pr");
						$count_add++;
						}

				}

				elsif ($pos4 > 0) {
					if ($pos < 0) {
						$url1 = "http://market.yandex.ru/$url1";	
					}
					else
					{
						
						my @spp=  split('\*', $url1);
						#print "---".$spp[1]."++++ $url1";
						$url1 = $spp[1];	
					}				

					$url1 =~ s/ru\/\.\//ru\//g;
					$url1 =~ s/ru\/\//ru\//g;

					my ($fol,$hhs) = &get_query($$varn{dbh},"SELECT `url` FROM `cash` where `url` = \'$url1\' limit 0,1","hash","pr");
					if ($fol ==0)  {
								my ($fol,$hhs) = &get_query($$varn{dbh},"INSERT into `cash` (`url`, `dounload`, `link`) values (\'$url1\',0,'$text');","ins","pr");
								$count_add1++;
						}

		

				}
		}
  
		return "Dobvleno catalogov: $count_add tovatnis str: $count_add1 \n\n";
	}
	else
	{
		my ($fol2,$hhs2) = &get_query($$varn{dbh},"UPDATE `cash` SET `dounload`=0 where `id` = \'".$$varn{id}."\' limit 1;","ins","pr");
		print "v 0.1 Oshibka ID: $$varn{id} DLINA:".length($html)." Rek_proxy: ".index($html, 'DansGuardian')." url: $$varn{url} <br>\n";
		
	}
 }
 
 sub get_page
{                 
  use LWP::UserAgent;  
	my $varn=$_[0];
	my $pr=$_[1];	
	my $ua = LWP::UserAgent->new;                        
		$ua->agent("Mozilla/5.0 ");   


		$ua = new LWP::UserAgent; 
		$ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)"); 
		$ua->timeout(15); 

		$ua->proxy(['http'], "http://$pr") if ($pr ne '');
	my $h1 = new HTTP::Headers 
			Accept => 'application/vnd.ms-excel, application/msword, image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-comet, */*', 
			User_Agent => 'Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)', 
			Referer => 'http://market.yandex.ru/'; 
		$$varn{url} =~ s/ru\/\.\//ru\//g;
	my $req1 = new HTTP::Request ('GET',$$varn{url}, $h1); 

my $username = 'feofanov';
my $password = '1';
#$req1->proxy_authorization_basic($username, $password);

   my $response=$ua->request($req1); 
 #  $suc=$response->is_success; 
 # ($suc) || print $response->code; 
return $response;

}
  sub update_catalog_parse
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];
my $mag=$_[1];

my $parametr=1;
my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `parse_prise_catalog`;","ins","pr");
my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `string_key` where `proc` < 100;","ins","pr");
my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `word_key`;","ins","pr");
my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `word_key_brand`;","ins","pr");

print "poluchaem katalog\n";
		my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `catalog`;","hash",'pr');
	print "Ok\n";
		
		my $iu;
				for ($iu=0;$iu<$fol32;$iu++) {
			my @mas_vrem = split(/_/,get_name_translit($$hhs32[$iu]{'model_name'}));
			if (length(get_name_translit($$hhs32[$iu]{'model_name'})) < 255) {
					my $vrem_per =$$hhs32[$iu]{'model_name'};
						$vrem_per =~ s/-/_/g;
						
					my @mas_vrem2 = split(/_/,get_name_translit($vrem_per));
					#$vrem_per='';
					#if (($#mas_vrem2 == 2) and (length($mas_vrem2[1]) >0) and (length($mas_vrem2[1]) <4)) {
					#$vrem_per=$mas_vrem2[0]."_".$mas_vrem2[1].$mas_vrem2[2];
					#}
					
					$vrem_per=get_name_translit($vrem_per);
					$vrem_per =~ s/_//g;
					
					my ($fol3,$hhs3) = &get_query($$varn{dbh2},"INSERT into `parse_prise_catalog` (`id_model`, `model_name`, `brand`, `catalog`, `dop_model_name`) values ('".$$hhs32[$iu]{id}."','".get_name_translit($$hhs32[$iu]{'model_name'})."','".$mas_vrem[0]."','".$$hhs32[$iu]{catalog}."', '".$vrem_per."');","ins","pr");
				}
	
			}
			exit;
	}
			
			

	sub get_word_count
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
				my ($fol32,$hhs32) = &get_query($$varn{"dbh2"},"SELECT * FROM `word_key` where `word` = '".$_."' limit 0,1;","hash",'pr');
					if ($fol32 > 0) {$$hash_word_val{$_}=$$hhs32[0]{cost}}
					else
					{
						my ($fol32,$hhs32) = &get_query($$varn{"dbh2"},"SELECT count(id_model) as `cost` FROM `parse_prise_catalog` where `model_name` like '%".$_."%' or `catalog` like '%".$_."%' or  `dop_model_name` like '%".$_."%' limit 0,1;","hash",'pr');
						#print "SELECT count(id_model) as `cost` FROM `parse_prise_catalog` where `model_name` like '%".$_."%' or `catalog` like '%".$_."%' limit 0,1;";
						$$hash_word_val{$_}=$$hhs32[0]{cost};
						my ($fol3,$hhs3) = &get_query($$varn{dbh2},"INSERT into `word_key` (`word`, `cost`) values ('".$_."','".$$hhs32[0]{cost}."');","ins","pr");

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
		#			$$hash_word_val{$_}= $$hash_word_val{$_}/($sum_var/100);
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
 sub get_max_element_in_massive
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $hash_word_val=$_[0];
my $max_value=0;
my $id_max=0;
			for (keys %$hash_word_val)
			{
				if ($$hash_word_val{$_} > $max_value) {$max_value=$$hash_word_val{$_};$id_max=$_;}
			
			}
#print $max_value;		
return $id_max,$max_value;
}

 sub add_massive
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $hash_count_var=$_[0];
my $hash_count_var2=$_[1];
my $count_strok=$_[2];
my $count_add=$_[3];
my @mas_val1;
my $iu=0;
#print "$count_strok";
			for ($iu=0;$iu<$count_strok;$iu++) 
			{
				$$hash_count_var{$iu}=$$hash_count_var2[$iu]{id_model}+$count_add;
				#print "<< $$hash_count_var{$iu} >> $iu";
			}			
			
			

}

sub seach_model_by_string
{
#procedura ustanovki katalogov
#Obshaya peremennaya
my $varn=$_[0];
my $my_str1=get_name_translit($_[1]);
my $id_model;
my $proc;
		my %hash_word=();
		my %hash_count_ves=();
		
	my ($fol32,$hhs32) = &get_query($$varn{"dbh2"},"SELECT * FROM `string_key` where `string` = '".$my_str1."' order by `proc` desc limit 0,1;","hash",'pr');
	if ($fol32 > 0) {$id_model=$$hhs32[0]{id_model}; $proc=$$hhs32[0]{proc};}
		else
	{


					

		
		my @mas_vrem2 = split(/_/,$my_str1);
		for (@mas_vrem2) {$hash_word{"$_"}=$_ if length($_)>0; }
		@mas_vrem2=();
		
		my  $temp_per= $my_str1;
		$temp_per =~ s/-/_/g;
		if (index($temp_per, 'Samsung') > 0) {
		$temp_per =~ s/XW/_/g;
		$temp_per =~ s/UW/_/g;
		$temp_per =~ s/QW/_/g;
		$temp_per =~ s/SW/_/g;
		}
		
		if (index($temp_per, 'Panasonic') > 0) {
		$temp_per =~ s/WRU/_/g;
		$temp_per =~ s/CSATW/_/g;
		$temp_per =~ s/EE-K/_/g;
		$temp_per =~ s/EE_K/_/g;
		}
		if (index($temp_per, 'Zanussi') > 0) {
		$temp_per =~ s/ZCE/ZCE_/g;
		$temp_per =~ s/ZRD/ZRD_/g;
		$temp_per =~ s/ZCG/ZCG_/g;
		$temp_per =~ s/ZRB/ZRB_/g;
		}
		if (index($temp_per, 'Soni') > 0) {
		$temp_per =~ s/WMR/_/g;

		}
		my @mas_vrem2 = split(/_/,$temp_per);
		my @mas_vrem3;
		for (@mas_vrem2) {push (@mas_vrem3, $_) if length($_)>0; }
		push (@mas_vrem2, $temp_per);
		#my @mas_vrem3 = split(/_/,$temp_per);
		my $iu;
			for ($iu=0;$iu<$#mas_vrem3-1;$iu++) {if ($mas_vrem3[$iu] ne '')  {push (@mas_vrem2, $mas_vrem3[$iu]."_".$mas_vrem3[$iu+1]);}}
			#for ($iu=0;$iu<$#mas_vrem3-2;$iu++) {if ($mas_vrem3[$iu] ne '')  {push (@mas_vrem2, $mas_vrem3[$iu]."_".$mas_vrem3[$iu+1]."_".$mas_vrem3[$iu+2]);}}
		
		for (@mas_vrem2) {$hash_word{"$_"}=$_ if length($_)>0; }
		@mas_vrem2=();
		
			#%hash_word2=get_word_count($varn,\%hash_word);
			get_word_count($varn,\%hash_word);
			for (keys %hash_word)
			{
				#print "$hash_word{$_} $_ \n";
				if ($hash_word{$_} > 0.1) {
							my ($fol32,$hhs32) = &get_query($$varn{"dbh2"},"SELECT `id_model` as `id` FROM `parse_prise_catalog` where `model_name` like '%".$_."%' or `dop_model_name` like '%".$_."%';","hash",'pr');
							#add_massive(\%hash_count_ves,$hhs32,$fol32,$hash_word{$_});
							#print "$_ < $hash_word{$_} >";
							my $iu;
					for ($iu=0;$iu<$fol32;$iu++) 
					{
						my $sub_var43=$$hhs32[$iu]{id};
						$hash_count_ves{$sub_var43}=$hash_count_ves{$sub_var43}+$hash_word{$_};
						#print "<< $sub_var43 $hash_count_ves{$sub_var43} $iu>> ";
					}	
				
				}
			
			}
			 ($id_model,$proc)=get_max_element_in_massive(\%hash_count_ves);
			my ($fol3,$hhs3) = &get_query($$varn{dbh2},"INSERT into `string_key` (`string`, `id_model`,`proc`) values ('".$my_str1."','".$id_model."','".$proc."');","ins","pr");
	
	}	
	return ($id_model,$proc,\%hash_word,\%hash_count_ves);
}

sub parse_price_po_id
{
#procedura ustanovki katalogov
#Obshaya peremennaya
	my $varn=$_[0];
	my $id_price=$_[1];

	my $pole_nomen;
	my $pole_cost;

	my $text;

	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_price` where `id` = '".$id_price."' limit 0,1;","hash",'pr');
	if (($$hhs32[0]{kontragent_ot} eq twin) or ($$hhs32[0]{kontragent_ot} eq '56')) 
	{
		$pole_nomen='pole5';$pole_cost='pole6';
	}
	elsif (($$hhs32[0]{kontragent_ot} eq belteh) or ($$hhs32[0]{kontragent_ot} eq '12')) 
	{
		$pole_nomen='pole1';$pole_cost='pole2';
	}
	elsif ($$hhs32[0]{kontragent_ot} eq '23') 
	{
		$pole_nomen='pole2';$pole_cost='pole3';
	}
	elsif ($$hhs32[0]{kontragent_ot} eq '25') 
	{
		$pole_nomen='pole2';$pole_cost='pole5';
	}	
	elsif ($$hhs32[0]{kontragent_ot} eq '13') 
	{
		$pole_nomen='pole1';$pole_cost='pole3';
	}
	else 
	{
		$pole_nomen='pole5';$pole_cost='pole6';
	}
		if ($fol32 > 0) 
		{
			if (($$hhs32[0]{status} == 0) or ($$varn{form_data}{dop_action} eq 'parse0')) 
			{
				my ($fol31,$hhs31) = &get_query($$varn{dbh},"INSERT INTO `users_history` (`login`, `id_client`, `type_sob`, `IP`, `value`, `value_dop`) VALUES	('".$$data_user{login}."','".$$varn{id_client}."','edit-price','".$ENV{REMOTE_ADDR}."','Status 0 ".$$hhs32[0]{caption}."','".$$hhs32[0]{id}."')","ins","pr");	

				my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `price_in` where `price_id` ='".$id_price."'","ins","pr");
				my ($fol3,$hhs3) = &get_query($$varn{dbh2},"delete from `price_out` where `id_price` ='".$id_price."'","ins","pr");
				open ( UPLOADFILE, "> upload/$$hhs32[0]{caption}" ) or die $text=$text."NO cant create files";  
				binmode UPLOADFILE;  
				print UPLOADFILE $$hhs32[0]{doc_price};
				close UPLOADFILE; 
				
				open ( UPLOADFILE, "< upload/$$hhs32[0]{caption}" ) or die $text=$text."NO read create files";  
				binmode UPLOADFILE;  
				while ( <UPLOADFILE> )  
					{  
						my $vrem_var=$_;
						$vrem_var =~ s/\"//g;
						$vrem_var =~ s/ руб.//g;	
						$vrem_var =~ s/руб.//g;
						if (length($vrem_var) > 1) 
						{
							 $vrem_var=addslashes($vrem_var);
							my @mas_vrem = split(/;/,$vrem_var);
							#print $vrem_var;
							#$text=$text."INSERT into `price_in` (`price_id`, `pole1`, `pole2`, `pole3`, `pole4`, `pole5`, `pole6`, `pole7`, `pole8`, `pole9`) values ('".$$hhs51[0]{id}."' ,'".$mas_vrem[0]."','".$mas_vrem[1]."','".$mas_vrem[2]."','".$mas_vrem[3]."','".$mas_vrem[4]."','".$mas_vrem[5]."','".$mas_vrem[6]."','".$mas_vrem[7]."','".$mas_vrem[8]."');";
							my ($fol5,$hhs5) = &get_query($$varn{dbh2},"INSERT into `price_in` (`price_id`, `pole1`, `pole2`, `pole3`, `pole4`, `pole5`, `pole6`, `pole7`, `pole8`, `pole9`) values ('".$id_price."' ,'".$mas_vrem[0]."','".$mas_vrem[1]."','".$mas_vrem[2]."','".$mas_vrem[3]."','".$mas_vrem[4]."','".$mas_vrem[5]."','".$mas_vrem[6]."','".$mas_vrem[7]."','".$mas_vrem[8]."');","ins","pr");
						}
					}  
                       
				close UPLOADFILE; 
				my ($fol3,$hhs3) = &get_query($$varn{dbh},"update `contragent_price` set `status`='1' where `id` ='".$id_price."' limit 1;","ins","pr");
				$$varn{form_data}{dop_action}='';
				return parse_price_po_id($varn,$id_price);
			}
			elsif ($$hhs32[0]{status} == 1) 
			{
				my ($fol3,$hhs3) = &get_query($$varn{"dbh2"},"SELECT * FROM parse.price_in where `price_id`= '".$id_price."' and `id_price_out` is null;","hash",'pr');
			
				my $iu,$iu1;
				for ($iu=0;$iu<$fol3;$iu++) 
				{

					##	my %hash_var;
					##		for ($iu1=1;$iu1<10;$iu1++) {
					##			my $t_var="pole".$iu1;
					##			my ($idmax,$proc) =seach_model_by_string($varn,$$hhs3[0]{$t_var});
					##				$hash_var{$t_var}=$proc;
					##			}
					if ((length($$hhs3[$iu]{$pole_cost}) > 0 ) and ($$hhs3[$iu]{$pole_cost} > 0 ) and (length($$hhs3[$iu]{$pole_nomen}) > 0)) 
					{
						my ($idmax,$proc) =seach_model_by_string($varn,$$hhs3[$iu]{$pole_nomen});
						$proc = sprintf("%.2f", $proc);
	
						my ($fol34,$hhs34) = &get_query($$varn{dbh2},"INSERT into `price_out` (`id_price_in`,`id_price`, `cost`, `id_catalog`, `proc_shod`, `count`) values ('".$$hhs3[$iu]{id}."','".$id_price."','".$$hhs3[$iu]{$pole_cost}."','".$idmax."','".$proc."','1');","ins","pr");
						my ($fol34,$hhs34) = &get_query($$varn{"dbh2"},"SELECT * FROM `price_out` where `id_price`= '".$id_price."' and `cost`='".$$hhs3[$iu]{$pole_cost}."' and `id_catalog` = '".$idmax."' and `proc_shod` LIKE '".$proc."';","hash",'pr');
						
	
						#print "<br>$$hhs34[0]{id} $$hhs3[$iu]{id}<br>BB $proc /<a href=http://t61.ru/tovr-001-".$idmax.".html> $idmax</a> - $mas_vrem[4]<br>";
						if ($$hhs34[0]{id} eq '') {$$hhs34[0]{id}=0;}
						my ($fol33,$hhs33) = &get_query($$varn{dbh2},"update `price_in` set `id_price_out`='".$$hhs34[0]{id}."' where `id` ='".$$hhs3[$iu]{id}."';","ins","pr");
					}
				}
				my ($fol3,$hhs3) = &get_query($$varn{dbh},"update `contragent_price` set `status`='2' where `id` ='".$id_price."' limit 1;","ins","pr");
				return parse_price_po_id($varn,$id_price);
			}
			elsif (($$hhs32[0]{status} == 2) and ($$varn{form_data}{dop_action} eq 'end_parse_price')) 
			{
				my ($fol31,$hhs31) = &get_query($$varn{dbh},"INSERT INTO `users_history` (`login`, `id_client`, `type_sob`, `IP`, `value`, `value_dop`) VALUES	('".$$data_user{login}."','".$$varn{id_client}."','edit-price','".$ENV{REMOTE_ADDR}."','Status 3 (end) ".$$hhs32[0]{caption}."','".$$hhs32[0]{id}."')","ins","pr");	

				my ($fol3,$hhs3) = &get_query($$varn{dbh},"delete from `contragent_price_table` where `price_id` ='".$id_price."'","ins","pr");
				my ($fol3,$hhs3) = &get_query($$varn{"dbh2"},"SELECT *,`po`.`id` as `ids`  FROM price_out as po left join price_in as pi ON `pi`.`id` = `po`.`id_price_in` left join parse_prise_catalog as pp ON `pp`.`id_model` = `po`.`id_catalog` where `pi`.`price_id`= '".$id_price."' order by `id_model`,`proc_shod`;","hash",'pr');
				
				my $iu;
				for ($iu=0;$iu<$fol3;$iu++) 
				{
					my $link=$$hhs3[$iu]{ids};
					if ($$varn{form_data}{$link} == 1)
					{
						my ($fol5,$hhs5) = &get_query($$varn{dbh},"INSERT into `contragent_price_table` (`model_id`, `cost`, `count`, `price_id`, `name_model_prise`, `artikul_prise`) values ('".$$hhs3[$iu]{id_catalog}."' ,'".$$hhs3[$iu]{cost}."','".$$hhs3[$iu]{count}."','".$id_price."','".$$hhs3[$iu]{$pole_nomen}."','".$$hhs3[$iu]{count}."');","ins","pr");

					} 
				}
				my ($fol3,$hhs3) = &get_query($$varn{dbh},"update `contragent_price` set `status`='3' where `id` ='".$id_price."' limit 1;","ins","pr");

				return parse_price_po_id($varn,$id_price);
			}
			elsif ($$hhs32[0]{status} == 2) 
			{
				my ($fol38,$hhs38) = &get_query($$varn{"dbh2"},"SELECT count(id_catalog) as `count`,id_catalog FROM price_out where `id_price`='".$id_price."' group by `id_catalog` order by `id`;","hash",'pr');
				my ($iu,$iu1);
				my %hash_zadvoen;
				for ($iu=0;$iu<$fol38;$iu++) { if ($$hhs38[$iu]{count} > 1) {$hash_zadvoen{"$$hhs38[$iu]{id_catalog}"}=$$hhs38[$iu]{count};}}
				
				my ($fol3,$hhs3) = &get_query($$varn{"dbh2"},"SELECT *,`po`.`id` as `ids`  FROM price_out as po left join price_in as pi ON `pi`.`id` = `po`.`id_price_in` left join parse_prise_catalog as pp ON `pp`.`id_model` = `po`.`id_catalog` where `pi`.`price_id`= '".$id_price."' order by `id_model`,`proc_shod`;","hash",'pr');
				$text=$text."<table border=0>";
				
				my $count_norm;
				for ($iu=0;$iu<$fol3;$iu++) 
				{
					my $color;
						
					if (($$hhs3[$iu]{proc_shod} < 90) or ($hash_zadvoen{"$$hhs3[$iu]{id_catalog}"} >1))
					{
						$color='red';
						$text=$text."<tr><td><input type=\"checkbox\" name=$$hhs3[$iu]{ids} value=1></td>";
					} 
					elsif ($$hhs3[$iu]{proc_shod} == 100) 
					{
						$color='green';$count_norm++;
						$text=$text."<tr><td><input type=\"checkbox\" name=$$hhs3[$iu]{ids} checked value=1></td>";
					}
					else 
					{
						$color='#007fff';$count_norm++;
						$text=$text."<tr><td><input type=\"checkbox\" name=$$hhs3[$iu]{ids} checked value=1></td>";
					}
				
					my $u1 = URI->new("$ENV{REQUEST_URI}");
					my %FORM;
					my $url = URI->new($u1->path);
					$FORM{krand_val}=rand;
					$FORM{action}='parse_string';
					$FORM{parse_string}=$$hhs3[$iu]{$pole_nomen};
					$url->query_form(%FORM); 	
					$text=$text."<td bgcolor=$color>".($iu+1).".</td><td>Определенные значения: </td><td><a href=http://t61.ru/tovr-001-$$hhs3[$iu]{id_catalog}.html> $$hhs3[$iu]{model_name}</a> ( $$hhs3[$iu]{catalog} )</td></tr>
					<tr><td></td><td>$$hhs3[$iu]{proc_shod}<hr></td><td>Текст прайс листа: <a href=\"$url\" target=\"_blank\">+</a><hr></td><td>$$hhs3[$iu]{$pole_nomen} - $$hhs3[$iu]{$pole_cost}<hr></td></tr>
					";
				}
				
				$text="<form method=get>
				<input type=hidden name=action value=parse_price>
				<input type=hidden name=price_id value=\"$id_price\">
				<input type=hidden name=\"dop_action\" value=\"end_parse_price\">
				<table border=0><tr><td>Прайс лист № </td><td>$$hhs3[0]{price_id} / $$hhs32[0]{caption}</td></tr>
				<tr><td>Создатель прайс листа/\ дата занесения: </td><td>$$hhs32[0]{autor} / $$hhs32[0]{datetime}</td></tr>
				<tr><td>Состояние прайс листа:</td><td></u>Обработан, ожидает завершения</u><br>Внимание для повторной обработки загрузите прйс лист еще раз.</td></tr>
				<tr><td>Количество строк: ".($fol3)." из них $count_norm помечены как найденные.</td><td></td></tr>
				<tr><td>Процент валидности: </td><td>".sprintf("%.2f",($count_norm/($fol3))*100)."<table bordercolor=blue  width=\"100\"><tr><td bgcolor=\"blue\" width=".sprintf("%.0f",($count_norm/($fol3))*100)."></td><td></td></tr></table></td></tr>
				<tr><td></td><td><input type=submit name=end value=\"Завершить размещение прайс листа\"></td></tr>
				</table><hr size=1 color=blue>".$text;
				$text=$text."<tr><td colspan=\"3\"><input type=submit name=end value=\"Завершить размещение прайс листа\"></td></tr></form></table><hr size=1 color=blue>";
				return $text;
			}
			elsif ($$hhs32[0]{status} == 3) 
			{
				my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"SELECT *  FROM `contragent_price_table` as `pt` left join `catalog` as `c` ON `pt`.`model_id` = `c`.`id` where `price_id`= '".$id_price."';","hash",'pr');
				$text=$text."
				<table border=0><tr><td>Прайс лист № </td><td>$$hhs3[0]{price_id} / $$hhs32[0]{caption}</td></tr>
				<tr><td>Создатель прайс листа/\ дата занесения: </td><td>$$hhs32[0]{autor} / $$hhs32[0]{datetime}</td></tr>
				<tr><td>Состояние прайс листа:</td><td></u>Обработан, акцептован</u><br>Внимание для повторной обработки загрузите прйс лист еще раз.</td></tr>
				<tr><td>Количество строк: ".($fol3).".</td><td></td></tr>

				<tr><td>Контрагент: </td><td>$$hhs32[0]{kontragent_ot}</td></tr>
				</table><hr size=1 color=blue>";
				
				$text=$text."<table border=0>";
				my $iu;
				$text=$text."<tr><td bgcolor=white>№ п\п</td><td>Наименование</td><td> Цена за шт</td><td>Количество</td></tr>
					";
				for ($iu=0;$iu<$fol3;$iu++) 
				{
					$text=$text."<tr><td bgcolor=white>".($iu+1).".</td><td><a href=http://t61.ru/tovr-001-$$hhs3[$iu]{model_id}.html> $$hhs3[$iu]{model_name}</a></td><td>$$hhs3[$iu]{cost}</td><td>$$hhs3[$iu]{count}</td></tr>
					";
				}
				$text=$text."</table>";
				return $text;
			}
			else 
			{
			return 0;
			}
		}
		else
		{
		return 0;
		}
		
		
}

sub get_name_translit
{ 
	($_)=@_;
	$_=k82tr($_);
 s/ /_/g;
 s/\'/_/g;
  s/\"/_/g;
    s/\//-/g;
	 s/\\/-/g;
return $_;
}
sub k82tr
    { ($_)=@_;

#
# Fonetic correct translit
#

s/Сх/S\'h/; s/сх/s\'h/; s/СХ/S\'H/;
s/Ш/Sh/g; s/ш/sh/g;

s/Сцх/Sc\'h/; s/сцх/sc\'h/; s/СЦХ/SC\'H/;
s/Щ/Sch/g; s/щ/sch/g;

s/Цх/C\'h/; s/цх/c\'h/; s/ЦХ/C\'H/;
s/Ч/Ch/g; s/ч/ch/g;

s/Йа/J\'a/; s/йа/j\'a/; s/ЙА/J\'A/;
s/Я/Ja/g; s/я/ja/g;

s/Йо/J\'o/; s/йо/j\'o/; s/ЙО/J\'O/;
s/Ё/Jo/g; s/ё/jo/g;

s/Йу/J\'u/; s/йу/j\'u/; s/ЙУ/J\'U/;
s/Ю/Ju/g; s/ю/ju/g;

s/Э/E\'/g; s/э/e\'/g;
s/Е/E/g; s/е/e/g;

s/Зх/Z\'h/g; s/зх/z\'h/g; s/ЗХ/Z\'H/g;
s/Ж/Zh/g; s/ж/zh/g;

tr/
абвгдзийклмнопрстуфхцъыьАБВГДЗИЙКЛМНОПРСТУФХЦЪЫЬ/
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/;

return $_;

}

sub tr2k8
    { ($_)=@_;

#
# Fonetic correct translit
#

s/E\'/Э/g; s/e\'/э/g;
s/E/Е/g; s/e/е/g;

s/Jo/Ё/g; s/jo/ё/g;
s/J\'o/Йо/g; s/j\'o/йо/g; s/J\'O/ЙО/g;

s/Sch/Щ/g; s/sch/щ/g;
s/Sc\'h/Сцх/g; s/sc\'h/сцх/g; s/SC\'H/СЦХ/g;

s/Ch/Ч/g; s/ch/ч/g;
s/C\'h/Цх/g; s/c\'h/цх/g; s/C\'H/ЦХ/g;

s/Sh/Ш/g; s/sh/ш/g;
s/S\'h/Сх/g; s/s\'h/сх/g; s/S\'H/СХ/g;

s/Ja/Я/g; s/ja/я/g;
s/J\'a/Йа/g; s/j\'a/йа/g; s/J\'A/ЙА/g;

s/Zh/Ж/g; s/zh/ж/g;
s/Z\'h/Зх/g; s/z\'h/зх/g; s/Z\'H/ЗХ/g;

s/Ju/Ю/g; s/ju/ю/g;
s/J\'u/Йу/g; s/j\'u/йу/g; s/J\'U/ЙУ/g;


tr/
abvgdzijklmnoprstufhc\"y\'ABVGDZIJKLMNOPRSTUFHC\"Y\'/
абвгдзийклмнопрстуфхцъыьАБВГДЗИЙКЛМНОПРСТУФХЦЪЫЬ/;

return $_;

}
sub parse_page_yandex 
{
#$$varn{res_html} - Страница для разбора
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
	if ($kon_var > 0) 
	{
		$tex_ish =substr($tex_ish,0,$kon_var);
	}
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
	while (my $token = $p->get_tag("a")) 
		{
			my $url1 = $token->[1]{href} || "-";

			my $text = $p->get_trimmed_text("/a");
						$pos=index($url1, 'http://mdata.yandex.net/i?path=');
			if (!$pos)
			{ #print "$pos - $url1\t$1text\n <br>";
				push(@image_list,$url1);
			}	
			
			
			$pos0=index($text, 'Эта модель на');
			# print "+++===++++ $text <br>";
			if (!$pos0)
			{  
				#print "+++===++++ $text <br>";	
				$col_hash{url_site}=$url1;
			}
		
			$pos=index($url1, '/catalog.xml?hid=');
			if (!$pos)
			{  #print "$pos - $url1\t$text\n <br>";	
				unshift(@catalg_list,$text);
				$col_hash{catalog}=get_name_translit($text);
			}

		}
	$$varn{image_list}=\@image_list;
	$$varn{catalog_list}=\@catalg_list;

	$p = HTML::TokeParser->new(\$tex_ish) || die "Can't open: $!";
	$p->empty_element_tags(1);  # configure its behaviour		
	while (my $token = $p->get_tag("h1")) 
	{
		#my $url1 = $token->[1]{href} || "-";
		my $text = $p->get_trimmed_text("/h1");
		$col_hash{model_name}=$text;
		$$varn{model_name}=$text;
		#print "=-------= $text";
	}
  
	#print "==",index($tex_ish, 'все характеристики'),"==";

	$tex_ish =~ s/\<\/span\>\<\/td\>\<td\>/+/g;
	my $var_index =index($tex_ish, 'Основные характеристики');
	if ($var_index < 0) 
	{
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
	while (my $token = $p->get_tag("tr")) 
	{
		my $url1 = $token->[1]{href} || "-";
		my $text = $p->get_trimmed_text("/tr");
		my @m_mas = split(/\+/,$text);
		if ((length($m_mas[0]) > 3) and (length($m_mas[1]) <= 0) and (length($m_mas[0]) <= 255)) 
		{
			$kat_group=$m_mas[0];
			$count_posit=$count_har*100;
			#print "22".length($m_mas[1])."";
			$count_har++;
		}
			#if (length($m_mas[0]) > 3) {
			#print "=Х= $m_mas[0] =P=  $m_mas[1]  - $kat_group $count_posit<br>";
			#}
		if ((length($m_mas[1]) > 0) and (length($m_mas[0]) > 0)) 
		{
			$count_posit++;
			if (length($m_mas[0]) >254) 
			{
				$m_mas[0]='no';
				#print "ddd";
			}	
			
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
 #poluchaem ssilki so stranich dlya yandex
sub get_page_from_base {
	my $varn=$_[0];
	my $url1=$_[1];
	my $text;
	my %hash1;
	
	if ($url1 ne '') {
		my ($fol32,$hhs32) = &get_query($$varn{"dbh2"},"SELECT * FROM `dounload_page` where `url` = '".$url1."' order by `id` desc limit 0,1;","hash",'pr');
		if ($fol32 > 0) 
		{
			if ($$hhs32[0]{dounload} == 1) 
			{
				$hash1{res_html}=$$hhs32[0]{text};
				if (index($url1, 'market.yandex.ru/model.xml') > 0) 
				{
					$hash1{res_html} = Encode::decode('utf8', $hash1{res_html});
					$hash1{res_html} = Encode::encode('cp1251', $hash1{res_html});
					$hash1{id}=$$hhs32[0]{id};
					$text=$text.parse_page_yandex(\%hash1);
				}
				elsif (index($url1, '13123234') > 0) 
				{
				
				}
				else
				{
				
					$text=$text."Страница не может быть обработана так как нет обработчика страница ля данной ссылки ($url1) ";
				}
				return ($text,\%hash1);
			}
			else
			{
				$hash1{url}=$$hhs32[0]{'url'};
				$hash1{id}=$$hhs32[0]{'id'};
		
				my ($fol2,$hhs2) = &get_query($$varn{dbh},"SELECT `proxy`,`status` FROM proxy_list where `yandex` = '200' and `active` ='1'  and `yandex_time` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 5 minute) order by `status` limit 0,1","hash","pr");
				my $pr =$$hhs2[0]{'proxy'}; 
				my $res = get_page(\%hash1,$pr);
				my $code=$res->code;
				my $res_html = $res->content; 
					
				if (($res->is_success)  and (index($varinfo{res_html}, 'DansGuardian') < 0) and (index($varinfo{res_html}, 'Now go away') < 0)) 
				{

					my ($fol3,$hhs3) = &get_query($$varn{dbh2},"update `dounload_page` set `dounload`='1',`text`='".addslashes($res_html)."' where `id` ='".$hash1{id}."' limit 1;","ins","pr");
					#$text=$text."Страница загружена ".
					return get_page_from_base($varn,$url1);	
				}
				else
				{
					$text=$text."Страница не может быть получена ошибка ( $code ) ";
				}
	

			}
		}
		else
		{
			my ($fol5,$hhs5) = &get_query($$varn{dbh2},"INSERT into `dounload_page` (`url`, `dounload`, `link`) values (\'$url1\',0,'$text');","ins","pr");
			#$text=$text.
			return get_page_from_base($varn,$url1);		
		}

	}
	else
	{
		$text=$text."Страница не может быть получена т.к. не верный URL";
		return ($text,\%hash1);
	}
	
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
1;
