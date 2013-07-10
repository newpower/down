#!/usr/bin/perl -w
##
## k_USEFULL - файл, в котором собраны все полезные функции
##

## Декодируем параметр
sub URLDecode {my $s = shift; $s =~tr /+/ /; $s =~s /%([0-9A-Fa-f]{2})/chr(hex($1))/esg; return $s};

## Разбираем парамеры и возвращаем в виде хэша
sub get_params
{
	my $data="";
	my %res=();
	if (exists($ENV{'CONTENT_LENGTH'})) {read(STDIN,$data,$ENV{'CONTENT_LENGTH'});}
	
	$data=~s /(\x0d\x0a)|(\x0a\x0d)/\n/sg;

	my @pairs = split(/[\?\&\;]/,$data);
	foreach (@pairs) 
	{
		my ($param, $value) = split('=', $_, 2);
		next unless $param && $value;
		%res=(%res,URLDecode($param),URLDecode($value));
	}
	return %res;
}

## Получить id конкретного пользователя из параметров $ENV
sub get_client_id
{
	my ($g3tz,$cr,$auth0z);
	foreach $g3tz ($ENV{"REMOTE_ADDR"}, $ENV{"HTTP_USER_AGENT"}, $ENV{"HTTP_ACCEPT_LANGUAGE"}, $ENV{"HTTP_HOST"})
	{
		foreach $cr (split("", $g3tz))
		{
			$auth0z+= ord($cr);
		}
	}
	return $auth0z;
}

## Функция - аналог Trim в C++
sub trim 
{
    my($string)=@_;
    for ($string)
    {
        s/^\s+//;
        s/\s+$//;
    }
    return $string;
}

## Функция - аналог Addslashes в PHP
sub AddSlashes
{
    my $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    #$text =~ s/#/\\#/g;
    return $text;
}

## Функция - обратная Addslashes
sub DelSlashes
{
    my $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\\\0/\\0/g;
    $text =~ s/\\"/"/g;
    $text =~ s/\\'/'/g;
    $text =~ s/\\\\/\\/g;
    #$text =~ s/#/\\#/g;
    return $text;
}

1;