#!/bin/perl
#入力:2ファイル(比較したい2種類のバージョンそれぞれのコンフィグ)
#出力:


#use strict;
#use warnings;
use utf8;
use Text::Diff;
use File::Basename;
use Encode;
use Algorithm::Diff;

$OLDER_PATH = $ARGV[0];
$NEWER_PATH = $ARGV[1];

$OLDER_NAME = basename $OLDER_PATH;
$NEWER_NAME = basename $NEWER_PATH;

# Create directories needed.
mkdir "${OLDER_NAME}_DIR" if ( !-d "${OLDER_NAME}_DIR" );
mkdir "${NEWER_NAME}_DIR" if ( !-d "${NEWER_NAME}_DIR" );
mkdir "${OLDER_NAME}-${NEWER_NAME}_DIFF_DIR" if ( !-d "${OLDER_NAME}-${NEWER_NAME}_DIFF_DIR" );


# Read the older conf and the newer one.
open OLDER,"<$OLDER_PATH" or die ("The older configuration was not read correctly.");
open NEWER,"<$NEWER_PATH" or die ("The newer configuration was not read correctly.");


### Blocks Separator ####################################################################
#											#							#
#  This Section is a separator that clips top-level-blocks from the older and the newer #
#  one #respectively to each files point by point.					#
#  The files generated are stored at "${NEWER_NAME}_DIR" for the newer conf		#
#  and "${OLDER_NAME}_DIR" for the older# one likewise.					#
#											#
#########################################################################################

### Separate each top-level-blocks to files from  the older and the newer one, which is used to HANDLER.
&OUTPUT(OLDER);
&OUTPUT(NEWER);
&DIFF;

sub OUTPUT{	#Conf Separator
	$HANDLER = $_[0];
	if( 'OLDER' eq $HANDLER ){ $STORE_DIR = "${OLDER_NAME}_DIR"; }
	if( 'NEWER' eq $HANDLER ){ $STORE_DIR = "${NEWER_NAME}_DIR"; }

	$flg=0;
	while(<$HANDLER>){
		chomp $_;
			if ( $_ =~/^config\s(.*)$/ ){
				$flg=1;
				$blockname=$1;
				open OUTPUT,">./$STORE_DIR/$blockname";
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



### DIFF ################################################################################
#											#
#	This Section is a generator that do diff between the older and the newer one.	#
#	The results are stored at a dir "${OLDER_NAME}-${NEWER_NAME}_DIFF_DIR".		#
#											#
#########################################################################################

sub DIFF{	#DIFF files generator
	my %hash=();
	my @samename_blocks = ( glob("${OLDER_NAME}_DIR/*"), glob("${NEWER_NAME}_DIR/*") );
	$hash{ basename($_) }++ for( @samename_blocks );

	while( my ($key, $val) = each %hash ){
        	if( $val == 2){
			my $older_diff = "./${OLDER_NAME}_DIR/$key";
			my $newer_diff = "./${NEWER_NAME}_DIR/$key";
			my $diff = diff $older_diff, $newer_diff, { STYLE => 'OldStyle' };
			
			open DIFF,">./${OLDER_NAME}-${NEWER_NAME}_DIFF_DIR/$key";
			print DIFF "$diff";
			close(DIFF);
		}
	}
}


exit 0;
