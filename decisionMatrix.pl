#!/usr/bin/perl
use strict;
use warnings;

my ($flag1, $flag2) = (1, 1);
my ($i, $j, $k) = (0, 0, 0);
my (@factors, @weights, @choices, @scores);

print "Welcome to the weighted decision matrix builder \n\n";
print "This tool will help you make a decision by taking considerations of varying importance and allowing you rank them for each decision\n";
print "Although this tool is used for helpful for making difficult decisions, it should not be the only tool you consult \n\n";
print "Please acknowledge that you are ultimately responsible for your own actions and consequences thereof, I bear no responsibility for your future \n\n";

print "Enter the major decision that needs to be made (ie name it): \n";
chomp(my $decision = <STDIN>);
print "Now enter factors that you consider to be important to that decision: \n";
while ($flag1 == 1){
   print "Enter factor ", $i + 1, " enter 'done' when you have entered all factors: ";
   chomp($factors[$i] = <STDIN>);
   if ($factors[$i] eq "done"){
      pop @factors;
      $flag1 = 0;
   }
   $i++;
}

print "Now you will assign a weight between 1 to 10 (10 being most important) to each factor \n";
foreach my $item (@factors){
   print "What is the importance of $factors[$j] from 1 to 10? ";
   chomp($weights[$j] = <STDIN>);
   redo if $weights[$j] > 10 || $weights[$j] < 1;
   $j++;
}

print "Now enter the potential choices to $decision \n";
while ($flag2 == 1){
   print "Enter choice ", $k + 1, " enter 'done' when you have entered all factors: \n";
   chomp($choices[$k] = <STDIN>);
   if ($choices[$k] eq "done"){
      pop @choices;
      $flag2 = 0;
   }
   $k++;
}

print "Now lastly, we will ask you to assign a value (1 to 10) for each factor respective to each choice:\n";
print "For example, if you wanted to decide on a job position and the salary differed between job A and job B, then you would rank them accordingly \n";
for (my $l = 0; $l < scalar(@choices); $l++){
   for (my $m = 0; $m < scalar(@weights); $m++){
      print "What is the value from 1 to 10 of ", $factors[$m], " with respect to ", $choices[$l], "? ";
      chomp(my $value = <STDIN>);
      redo if $value > 10 || $value < 1;
      $scores[$l][$m] = $value * $weights[$m]; #2d array whereby the first array is the choice and second array are the list of calculated values to each choice
   }
}

print "\n\n\t\t Your decision matrix output to $decision\n\n\t\t";
foreach (@choices){
   print " $_ ";
}

print "\n";
for (my $n = 0; $n < scalar(@factors); $n++){
   print $factors[$n], " " x (18 - length($factors[$n])) ;
   for (my $o = 0; $o < scalar(@choices); $o++){
      print " " x ((length($choices[$o]))/2 - 1) , $scores[$o][$n], " " x ((length($choices[$o]))/2 - 1);
   }
   print "\n";
}
print "Total", " " x 13;
for (my $p = 0; $p < scalar(@choices); $p++){
   print " " x (length($choices[$p])/2 - 1), sum(@{$scores[$p]}), " " x (length($choices[$p])/2 - 1);
}

sub sum
{
   my $s = 0;
   foreach (@_) {
      $s += $_;
   }
   return $s;
}
