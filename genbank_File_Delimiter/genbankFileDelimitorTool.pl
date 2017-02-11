#!/usr/bin/perl

use strict;
use warnings;

{
my ($sequenceFile, $rawGBstring, @fileArray);

$sequenceFile = $ARGV[0];

$/ = undef;

open(FD, "< $sequenceFile") || die("Error opening file... $!\n");
$rawGBstring = <FD>;
close(FD);

$/ = "\n";

$rawGBstring =~ s/\n\n$//; #We need to remove the last record's newlines as they will interfere with the split function

@fileArray = split("//", $rawGBstring);

foreach (@fileArray){
   $_ =~ s/^\n\n//; #when you download a bunch of genbank files from NCBI they put 2 newlines to delimit between records,
   $_ .= "\/\/" #restoring the integrity of the Origin field
}

foreach (@fileArray) {
   my $fileName = $1 if ($_ =~/ACCESSION(.*?)VERSION/gs);
   $fileName =~ s/\s//g;
   $fileName .= ".gb";
   open (OUT, "> $fileName") || die("Cannot write to file $fileName");
      print OUT $_; #printing the split genbank record
   close (OUT) || die("Could not properly close $fileName");
}

}
