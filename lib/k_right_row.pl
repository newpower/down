#!/usr/bin/perl -w
##
##  k_right_row - גûגמה ןנאגמדמ סעמכבצא
##

sub get_ENV
{
	my $res="";
	foreach $var (sort(keys(%ENV))) {
	    $val = $ENV{$var};
	    $val =~ s|\n|\\n|g;
	    $val =~ s|"|\\"|g;
	    $res=$res."<B>${var}</B>=\"${val}\"<br>\n";
	}
	return $res;
}

sub get_right_row
{
	return get_ENV();
}

1;