
 # Functional style
 use Digest::MD5 qw(md5_hex);
use File::Basename;  
	my $upload_dir = "E:\\webserver\\home\\localhost\\cgi-bin\\mag\\panel\\upload";
	
	
# $digest = md5($data);
# $digest = md5_hex($data);
# $digest = md5_base64($data);
 # OO style
 #use Digest::MD5;
 #$ctx = Digest::MD5->new;
 #$ctx->add($data);


 open (FILE, "1.txt" ) or die $text=$text."NO cant create files";
 binmode(FILE);

 print Digest::MD5->new->addfile(*FILE)->hexdigest, " file\n";
 

			
 
 
 
#$md5 = Digest::MD5->new;
#    while (<FILE>) {
#        $md5->add($_);
#    }
#    close(FILE);
#    print $md5->md5_hex, " file\n";
	
	
sub add_file_to_exchange_files
{
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
	my $filename=$$doc_info{file_upload};
	
	my $safe_filename_characters = "a-zA-Z0-9_.-";  
	my $text;
	my $ret_otvet;
	my $md5 = Digest::MD5->new;
	my $str2;
	
	if ($filename )  
	{
		my ( $name, $path, $extension ) = fileparse ( $filename, '\..*' );
			$filename = $name . $extension;
			$filename =~ s/[^$safe_filename_characters]//g;
			if ( $filename =~ /^([$safe_filename_characters]+)$/ )
			{
				$filename = $1;
				my $upload_filehandle = $$doc_info{file_upload};
				
				while ( <$upload_filehandle> )
				{
					#		print UPLOADFILE;
					$str2 =$str2.$_;
					$md5->add($_);
				}
				my %hash_dopik;
				$hash_dopik{md5_files}=$md5->md5_hex;
				if (seach_hash_files($varn,$data_user,\%hash_dopik)
				{
				
				}
			
			}
			else
			{
				$text=$text."Название файла имеет неправильный формат или содержит недопустимые символы!!";
			}
	}
	else
	{
		$text=$text."Не задан файл, повторите попытку!!";
		
	}
	
}
 
sub seach_hash_files
{
	my $varn=$_[0];
	my $data_user=$_[1];
	my $doc_info=$_[2];
	
my ($fol51,$hhs51) = &get_query($$varn{dbh},"SELECT `id` FROM `contragent_price` where `kontragent_ot` like '".$mycgi->param("kontragent_ot")."' and `autor` = '".$$data_user{login}."' order by `id` desc limit 0,1","hash","pr");
								
	
}

1;