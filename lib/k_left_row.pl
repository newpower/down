#!/usr/bin/perl -w
##
## k_left_row - גûגמה כוגמדמ סעמכבצא
##

require "../lib/k_DB.pl";
use vars '$counter';

sub rek_get_subcat
{
	my $tmp;
	my $res="";
	my $var_mag_id=shift;
	my $db=shift;
	my $parent=shift;
	
##	my $SQL = "SELECT `name_catalog_translit`, `name_ru` FROM catalog_list \
##		where  `name_parant_ru_translit` LIKE '".$parent."' and (`visible_mag".$var_mag_id."`=1) order by `order_mag".$var_mag_id."`,`name_catalog_translit`;";
	my $SQL = "SELECT `name_catalog_translit`, `name_ru` FROM catalog_list \
		where  `name_parant_ru_translit` LIKE '".$parent."' order by `order_mag".$var_mag_id."`,`name_catalog_translit`;";

	my %mass=db_get($db,$SQL);
	
##	$res=$res.scalar(@mass).$SQL."<BR>\n";
	
	if(%mass != ())
	{
		foreach $key (keys %mass)
		{
			$tmp=rek_get_subcat($var_mag_id,$db,$key);
			if($tmp eq "")
			{
				$res=$res."<LI style=\"list-style-type: circle\"><a href=\"../shop-001-".$key.".html\">$mass{$key}</a></LI>\n";
			}else
			{
				$counter++;
				$res=$res."<LI id=\"navHeader$counter\" onClick=\"shiftSubDiv($counter)\" style=\"list-style-type: square\"><a>$mass{$key}</a></LI>\n";
				$res=$res."<UL id=\"subDiv$counter\" style=\"display:none\">\n";
				$res=$res.$tmp."</UL>\n";
			}
		}
	}
	
	return $res;
}

sub get_catalog
{
	local $counter=0;
	my $tmp="";
	my $var_mag_id=shift;
	my $res="";
	
	my $db=db_connect();

	my $SQL = "SELECT `name_catalog_translit`, `name_ru` FROM catalog_list \
		where  `name_parant_ru_translit` LIKE '' order by `order_mag".$var_mag_id."`,`name_catalog_translit`;";
	
##	my $SQL = "SELECT `name_catalog_translit`, `name_ru` FROM catalog_list \
##		where  `name_parant_ru_translit` LIKE '' and (`visible_mag".$var_mag_id."`=1) order by `order_mag".$var_mag_id."`,`name_catalog_translit`;";
##	my $SQL = "SELECT `p`.`name_catalog_translit`, `p`.`name_ru` FROM catalog_list as `p` where  `p`.`name_parant_ru_translit` = '';";
	my %mass=db_get($db,$SQL);
	
	$res=$res."<UL style=\"cursor: pointer\">\n";
	
	foreach $key (keys %mass)
	{
		$tmp=rek_get_subcat($var_mag_id,$db,$key);
		if($tmp eq "")
		{
			$res=$res."<LI style=\"list-style-type: circle\"><a href=\"../shop-001-".$key.".html\">$mass{$key}</a></LI>\n";
		}else
		{
			$counter++;
			$res=$res."<LI id=\"navHeader$counter\" onClick=\"shiftSubDiv($counter)\" style=\"list-style-type: square\"><a>$mass{$key}</a></LI>\n";
			$res=$res."<UL id=\"subDiv$counter\" style=\"display:none\">\n";
			$res=$res.$tmp."</UL>\n";
		}
	}
	
	$res=$res."</UL>\n";
	
	db_disconnect($db);
	
##	$res=$res.$SQL;
	
	return $res;
}

sub get_left_row
{
	return get_catalog(1);  
}

1;