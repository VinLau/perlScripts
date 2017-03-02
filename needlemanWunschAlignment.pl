use strict;
use warnings;
use Bio::DB::GenBank;

my ($s1, $s2, $m, $n, @NWTable, $x, $y, $gapPenalty, $match, $misMatch, $alignScore, $gb, $GB1, $GB2);
$gb = Bio::DB::GenBank->new();

print "Please enter your first GenBank Accession.Version (example: 'KJ901976.1'), if you have your own sequence simply type it in: \n";
chomp($GB1 = <STDIN>);
if ($GB1 =~ m/[0-9]/) { #i.e. test if this is a accession number or a DNA string (accession numbers always have numbers)
   $s1 = $gb->get_Seq_by_version($GB1);
   $s1 = $s1->seq; #resassign the seq IO object to be a string
}
else{
   $s1 = $GB1;
}

print "Please enter your second GenBank Accession.Version (example: 'KJ901976.1'), if you have your own sequence simply type it in: \n";
chomp($GB2 = <STDIN>);
if ($GB2 =~ m/[0-9]/) { #i.e. test if this is a accession number or a DNA string (accession numbers always have numbers)
   $s2 = $gb->get_Seq_by_version($GB2);
   $s2 = $s2->seq; #resassign the seq IO object to be a string
}
else{
   $s2 = $GB2;
}

print "Now enter the algorithm parameters for the Needleman Wunsch alignment\n";

print "The match score (should be positive, default will be 2):";
chomp ($match = <STDIN>);
if ( !($match =~ m/^[0-9]+$/) ){
   $match = 2;
}

print "The misMatch score (should be negative, default will be -1):";
chomp ($misMatch = <STDIN>);
if ( !($misMatch =~ m/^[0-9]+$/) ){
   $misMatch = -1;
}

print "The gapPenalty score (should be negative, default will be -2):";
chomp ($gapPenalty = <STDIN>);
if ( !($gapPenalty =~ m/^[0-9]+$/) ){
   $gapPenalty = -2;
}

$m = length($s1); #this is the horizonstal strand, 9 chars long ACTGATTCA
$n = length($s2); #This is the vertical strand, 8 chars long    ACGCATCA

$NWTable[0][0] = 0;

for($x = 1; $x < $m + 1; $x++) {  #rows  # fill first row and first column (excluding 0,0) with gapPenalty
   $NWTable[0][$x] = $gapPenalty * $x;   # because boundaries would cause formula to generate default result
}
for($y = 1; $y < $n + 1; $y++) { #columns
   $NWTable[$y][0] = $gapPenalty * $y;
}

sub max($$$$$);
sub S($$);

print "$x and $y will be reset to 1 and 1\n\n\n"; #10 and 9 by default
$x = 1;
$y = 1;

foreach (@{$NWTable[0]}) { #populate the first row (i.e. the gap scores across the y axis)
   printf '{%5s}', $_;
   print " ";
}

print "\n";

printf '(%5s)', $gapPenalty; # 0,0 cell
print " ";

#As we have already populated 0,0 and the gap penalty data cells we should only have to do m * n comparisons, therefore the for loop should be $i < ($m * $n)
for (my $i = 0; $i < ($m * $n); $i++) {
   $NWTable[$y][$x] = max($y,$x,\@NWTable, $s1, $s2);
   printf '<%5s>', $NWTable[$y][$x];
   print " ";
   $alignScore = $NWTable[$y][$x] if ( $i == ($m * $n - 1) ) ; #bottom right corner number
   $x++;
   if ($x % ($m+1) == 0){ # When you complete a row you need to reset the 'column' position and print a new line and also increment to begin at the second row.
      $x = 1;
      $y++;
      print "\n";
      unless ($y > $n) {
         printf '[%5d]', $NWTable[$y][0];
         print " ";
      }
   }
}

print $alignScore, " is the corner/score which you begin your traceback";

sub max($$$$$) { # use this subroutine to determine the value of an array cell
   my ($rowCord, $colCord, $arrayRef, $seq1, $seq2) = @_; #less verbose than shifting off each parameter
   my @workingArray = @$arrayRef;
   my $returnCell;
   my $diag   = $workingArray[$rowCord - 1][$colCord - 1] + S(substr($seq1, ($colCord - 1), 1),substr($seq2, ($rowCord - 1), 1)); # we take 1 off the offset as we shifted the sequences in the table
   # print "DIAG is $diag at $y and $x\n\n";
   my $left   = $workingArray[$rowCord][$colCord - 1] + $gapPenalty;
   # print "LEFT is $left at $y and $x\n\n";
   my $up     = $workingArray[$rowCord - 1][$colCord] + $gapPenalty;
   # print "UP is $up at $y and $x\n\n";
   if ( ($diag >= $left) && ($diag >= $up) ){
      $returnCell = $diag;
   }
   elsif( ($left >= $diag) && ($left >= $up) ){
      $returnCell =  $left;
   }
   else{
      $returnCell = $up;
   }
   return $returnCell;
}

sub S($$) {
   my $matchReturn;
   $matchReturn = $match    if $_[0] eq $_[1];
   $matchReturn = $misMatch if $_[0] ne $_[1];
   return $matchReturn;
}
