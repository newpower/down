
####
####
####
sub fun_delete_doc_fun_show
{
# fun_delete_doc_fun_show($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	my ($var_otvet,$var_text)=&fun_delete_doc_fun_acc($varn,$data_user,$doc_info);
	
	if ($var_otvet == 1)
	{
		$text=$var_text."�� ������������� ������ ������� �������� [$$varn{form_data}{id_oborot}]?";
	}
	else
	{
		$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!!";
	}
	return $text;
		
}

sub fun_delete_doc_fun_act
{
# fun_delete_doc_fun_act($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	my ($var_otvet,$var_text)=&fun_delete_doc_fun_acc($varn,$data_user,$doc_info);
	
	if ($var_otvet == 1)
	{
		$text=$var_text."�������� ������ [$$varn{form_data}{id_oborot}]?";
		my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT INTO `users_history` (`login`, `id_client`, `type_sob`, `IP`, `value`, `value_dop`) VALUES	('".$$data_user{login}."','".$$varn{id_client}."','head-contragent_base_oborot','".$ENV{REMOTE_ADDR}."','������ �������� $$varn{form_data}{id_oborot}','".$$varn{form_data}{id_oborot}."')","ins","pr");	
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"DELETE FROM `contragent_base_oborot` where `id_oborot` = '".$$varn{form_data}{id_oborot}."' limit 1","ins","do");
		my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"DELETE FROM `users_base_priv` where `id_doc` = '".$$varn{form_data}{id_oborot}."'","ins","do");
		$$varn{form_data}{dop_action} = '';

	}
	else
	{
		$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!!";
	}
	return $text;
		
}

