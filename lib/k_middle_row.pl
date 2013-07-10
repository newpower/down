#!/usr/bin/perl -w
##
## k_middle_row - вывод центральной части
##

require "../lib/k_DB.pl";
require "../lib/k_USEFULL.pl";

sub get_data
{
	my $cursor = substr($ENV{REQUEST_URI},0,6);
	my $page = substr($ENV{REQUEST_URI},6,3);
	my $sort_var = substr($ENV{REQUEST_URI},9,1);
	if ($sort_var !=~/\+|\-|\*/) {$sort_var='-';}
	my $catalog=substr($ENV{REQUEST_URI},10,index($ENV{REQUEST_URI},'.html')-10);
	my $i=0;
	my $n=0;
	my $tov_cat="";
	my $group_name="";
	my $res="";
	my $SQL="";
	my @mass="";
	my @mass2="";
	
	my $db=db_connect();
	
	if ($cursor eq '/shop-')
	{
		$SQL="SELECT `a`.`id`, `a`.`model_name`, `b`.`cost_mag1`,`a`.`inf1`,`a`.`inf2`,`a`.`inf3`,`a`.`inf4`,`a`.`inf5` FROM `catalog` AS `a` RIGHT JOIN `catalog_market` AS `b` ON `a`.`id`=`b`.`id` WHERE `a`.`catalog` LIKE '".$catalog."';";
##		$res=$res.$SQL."<BR>\n";
		
		$n=8;
		
		@mass=db_get($db,$SQL);
		
		if(scalar(@mass)>0)
		{
			$res=$res."<TABLE style='width:95%'>\n";
			
			for($i=0;$i<scalar(@mass)/$n;$i++)
			{
				$res=$res."<TR style=\"cursor: pointer\">\n";
				$res=$res."<TD>\n";
				$res=$res."<IMG src=\"/IMG/i.jpeg\" ALT=\"".$mass[$i*$n+1]."\" BORDER=0 WIDTH=50 HEIGHT=50>";
				$res=$res."</TD>\n";
				$res=$res."<TD>\n";
				$res=$res."<a href=\"../tovr-001-".$mass[$i*$n].".html\">".$mass[$i*$n+1]."</a>\n";
				$res=$res."<BR>\n";
				$res=$res.$mass[$i*$n+3]."/".$mass[$i*$n+4]."/".$mass[$i*$n+5]."/".$mass[$i*$n+6]."/".$mass[$i*$n+7]."\n";
				$res=$res."</TD>\n";
				$res=$res."<TD>\n";
				$res=$res.$mass[$i*$n+2]."\n";
				$res=$res."</TD>\n";
				$res=$res."</TR>\n";
			}
			
			$res=$res."</TABLE>\n";
		}else
		{
			$res=$res."Товар в данной категории пока отсутствует\n";
		}
		
	}elsif ($cursor eq '/tovr-')
	{
		$SQL="SELECT `a`.`model_name`, `b`.`cost_mag1`,`a`.`catalog` FROM `catalog` AS `a` RIGHT JOIN `catalog_market` AS `b` ON `a`.`id`=`b`.`id` WHERE `a`.`id`=$catalog;";
		@mass=db_get($db,$SQL);
		if(scalar(@mass)==0){db_disconnect($db); return $res;}
		##$res=$res.$SQL."<BR>\n";
	
		$tov_cat=$mass[2];
		
		$res=$res."<TABLE style='width:95%'>\n";
		$res=$res."<TR style=\"cursor: pointer\">\n";
		$res=$res."<TD>\n";
		$res=$res."<IMG src=\"/IMG/i.jpeg\" ALT=\"".$mass[0]."\" BORDER=0 WIDTH=50 HEIGHT=50>";
		$res=$res."</TD>\n";
		$res=$res."<TD>\n";
		$res=$res."<a href=\"../tovr-001-".$catalog.".html\">".$mass[0]."</a>\n";
		$res=$res."</TD>\n";
		$res=$res."<TD>\n";
		$res=$res.$mass[1]."\n";
		$res=$res."</TD>\n";
		$res=$res."</TR>\n";
		$res=$res."</TABLE>\n";
		
		$SQL="SELECT `name_field_column`, `name_column_ru`, `group_name` FROM `catalog_column` WHERE `name_catalog_translit` LIKE '".$tov_cat."' GROUP BY `group_name` ORDER BY `posledovatelnost`;";
		@mass=db_get($db,$SQL);
		if(scalar(@mass)==0){db_disconnect($db); return $res;}
		$res=$res."<BR>\n";
		
		$res=$res."<TABLE style='width:95%'>\n";
		$group_name="";
		for($i=0;$i<scalar(@mass)/3;$i++)
		{
			if($group_name ne  $mass[$i*3+2])
			{
				$res=$res."<TR align=\"center\">\n";
				$res=$res."<TD colspan=\"2\">\n";
				$res=$res."<b>".$mass[$i*3+2].":</b>\n";
				$res=$res."</TD>\n";
				$res=$res."</TR>\n";
				$group_name=$mass[$i*3+2];
			}
			
			$SQL="SELECT `".$mass[$i*3+0]."` FROM `catalog` WHERE `id`=".$catalog.";";
			@mass2=db_get($db,$SQL);
			
			$res=$res."<TR>\n";
			$res=$res."<TD width=45%>\n";
			$res=$res.$mass[$i*3+1]."\n";
			$res=$res."</TD>\n";
			$res=$res."<TD width=45%>\n";
			$res=$res.$mass2[0]."\n";
			$res=$res."</TD>\n";
			$res=$res."</TR>\n";	
		}
		
		$res=$res."</TABLE>\n";

	}elsif ($cursor eq '/bask-')
	{
		
	}
	
	db_disconnect($db);
	
	return $res;
}

sub get_middle_row
{
	return get_data();
}

1;