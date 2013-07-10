#!/usr/bin/perl -w
##
##  k_DB - ��� ������� ��� ������ � ������ ������
##
use DBI;

## ������������ � ����
sub db_connect
{
	return DBI->connect("DBI:mysql:grabber;host=192.168.136.135:3306","root", "280286") || die $DBI::errstr;
}

## ����������� �� ����
sub db_disconnect
{
	$_[0]->disconnect();
}

## �������� � ����/�������� � ����: $_[0]=$dbh; $_[1]=sql-������;
sub db_put
{
	my $rs=$_[0]->do($_[1]);

	return $rs;
}

## �������� �� ����: $_[0]=$dbh; $_[1]=sql-������;
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

## �������� � ����/�������� � ���� �����������: $_[0]=sql-������;
sub db_put_once
{
	my $dbh=db_connect;

	my $rs=$dbh->do($_[0]);
	db_disconnect($dbh);

	return $rs;
}

## �������� �� ���� �����������: $_[0]=sql-������;
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