sub fun_delete_doc_fun_acc
{
# fun_delete_doc_fun_acc($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	my $text;
	my $otvet=0;
	
	if ($$varn{form_data}{id_oborot} ne '')
	{
		my ($fol30,$hhs30) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$$varn{form_data}{id_oborot}."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
		if ($fol30 > 0)
		{
			my $hash_field=get_head_descr($varn,$data_user,$$hhs30[0]{type_oper},$$hhs30[0]{status});
			my $fun_name=$$varn{form_data}{fun_name};
			
			
			if ($$hash_field{$fun_name}{user_use} == 1) 
			{
				my ($fol31,$hhs31) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot_list` where `id_oborot` ='".$$varn{form_data}{id_oborot}."' limit 0,1;","hash",'pr');
				if ($fol31 == 0)
				{
					my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot_link` where `id_list_ist` ='".$$varn{form_data}{id_oborot}."' or `id_list_naz` ='".$$varn{form_data}{id_oborot}."' limit 0,1;","hash",'pr');
					if ($fol32 == 0)
					{
						my ($fol33,$hhs33) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_posilki` ='".$$varn{form_data}{id_oborot}."' limit 0,1;","hash",'pr');
						if ($fol33 == 0)
						{
							if ($$hhs30[0]{manadger_assign} eq $$data_user{login}) 
							{
								$text='';
								$otvet=1;
							 }
							 else
							 {
							 
				
								$text=$text."�������� �� ����� ���� $$hhs30[0]{manadger_assign} $$hhs32[0]{datetime_assign}<br>��� �������� ��������� ������� ������ [ ������ / accept ] ����� ���� ��������� ��������� ������. <hr color=red>";
				
							 }
						
						
						}
						else
						{
					
							$text=$text."�� �������� ��������� ������ ��������� id_posilki, ������� ������� ������ !!! ";
						}
					}
					else
					{
					
						$text=$text."� ��������� ���� �������� ����� � ��������� �����, ������� ������� �� !!! ";
					}
				}
				else
				{
					$text=$text."� ��������� ���� ������ � ��������� �����, ������� ������� �� !!! ";
			
				}
				
			}
			else
			{
				$text=$text."��� ������ ������� ��������� ��������� ������������ ������ ������� !!! ";
			}
		}
		else
		{
			$text=$text."� �� ��� ��������� $$varn{form_data}{id_oborot}, ���� � ��� ��� ����� ������������� � ������������� ������ ��������!";
		}
				
			
	}
	else
	{
		$text=$text."�� ��� ������������ ���� ��������� [ id_doc $$varn{form_data}{id_oborot} id_tovar $$varn{form_data}{id_tovar} countTovar $$varn{form_data}{count} costTovar $$varn{form_data}{cost} ndsTovar $$varn{form_data}{stavka_nds} ]";
	
	}
	
		
	return ($otvet,$text);
		
}

	
	
######
######
######
sub fun_set_id_posilki_fun_show
{
# fun_delete_doc_fun_show($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	#my ($var_otvet,$var_text)=&fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info);
	
	#if ($var_otvet == 1)
	#{
	
	my $text;
	my $flag_variant=1;
	
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `type_oper` in ('50') and `status` = '0' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
	if ($fol32 > 0) 
	{
		my $iu1;
		my $error_ok_status=0;
		my $text_otvet;
		for ($iu1=0;$iu1<$fol32;$iu1++) 
		{
			my %hash_temp;
			 $hash_temp{id_doc}=$$hhs32[$iu1]{id_oborot};
			#$text=$text."$$hhs32[$iu1]{id_oborot} ---";
			$text=$text." - <a href=$$data_user{path}?action=man_doc_oborot&dop_action=dop_function&fun_name=fun_set_id_posilki&id_oborot=$$varn{form_data}{id_oborot}&id_doc=$$varn{form_data}{id_oborot}&id_posilki=$$hhs32[$iu1]{id_oborot}>�������� �������� ������� �� $$hhs32[$iu1]{id_oborot}</a><br>����� $$hhs32[$iu1]{manadger_create} ���� �������� $$hhs32[$iu1]{datetime_create} <hr color=gray>";
					
		}
	}
	else
	{
		$text=$var_text."��� ��������� �������!";
	}	
		$text=$text." - <a href=$$data_user{path}?action=man_doc_oborot&dop_action=dop_function&fun_name=fun_set_id_posilki&id_oborot=$$varn{form_data}{id_oborot}&id_doc=$$varn{form_data}{id_oborot}&id_posilki=0>������ � ���������  ��������</a>";
	
	#}
	#else
	#{
	#	$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!!";
	#}
	return $text;
		
}

sub fun_set_id_posilki_fun_act
{
# fun_delete_doc_fun_act($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	my ($var_otvet,$var_text)=&fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info);
	
	if ($var_otvet == 1)
	{
		$text=$var_text."����� ������� ������� [$$varn{form_data}{id_posilki}] <BR>";
	
	my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT INTO `users_history` (`login`, `id_client`, `type_sob`, `IP`, `value`, `value_dop`) VALUES	('".$$data_user{login}."','".$$varn{id_client}."','head-contragent_base_oborot','".$ENV{REMOTE_ADDR}."','������� ��������� ������� (��������) �� $$varn{form_data}{id_posilki} � ����� $$varn{form_data}{id_doc}','".$$varn{form_data}{id_doc}."')","ins","pr");	
	my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"update `contragent_base_oborot` set `id_posilki`='".$$varn{form_data}{id_posilki}."', `datetime_change`=CURRENT_TIMESTAMP, `manadger_change`='".$$data_user{login}."' where `id_oborot` = '".$$varn{form_data}{id_doc}."'","ins","do");
						
						
	$$varn{form_data}{dop_action} = 'edit_doc_oborot';

	}
	else
	{
		$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!! <BR>";
	}
	return $text;
		
}

sub fun_set_id_posilki_fun_acc
{
# fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	my $text;
	my $otvet=0;
	
	if ($$varn{form_data}{id_doc} ne '')
	{
		my ($fol30,$hhs30) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$$varn{form_data}{id_doc}."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
		if ($fol30 > 0)
		{
			my $hash_field=get_head_descr($varn,$data_user,$$hhs30[0]{type_oper},$$hhs30[0]{status});
			my $fun_name=$$varn{form_data}{fun_name};
			
			
			if ($$hash_field{$fun_name}{user_use} == 1) 
			{
				if ($$varn{form_data}{id_posilki} ne '')
				{
					my ($fol31,$hhs31) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$$varn{form_data}{id_posilki}."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
					if (($fol31 > 0) or ($$varn{form_data}{id_posilki} == 0))
					{
						my $hash_field2=get_head_descr($varn,$data_user,$$hhs31[0]{type_oper},$$hhs31[0]{status});
					
						if (($$hash_field2{table_part2}{change_user} == 1) or ($$varn{form_data}{id_posilki} == 0)) 
						{
							my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$$hhs30[0]{id_posilki}."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
							if ($fol32 == 1) 
							{
								my $hash_field3=get_head_descr($varn,$data_user,$$hhs32[0]{type_oper},$$hhs32[0]{status});
								if ($$hash_field3{table_part2}{change_user} == 1)
								{
									$otvet=1;
								}
								else
								{
									$text=$text."� ��������� ������� $$hhs30[0]{id_posilki} ����� ����� ������ ��� ������ ������ ������ �������� �������. ����� �������� �������� ������� ������� � ���� �������� ������ [$$hhs32[0]{status} ].<br>  ";
								}
							}
							else
							{
								$otvet=1;
							}	
						}
						else
						{
							$text=$text." �������� ������� ��������� � ����� ������� ����� ������ ����������� ��� ���������.!!! <br>  ";

						}
					
					}
					else
					{
						$text=$text."� �� ��� ��������� $$varn{form_data}{id_posilki} ��� � ��� ��� ����� ������� � ��������� !!! <br> ";
					}
					
				}
				else
				{
					$text=$text."��������� ���� ����� ��������� ������� <br> !!! ";
				}
				
			}
			else
			{
				$text=$text."��� ������ ������� ��������� ��������� ������������ ������ ������� !!! ";
			}
		}
		else
		{
			$text=$text."� �� ��� ��������� $$varn{form_data}{id_doc}, ���� � ��� ��� ����� ������������� � ������������� ������ ��������!";
		}
				
			
	}
	else
	{
		$text=$text."�� ��� ������������ ���� ��������� [ id_doc $$varn{form_data}{id_oborot} id_tovar $$varn{form_data}{id_tovar} countTovar $$varn{form_data}{count} costTovar $$varn{form_data}{cost} ndsTovar $$varn{form_data}{stavka_nds} ]";
	
	}
	
		
	return ($otvet,$text);
		
}

######
######
######
sub fun_seach_id_posilki_fun_show
{
# fun_delete_doc_fun_show($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	#my ($var_otvet,$var_text)=&fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info);
	
	#if ($var_otvet == 1)
	#{
	
	my $text;
	my $flag_variant=1;
	
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `type_oper` in ('1','10') and `status` > '0' and `id_posilki` in ('','0') and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
	if ($fol32 > 0) 
	{
		my $iu1;
		my $error_ok_status=0;
		my $text_otvet;
		for ($iu1=0;$iu1<$fol32;$iu1++) 
		{
			my %hash_temp;
			 $hash_temp{id_doc}=$$hhs32[$iu1]{id_oborot};
			#$text=$text."$$hhs32[$iu1]{id_oborot} ---";
			$text=$text." - <a href=$$data_user{path}?action=man_doc_oborot&dop_action=dop_function&fun_name=fun_set_id_posilki&id_oborot=$$varn{form_data}{id_oborot}&id_doc=$$hhs32[$iu1]{id_oborot}&id_posilki=$$varn{form_data}{id_oborot}>�������� �������� � ������� $$hhs32[$iu1]{id_oborot}</a><br>����� $$hhs32[$iu1]{manadger_create} ���� �������� $$hhs32[$iu1]{datetime_create} <hr color=gray>";
					
		}
	}
	else
	{
		$text=$var_text."��� ��������� ��������� ��� ��������!";
	}	
		
		
	#}
	#else
	#{
	#	$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!!";
	#}
	return $text;
		
}

sub fun_seach_id_posilki_fun_act
{
# fun_delete_doc_fun_act($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		

		
		
}

sub fun_seach_id_posilki_fun_acc
{
# fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	

	
}


######
######
######
sub fun_change_status_doc_show
{
# fun_delete_doc_fun_show($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
		
	#my ($var_otvet,$var_text)=&fun_set_id_posilki_fun_acc($varn,$data_user,$doc_info);
	
	#if ($var_otvet == 1)
	#{
	
		$text=$var_text."��������� ID posilki [$$varn{form_data}{id_oborot}]?";
		
	#}
	#else
	#{
	#	$text=$var_text."������� ������, ��� ���� ����� ���������� ��������� ��!!!";
	#}
	return $text;
		
}

sub fun_change_status_doc_acc
{
# fun_change_status_doc_acc($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];

	
		sub check_field_doc_kontragent
		{
		# check_field_doc_kontragent_svoi($varn,$data_user,$kontragent,$kontragent_polzovat,$kontragent_type,$kontragent_parent)
	
			my $varn=$_[0];
			my $data_user=$_[1];
			my $kontragent=$_[2];
			my $kontragent_polzovat=$_[3];
			my $kontragent_type=$_[4];
			my $kontragent_parent=$_[5];

			my $text;
			my $status_return=0;
				if ($kontragent > 0)
				{
					my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base` where `id` ='".$kontragent."' limit 0,1;","hash",'pr');
					if ($fol35 == 1)
					{
						if (($$hhs35[0]{parent} == $kontragent_parent) and ($$hhs35[0]{type_polzovat} eq $kontragent_polzovat) ) 
						{
							if ($$hhs35[0]{type_contragent} eq $kontragent_type)
							{
								$status_return++;
								$text=$text."Ok<br>";
							}
							else
							{
									$text=$text."��� ���������� ����������� �� ������������ ���� ����� [ $kontragent_type ] ������ [ $$hhs35[0]{type_contragent} ]  �������� ������� ����������� ...<br><hr color=red>";

							}
						}
						else
						{
							$text=$text."��� ����������� �� ������������ ���� ��������� ����� [ $kontragent_polzovat ] ����� type_polzovat[ $$hhs35[0]{type_polzovat} ]   [ $$hhs35[0]{parent} == $kontragent_parent ]<br><hr color=red>";

						}
					}
					else
					{
						$text=$text."� ���� ������������ ��� ������ [ $kontragent ]   <br><hr color=red>";
	
					}
				}
				else
				{
					$text=$text."�� ��������� ���� ����������� [ $kontragent ]  � ��������� ID document [ $id_doc ] <br><hr color=red>";
	
				}
			return ($status_return,$text);	
		
		}
		
		sub check_field_doc_sklad
		{
		# check_field_doc_sklad($varn,$data_user,$kontragent,$kontragent_sklad,$kontragent_sklad_in_work)
	
			my $varn=$_[0];
			my $data_user=$_[1];
			my $kontragent=$_[2];
			my $kontragent_sklad=$_[3];
			my $kontragent_sklad_in_work=$_[4];
		

			my $text;
			my $status_return=0;
				if ($kontragent_sklad > 0)
				{
					my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_sklad` where `id` ='".$kontragent_sklad."' limit 0,1;","hash",'pr');
					if ($fol35 == 1)
					{
						if ($$hhs35[0]{contragent_id} eq $kontragent) 
						{
							if ($$hhs35[0]{in_work_sklad} == $kontragent_sklad_in_work)
							{
								$status_return++;
								$text=$text."Ok<br>";
							}
							else
							{
								$text=$text."��� ������ # $kontragent_sklad �� ������������ [ $$hhs35[0]{in_work_sklad} ]   sklad_in_work [ $kontragent_sklad_in_work ] �� ������������ �����. <br><hr color=red>";

							}
						}
						else
						{
							$text=$text."����� # $kontragent_sklad  �� ������������  ����������� [ $kontragent ] !=  [ $$hhs35[0]{contragent_id} ] <br><hr color=red>";

						}
					}
					else
					{
						$text=$text."� ���� ������� ��� ������ [ $kontragent_sklad ]   <br><hr color=red>";
	
					}
				}
				else
				{
					$text=$text."�� ��������� ���� �����  [ $kontragent_sklad  ]  � ��������� ID document [ $id_doc ] <br><hr color=red>";
	
				}
			return ($status_return,$text);	
		
		}

		
		my $return_otvet =0;
		my $text;
		
		my $id_doc_nomer;
			if ($$doc_info{id_oborot} ne '') 
			{
				$id_doc_nomer=$$doc_info{id_oborot};
			}
			else
			{
				$id_doc_nomer=$$varn{form_data}{id_oborot};
			}
			
			
		my ($fol33,$hhs33) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$id_doc_nomer."'  and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
		my $id_doc_status_old;
			if ($$doc_info{status_old} ne '') 
			{
				$id_doc_status_old=$$doc_info{status_old};
			}
			else
			{
				$id_doc_status_old=$$hhs33[0]{status};
			}
		my $id_doc_status_new;
			if ($$doc_info{status_new} ne '') 
			{
				$id_doc_status_new=$$doc_info{status_new};
			}
			else
			{
				$id_doc_status_new=$$varn{form_data}{status};
			}
	
		if (($id_doc_status_new ne '') and (($id_doc_status_new == $id_doc_status_old-1) or ($id_doc_status_new == $id_doc_status_old+1)))
		{
			#��������� ��������� � ����� 10 ������ � 0 �� 1
			if (($$hhs33[0]{type_oper} == 10) and ($id_doc_status_old == 0) and ($id_doc_status_new == 1))
			{

				my $count_ok=3;
				#�������� ���������� ��
				my ($status_otvet,$text_otvet) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_ot},'org','svoi',0);
				$count_ok=$count_ok-$status_otvet;
				$text= $text."���������� ��: ".$text_otvet;
				
				#�������� ������
				my ($status_otvet,$text_otvet) = check_field_doc_sklad($varn,$data_user,$$hhs33[0]{contragent_ot},$$hhs33[0]{sklad_ot},1);
				$count_ok=$count_ok-$status_otvet;
				$text= $text."����� ��: ".$text_otvet;
				
				###�������� ���������� ��
				my ($status_otvet,$text_otvet) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_to},'org','klient',0);
				my ($status_otvet2,$text_otvet2) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_to},'person','klient',0);
				if (($status_otvet == 0) and ($status_otvet2 == 0))
				{
					$text= $text."���������� ����: ".$text_otvet;
				}
				else
				{
					$count_ok=$count_ok-1;
				}
				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			
			#��������� ��������� � ����� 10 ������ � 1 �� 2
			if (($$hhs33[0]{type_oper} == 10) and ($id_doc_status_old == 1) and ($id_doc_status_new == 2))
			{

				my $count_ok=2;
				#��������� ��������� �� ���� ���� �� � ���� �
				if (($$hhs33[0]{datetime_polucheniya_ot} ne '') and ($$hhs33[0]{datetime_polucheniya_do} ne ''))
				{
					$count_ok=$count_ok-1;
				}
				else
				{
					$text= $text."���� �������� �� ��� ���� �������� �� �� ���������.<hr color=red>";
				}
				
				#��������� ��� �� ������ ������
				my ($fol33,$hhs33) = &get_query($$varn{"dbh"},"
				select `sum_link`,`clist`.`id_tovar` as `id_tovar`,`clist`.`count` as `sum_list` from contragent_base_oborot_list as `clist`
				left join  (SELECT sum(`clink`.`count`) as `sum_link`,`clink`.`id_tovar` as `id_tovar`
				FROM contragent_base_oborot_link as clink
				left join `contragent_base_oborot` as `co` on `co`.`id_oborot`= `clink`.`id_list_naz`
				where `clink`.`id_list_ist` = '".$id_doc_nomer."' and `co`.`type_oper` in ('1','5')
				group by  `clink`.`id_tovar`) as clink on `clink`.`id_tovar` = `clist`.`id_tovar`
				where  `clist`.`id_oborot` = '".$id_doc_nomer."';","hash",'pr');
				my $iu1;
				my $error_ok_status=0;
				my $text_otvet;
				for ($iu1=0;$iu1<$fol33;$iu1++) 
				{
					if ($$hhs33[$iu1]{sum_link} != $$hhs33[$iu1]{sum_list})
					{
						$text_otvet= $text_otvet."����� $$hhs33[$iu1]{id_tovar} �� ����������� �������! <br> ";
						$error_ok_status=1;
					}
					
				}
				if ($error_ok_status == 0) {$count_ok--;}
				else
				{
					$text= $text.$text_otvet;
				}
				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			
			#��������� ��������� � ����� 1 ������ � 0 �� 1			
			if (($$hhs33[0]{type_oper} == 1) and ($id_doc_status_old == 0) and ($id_doc_status_new == 1))
			{

				my $count_ok=4;
				###�������� ���������� ��
				my ($status_otvet,$text_otvet) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_ot},'org','postavshik',0);
				my ($status_otvet2,$text_otvet2) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_ot},'person','postavshik',0);
				if (($status_otvet == 0) and ($status_otvet2 == 0))
				{
					$text= $text."���������� �� (���������): ".$text_otvet;
				}
				else
				{
					$count_ok=$count_ok-1;
				}
				
				#�������� ���������� rjve
				my ($status_otvet,$text_otvet) = check_field_doc_kontragent($varn,$data_user,$$hhs33[0]{contragent_to},'org','svoi',0);
				$count_ok=$count_ok-$status_otvet;
				$text= $text."���������� ���� (���� ����� ��� ��������): ".$text_otvet;
				
				#�������� ������ ���� ���������
				my ($status_otvet,$text_otvet) = check_field_doc_sklad($varn,$data_user,$$hhs33[0]{contragent_to},$$hhs33[0]{sklad_to},1);
				$count_ok=$count_ok-$status_otvet;
				$text= $text."����� ��: ".$text_otvet;
				
				#�������� ��� �� ������� ������ �������� � �������� ��������� �� ������ �����
						my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"
						SELECT DISTINCT(id_list_ist) as `doki`,`type_oper` FROM contragent_base_oborot_link as `cl`
							left join contragent_base_oborot as `co`ON `cl`.`id_list_ist`=`co`.`id_oborot`
							where `cl`.`id_list_naz`='".$id_doc_nomer."' and `co`.`type_oper` in (10,15)
							and `co`.`contragent_ot` != '".$$hhs33[0]{contragent_to}."' and `co`.`sklad_ot` != '".$$hhs33[0]{sklad_to}."';","hash",'pr');
					if ($fol35 > 0)
					{
						$text= $text."� ��������� ���������� �� ������������ ���������� (���������� �� � ���������� ������ �������� � ������ �� ��������).<br>";
						my $mas_oper = get_head_type_doc_descr($varn,$data_user);
						my $iu;
						for ($iu=0;$iu<$fol35;$iu++) 
						{
							my $var_podtype=$$hhs35[$iu]{type_oper};
							$text= $text."<a href=$$data_user{path}?action=man_doc_oborot&dop_action=edit_doc_oborot&id_oborot=$$hhs35[$iu]{doki} target=\"_blank\">$$mas_oper[$var_podtype]{caption} � $$hhs35[$iu]{doki} </a>";
						}
						$text= $text."<hr color=red>";
					
					}
					else
					{
						$count_ok=$count_ok-1;
					}
					
			
				

				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			if (($$hhs33[0]{type_oper} == 1) and ($id_doc_status_old == 1) and ($id_doc_status_new == 2))
			{

				my $count_ok=4;
				
				#��������� ������������ �� ��������
				if (($$hhs33[0]{id_posilki} ne '') and ($$hhs33[0]{id_posilki} > 0))
				{
					$count_ok=$count_ok-1;
				}
				else
				{
					$text= $text."�� ���������� �������� �������.<hr color=red>";
				}
				
				
				#��������� ��������� �� ���� ���� �� � ���� �
				if (($$hhs33[0]{datetime_polucheniya_ot} ne '') and ($$hhs33[0]{datetime_polucheniya_do} ne ''))
				{
					$count_ok=$count_ok-1;
				}
				else
				{
					$text= $text."���� �������� �� ��� ���� �������� �� �� ���������.<hr color=red>";
				}
				#�������� �� ��������� ������� �� �������� ������ ������������
				my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"
						SELECT DISTINCT(id_list_ist) as `doki`,`type_oper` FROM contragent_base_oborot_link as `cl`
							left join contragent_base_oborot as `co`ON `cl`.`id_list_ist`=`co`.`id_oborot`
							where `cl`.`id_list_naz`='".$id_doc_nomer."' and `co`.`type_oper` in (10,15)
							and `co`.`status` < '2';","hash",'pr');
					if ($fol35 > 0)
					{
						$text= $text."� ��������� ������� ���������� �� ���������� ������ \\������������\\.<br>";
						my $mas_oper = get_head_type_doc_descr($varn,$data_user);
						my $iu;
						for ($iu=0;$iu<$fol35;$iu++) 
						{
							my $var_podtype=$$hhs35[$iu]{type_oper};
							$text= $text."<a href=$$data_user{path}?action=man_doc_oborot&dop_action=edit_doc_oborot&id_oborot=$$hhs35[$iu]{doki} target=\"_blank\">$$mas_oper[$var_podtype]{caption} � $$hhs35[$iu]{doki} </a>";
						}
						$text= $text."<hr color=red>";
						
					}
					else
					{
						$count_ok=$count_ok-1;
					}
					
				#�������� ��� �� ��������� ����������
				my ($fol33,$hhs33) = &get_query($$varn{"dbh"},"
				select `sum_link`,`clist`.`id_tovar` as `id_tovar`,`clist`.`count` as `sum_list` from contragent_base_oborot_list as `clist`
				left join  (SELECT sum(`clink`.`count`) as `sum_link`,`clink`.`id_tovar` as `id_tovar`
				FROM contragent_base_oborot_link as clink
				left join `contragent_base_oborot` as `co` on `co`.`id_oborot`= `clink`.`id_list_ist`
				where `clink`.`id_list_naz` = '".$id_doc_nomer."' and `co`.`type_oper` in ('10','15')
				group by  `clink`.`id_tovar`) as clink on `clink`.`id_tovar` = `clist`.`id_tovar`
				where  `clist`.`id_oborot` = '".$id_doc_nomer."';","hash",'pr');
				my $iu1;
				my $error_ok_status=0;
				my $text_otvet;
				for ($iu1=0;$iu1<$fol33;$iu1++) 
				{
					if ($$hhs33[$iu1]{sum_link} != $$hhs33[$iu1]{sum_list})
					{
						$text_otvet= $text_otvet."����� $$hhs33[$iu1]{id_tovar} �� ����������� �������! <br> ";
						$error_ok_status=1;
					}
					
				}
				if ($error_ok_status == 0) {$count_ok--;}
				else
				{
					$text= $text.$text_otvet;
				}
				
				
				
				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			
			if (($$hhs33[0]{type_oper} == 1) and ($id_doc_status_old == 2) and ($id_doc_status_new == 3))
			{

				my $count_ok=0;
				

				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			
			#��������� ��������� � ����� 50 ������ � 0 �� 1			
			
			if (($$hhs33[0]{type_oper} == 50) and ($id_doc_status_old == 0) and ($id_doc_status_new == 1))
			{

				my $count_ok=3;
				
				###�������� ���������� ��
				my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base` where `id` ='".$$hhs33[0]{contragent_to}."' limit 0,1;","hash",'pr');
				if (($fol35 == 1) and ($$hhs33[0]{contragent_to} != 0))
				{
					
					$count_ok=$count_ok-1;
				}
				else
				{
					$text= $text."������ (��� ��������): �� ������ ������ <br>";
				}

				
				#�������� �� ��������� 01 - ������ ����������� ������� �� �������� ������ ������������
				my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"
						SELECT `id_oborot` as `doki`,`type_oper` FROM contragent_base_oborot as `cl`
						where `cl`.`id_posilki`='".$id_doc_nomer."' and `cl`.`type_oper` = '1'
							and `cl`.`status` < '2';","hash",'pr');
					if ($fol35 > 0)
					{
						$text= $text."� ��������� ������� ���������� �� ���������� ������ \\������������\\.<br>";
						my $mas_oper = get_head_type_doc_descr($varn,$data_user);
						my $iu;
						for ($iu=0;$iu<$fol35;$iu++) 
						{
							my $var_podtype=$$hhs35[$iu]{type_oper};
							$text= $text."<a href=$$data_user{path}?action=man_doc_oborot&dop_action=edit_doc_oborot&id_oborot=$$hhs35[$iu]{doki} target=\"_blank\">$$mas_oper[$var_podtype]{caption} � $$hhs35[$iu]{doki} </a>";
						}
						$text= $text."<hr color=red>";
						
					}
					else
					{
						$count_ok=$count_ok-1;
					}
				
				#22���������� �� ��������� (�������� ���������) ������� �� �������� ������ ������������
				my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"
						SELECT `id_oborot` as `doki`,`type_oper` FROM contragent_base_oborot as `cl`
						where `cl`.`id_posilki`='".$id_doc_nomer."' and `cl`.`type_oper` = '10'
							and `cl`.`status` < '3';","hash",'pr');
					if ($fol35 > 0)
					{
						$text= $text."� ��������� ������� ���������� (�������� ���������) �� ���������� ������ \\������������\\.<br>";
						my $mas_oper = get_head_type_doc_descr($varn,$data_user);
						my $iu;
						for ($iu=0;$iu<$fol35;$iu++) 
						{
							my $var_podtype=$$hhs35[$iu]{type_oper};
							$text= $text."<a href=$$data_user{path}?action=man_doc_oborot&dop_action=edit_doc_oborot&id_oborot=$$hhs35[$iu]{doki} target=\"_blank\">$$mas_oper[$var_podtype]{caption} � $$hhs35[$iu]{doki} </a>";
						}
						$text= $text."<hr color=red>";
						
					}
					else
					{
						$count_ok=$count_ok-1;
					}
				
				###
				if ($count_ok == 0){$return_otvet=1;}
			}
			
			if (($$hhs33[0]{type_oper} == 50) and ($id_doc_status_old == 1) and ($id_doc_status_new == 2))
			{

				my $count_ok=2;
				

				
				#�������� �� ��������� 01 - ������ ����������� ������� �� �������� ������ ������������
				my ($fol35,$hhs35) = &get_query($$varn{"dbh"},"
						SELECT `id_oborot` as `doki`,`type_oper` FROM contragent_base_oborot as `cl`
						where `cl`.`id_posilki`='".$id_doc_nomer."' and `cl`.`type_oper` = '1'
							and `cl`.`status` <= '2';","hash",'pr');
					
					if ($fol35 > 0)
					{
						
						my $mas_oper = get_head_type_doc_descr($varn,$data_user);
						my $iu;
						for ($iu=0;$iu<$fol35;$iu++) 
						{
							my $var_podtype=$$hhs35[$iu]{type_oper};
							
							my %doc_info;
							$doc_info{status_new}=3;
							$doc_info{id_oborot}=$$hhs35[$iu]{doki};
							$doc_info{user_auto}=1;
							
							
							
							$text= $text."<br>� ��������� ";
							$text= $text."<a href=$$data_user{path}?action=man_doc_oborot&dop_action=edit_doc_oborot&id_oborot=$$hhs35[$iu]{doki} target=\"_blank\">$$mas_oper[$var_podtype]{caption} � $$hhs35[$iu]{doki} </a>";
							
							my ($status_otvet,$text_otvet) = fun_change_status_doc_acc($varn,$data_user,\%doc_info);
							if ($status_otvet == 1)
							{
								my ($status_otvet,$text_otvet) = fun_change_status_doc_act($varn,$data_user,\%doc_info);
								$text= $text." ���������� ������ ����������.";
								$text= $text.$text_otvet;
							}
							else
							{
								$text= $text." �� ���������� ���������� ������.";
								$text= $text."--- $status_otvet --".$text_otvet;
								$count_ok=$count_ok+1;
							}

						}
						$text= $text."<hr color=red>";
						
					}
					else
					{
						$count_ok=$count_ok-1;
					}
				
	
				
				###
				if ($count_ok == 0){$return_otvet=1;}
			}

		}
		else
		{
			$text= $text."<hr color=red>";
			
		}		
				
		return ($return_otvet,$text);
		
}

sub fun_change_status_doc_act
{
# fun_delete_doc_fun_show($varn,$data_user,$doc_info)
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];

	my $id_doc_nomer;
		if ($$doc_info{id_oborot} ne '') 
		{
			$id_doc_nomer=$$doc_info{id_oborot};
		}
		else
		{
			$id_doc_nomer=$$varn{form_data}{id_oborot};
		}
			
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$id_doc_nomer."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
	
	my $id_doc_status_new;
		if ($$doc_info{status_new} ne '') 
		{
			$id_doc_status_new=$$doc_info{status_new};
		}
		else
		{
			$id_doc_status_new=$$varn{form_data}{status};
		}
			

	if (($$hhs32[0]{manadger_assign} eq $$data_user{login}) or  ($$doc_info{user_auto} == 1))
	{
		if ($$hhs32[0]{flag_accept} == 0)
		{
			my ($status_otvet,$text_otvet) = fun_change_status_doc_acc($varn,$data_user,$doc_info);
			if ($status_otvet == 1)
			{
				$text=$text."  ������ ����������<hr color=red>";
				my ($fol38,$hhs38) = &get_query($$varn{"dbh"},"SELECT * FROM `dictionary_status` where `doc_type` = '".$$hhs32[0]{type_oper}."' and `doc_status` = '".$$hhs32[0]{status}."' limit 0,1;","hash",'pr');
				my ($fol39,$hhs39) = &get_query($$varn{"dbh"},"SELECT * FROM `dictionary_status` where `doc_type` = '".$$hhs32[0]{type_oper}."' and `doc_status` = '".$id_doc_status_new."' limit 0,1;","hash",'pr');
				my $var_status_old = $$hhs32[0]{status};
				my $var_status_old = $$hhs38[0]{$var_status_old};
				
				#Chtobi raspechatat slovami
				my $var_status_new = $id_doc_status_new;
				my $var_status_new = $$hhs39[0]{$var_status_new};
						
						
				my ($fol3,$hhs3) = &get_query($$varn{dbh},"INSERT INTO `users_history` (`login`, `id_client`, `type_sob`, `IP`, `value`, `value_dop`) VALUES	('".$$data_user{login}."','".$$varn{id_client}."','contragent_base_oborot','".$ENV{REMOTE_ADDR}."','������� ������ � $var_status_old  $$hhs32[0]{status} �� $var_status_new $id_doc_status_new','".$$hhs32[0]{id_oborot}."')","ins","pr");	
				my ($fol3,$hhs3) = &get_query($$varn{"dbh"},"update `contragent_base_oborot` set `status` ='".$id_doc_status_new."', `datetime_change`=CURRENT_TIMESTAMP, `manadger_change`='".$$data_user{login}."' where `id_oborot` = '".$$hhs32[0]{id_oborot}."'","ins","do");

				
			}
			else
			{
				$text=$text."  $text_otvet  <hr color=red>";
			}
					
	
		}
		else
		{
			$text=$text."�������� [ $$varn{form_data}{id_oborot} ] ����������, ��� �������������� ���������� �������������!<hr color=red>";
		}
	}
	else
	{
		$text=$text."�������� �� ����� ���� $$hhs32[0]{manadger_assign} $$hhs32[0]{datetime_assign}<br>��� �������� ��������� ������� ������ [ ������ / accept ] ����� ���� ��������� ��������� ������. <hr color=red>";
	}
	$$varn{form_data}{dop_action} = 'edit_doc_oborot';
	
	
	return $text;
		
}
	
######
######
######
sub fun_print_doc_show
{
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	my $text;
	my $flag_variant=1;
	
	
	my ($fol32,$hhs32) = &get_query($$varn{"dbh"},"SELECT * FROM `contragent_base_oborot` where `id_oborot` ='".$$varn{form_data}{id_oborot}."' and `id_oborot` in (SELECT `id_doc` FROM `users_base_priv` where `table` = 'contragent_base_oborot'  and `prem` in (SELECT `prem` FROM `users_base_priv` where `login` = '".$$data_user{login}."')) limit 0,1;","hash",'pr');
	my $mas_oper = get_head_type_doc_descr($varn,$data_user);
	my $var_podtype=$$hhs32[0]{type_oper};
	
	
		if ($$hhs32[0]{type_oper} == 1)
		{
			if ($$hhs32[0]{status} > 0)
			{
				$text=$text."<a target=_blank href=$$data_user{path}?action=man_ajax&dop_action=dop_print&dop_print_doc_type=zakaz_postav&id_doc=".$$varn{form_data}{id_oborot}.">������� �������� ����� ������</a>";
				$flag_variant=0;
			}
		}	
		if ($$hhs32[0]{type_oper} == 50)
		{
			if ($$hhs32[0]{status} > 0)
			{
				$text=$text."<a target=_blank href=$$data_user{path}?action=man_ajax&dop_action=dop_print&dop_print_doc_type=zakaz_postav&id_doc=".$$varn{form_data}{id_oborot}.">������ ����������������� ���������</a>";
				$flag_variant=0;
			}
		}	
		
	if ($flag_variant=1) {$text=$text." ��� ��������� $$varn{form_data}{id_oborot} [ $$mas_oper[$var_podtype]{caption} ] �� �������� $$hhs32[0]{status} ��� ��������� ���� ��� ������.";}
	return $text;
}

			
sub fun_print_doc_acc
{
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	my $error_ok_status=0;
	my $text_otvet;
					

					
	return ($error_ok_status,$text_otvet);
	
}


sub fun_print_doc_act
{
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	
}
	

	
	
1;
