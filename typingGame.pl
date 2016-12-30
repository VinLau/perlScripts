#!/usr/bin/perl
use strict;
use warnings;

my %chars = (0 => " ", 1 => "A", 2=> "B", 3=>"C", 4 => "D", 5=> "E", 6=> "F", 7=> "G", 8=> "H", 9 => "I", 10 => "J", 11 => "K", 12 => "L", 13 => "M",
14 => "N", 15 => "O", 16 => "P", 17 => "Q", 18 => "R", 19 => "S", 20 => "T", 21 => "U", 22 => "V", 23 => "W", 24 => "X", 25 => "Y", 26=> "Z");
my $flag1 = my $flag2 = 1;
my $globDiff;

while ($flag1 == 1){
   print "Welcome to this typing game, caps lock is recommended, please enter your desired difficulty level (1-10):\n";
   chomp(my $diff = <STDIN>);
   if ($diff >= 1 && $diff <= 10){
      $flag1 = 0;
   }
   $globDiff = $diff;
}

while ($flag2 == 1){
   my $testString = "";
   my ($len, $time);
   my $score = my $subScore = my $perID = 0;
   for (my $i = 0; $i < ($globDiff * 10); $i++ ){
      $testString .= $chars{int(rand(27))};
   }
   for (my $j = 3; $j > 0; $j --){
      sleep(1);
      print "Counting down.. $j\n";
      print "Go!\n" if $j == 1;
   }
   print $testString, "\n";
   my ($sec1,$min1,$hour1,$mday1,$mon1,$year1,$wday1,$yday1,$isdst1) = localtime(time);
   chomp(my $answer = <STDIN>);
   my ($sec2,$min2,$hour2,$mday2,$mon2,$year2,$wday2,$yday2,$isdst2) = localtime(time);
   print "Your answer was $answer\n";
   print "Your score will be composed of the time it took to complete the challenge, difficulty and accuracy (perfect or adjacent alignment)\n";
   if (length($answer) <= length($testString)){
      $len = $answer;
   }
   elsif (length($answer) > length($testString)){
      $len = $testString;
   }
   print "$len \n";
   for (my $k = 0; $k < length($len); $k++){
      if (substr($testString, $k, 1) eq substr($answer, $k, 1)){
         $subScore += 2;
         $perID +=1;
      }
      elsif (substr($testString, $k, 1) eq substr($answer, $k-1, 1) || substr($testString, $k, 1) eq substr($answer, $k+1, 1)){
         $subScore += 1;
      }
   }
   if ($hour1 == $hour2){
      $score = 100 - (($min2*60 + $sec2) - ($min1*60 + $sec1)) + $globDiff * 10 + $subScore;
      $score = 0 if $score < 0;
      $time = (($min2*60 + $sec2) - ($min1*60 + $sec1));
   }
   if ($hour2 > $hour1){
      $score = 100 - ((((60 + $min2)*60) + $sec2) - ($min1*60 + $sec1)) + $globDiff * 10 + $subScore;
      $score = 0 if $score < 0;
      $time = ((((60 + $min2)*60) + $sec2) - ($min1*60 + $sec1));
   }
   print "Your Score is $score, with a time of a $time seconds and percent identity (alignment) of ", $perID/(length($testString)) * 100, "% \n";
   print "Enter Y if you wish to play again\n";
   chomp(my $playAgain = <STDIN>);
   if ($playAgain ne "Y"){
      $flag2 = 0;
   }
}
