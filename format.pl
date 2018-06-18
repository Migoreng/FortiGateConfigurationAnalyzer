#!/usr/bin/perl

our $PATH = $ARGV[0];

if($PATH =~ /^ADD_.+$/){
  $PATH =~ m/^ADD_(.+)-(.+)$/;
  my $prev = $1;
  my $late = $2;
  open READ,"$PATH" or die "format.pl could not read $PATH";
  open WRITE,">FOREXCEL_ADD_$PATH" or die "format.pl could not write FOREXCEL_$PATH";
    while(my $_ = <READ>){
      open BLOCK,"./${late}_DIR/$_" or die "format.pl could not read blocks";
        while(my $block = <BLOCK>){
          chomp $block;
          print WRITE"=ROW(),追加,$block\n";
        }
    }
  close(READ);
  close(WRITE);
}

if($PATH =~ /^DEL_.+$/){
  $PATH =~ m/^DEL_(.+)-(.+)$/;
  my $prev = $1;
  my $late = $2;
  open READ,"$PATH" or die "format.pl could not read $PATH";
  open WRITE,">FOREXCEL_DEL_$PATH" or die "format.pl could not write FOREXCEL_$PATH";
    while(my $_ = <READ>){
      open BLOCK,"./${prev}_DIR/$_" or die "format.pl could not read blocks";
        while(my $block = <BLOCK>){
          chomp $block; 
          print WRITE"=ROW(),削除,$block\n";
        }
    }
  close(READ);
  close(WRITE);
}

if($PATH =~ /^DIFF_(.+)-(.+)$/){
  my $prev = $1;
  my $late = $2;
  open READ,"$PATH" or die "format.pl could not read $PATH";
  open WRITE,">FOREXCEL_CHN_${PATH}" or die "format.pl could not write FOREXCEL_$PATH";
    while(my $_ = <READ>){
      open BLOCK,"${prev}-${late}_DIFF_DIR/$_" or die "format.pl could not read blocks";
      chomp $_;
      print WRITE"=ROW(),===${_}===,,\n";
      while(my $block = <BLOCK>){
        chomp $block;
        $block =~s/,//g;
        if($block =~ m/^[0-9]{1,}[,]{0,}a/){
          our $prefix='追加';
        }elsif($block =~ m/^[0-9]{1,}[,]{0,}d/){
          our $prefix='削除';
        }elsif($block =~ m/^[0-9]{1,}[,]{0,}c/){
          our $prefix='変更';
        }

        if($block =~ /^</){
          $block =~s /^<\s*//;
          print WRITE"=ROW(),$prefix,${block}\n";
        }

        if($block =~ /^>/){
          $block =~s/^>\s*//;
          print WRITE"=ROW(),$prefix,,$block\n";
        }
      }
  close(BLOCK);
    }
  close(READ);
  close(WRITE);
}
