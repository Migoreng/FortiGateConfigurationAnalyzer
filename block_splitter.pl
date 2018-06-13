#!/bin/perl
#入力:2ファイル(比較したい2種類のバージョンそれぞれのコンフィグ)
#出力:


#use strict;
#use warnings;
use utf8;
use Text::Diff;
use File::Basename;
use Encode;

#mkdir 'OLDER', 0755 or die $!;
#mkdir 'NEWER', 0755 or die $!;

$OLDER_PATH = $ARGV[0];
$NEWER_PATH = $ARGV[1];
$DIFF_switch= 0 if ( !$ARGV[2] );

#各コンフィグファイルを読み込む
open OLDER,"<$OLDER_PATH" or die ("The older configuration was not read correctly.");
open NEWER,"<$NEWER_PATH" or die ("The newer configuration was not read correctly.");

&OUTPUT(OLDER);
&OUTPUT(NEWER);



sub OUTPUT{
	$HANDLER=$_[0];
	$flg=0;
	while(<$HANDLER>){
		chomp $_;
			if ( $_ =~/^config\s(.*)$/ ){
				$flg=1;
				$blockname=$1;
				open OUTPUT,">./$HANDLER/$blockname";
			}
		if ( $flg == 1 ){
			print OUTPUT "$_\n";
		}

		if ( $_=~m/^end$/){
			print OUTPUT "$_";
			close(OUTPUT);
			$flg=0;
		}
	}
}



## diff ##
$DIFF_switch = 1; #Only For Debugging.
if( $DIFF_switch != 1 ){ exit; } #DIFF_switchが1でなければここで終了。

#mkdir './DIFF', 0755 or die $!;

# Get the lists of those files in both OLDER and NEWER to use glob().
@glob_NEWER_list = glob("./NEWER/*");
@glob_OLDER_list = glob("./OLDER/*");

open TMP,">./OLDERtoDIFF";
foreach my $glob_OLDER_list (@glob_OLDER_list) {
	my $filename_OLDER = basename($glob_OLDER_list);
	print TMP "$filename_OLDER\n";
}
close(TMP);
undef @glob_OLDER_list;

open TMP,">./NEWERtoDIFF";
foreach my $glob_NEWER_list (@glob_NEWER_list) {
	my $filename_NEWER= basename($glob_NEWER_list);
	print TMP "$filename_NEWER\n";
}
close(TMP);
undef @glob_NEWER_list;

print encode('utf-8',"処理が完了しました。\n");
#	my $block_diff = diff OLDERtoDIFF, NEWERtoDIFF,{STYLE => "OldStyle"};

exit 0;
