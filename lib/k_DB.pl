#!/usr/bin/perl -w
##
##  k_DB - все функции для работы с базами данных
##
use DBI;

## Подключаемся к базе
sub db_connect
{
	return DBI->connect("DBI:mysql:grabber;host=192.168.136.135:3306","root", "280286") || die $DBI::errstr;
}

## Отключаемся от базы
sub db_disconnect
{
	$_[0]->disconnect();
}

## Положить в базу/изменить в базе: $_[0]=$dbh; $_[1]=sql-запрос;
sub db_put
{
	my $rs=$_[0]->do($_[1]);

	return $rs;
}

## Получить из базы: $_[0]=$dbh; $_[1]=sql-запрос;
sub db_get
{
	my @arr=();
	my $sth = $_[0]->prepare($_[1]);
	$sth->execute;

	while (my @tmp=$sth->fetchrow_array)
	{
		@arr=(@arr,@tmp);
	}
	$sth->finish();

	return @arr;
}

## Положить в базу/изменить в базе единоразово: $_[0]=sql-запрос;
sub db_put_once
{
	my $dbh=db_connect;

	my $rs=$dbh->do($_[0]);
	db_disconnect($dbh);

	return $rs;
}

## Получить из базы единоразово: $_[0]=sql-запрос;
sub db_get_once
{
	my $dbh=db_connect;

	my @arr=();
	my $sth = $dbh->prepare($_[0]);
	$sth->execute;

	while (my @tmp=$sth->fetchrow_array)
	{
		@arr=(@arr,@tmp);
	}

	$sth->finish();
	db_disconnect($dbh);

	return @arr;
}

1;