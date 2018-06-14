# FortiGateConfigurationAnalyzer
Analyze Your Configuration File of FortiGate with those Perl scripts.  
Do you face a problem with comparing the previous version to the current one?  
Many differences make you annoyed and such working does waste your time as precious as gold.  
In fact, the other employee did leave it to me, I did take care of the working and I'm very very annoyed and confused.  
I had decided to make my convenient scripts since I hope that it'll be gone so that we'll never have a tough time of it.  
My scripts are developed under Linux enviroment, written in Perl or Bash. They are available as no warrantly but you can use/modify/distribute without copyright restrictions though.  


## To compare blocks
*block_splitter.pl  
This script requires the previous-configuration and the current one, breaks up config into each top-level-blocks, finally outputs the results of comparing them by using diff. You can obtain pieces of block files in 2 directories generated as well as "diff-done" files in another directory. The work allows you to not need to use tools/softwares such as WinMerge or DF or etc. anymore.
