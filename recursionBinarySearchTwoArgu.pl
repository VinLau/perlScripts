#!/usr/bin/perl

use strict;
use warnings;

sub recursiveBinarySearch($$);

my (@array1, @array2, $rv, $i);
my ($num1, $num2, $string1, $string2) = (22, 9999, "KEK", "ROFL");
@array1 = (1000, 250, -50, 22, 1, 90902, 252, 25, 150, -502, -10, 2525, 900, 900, 150, -1535, 1241, 8235, 242);
@array1 = sort {$a <=> $b} @array1;
@array2 = qw(Apple APPLE APPle LOL KEK LMAO EMOJI DUBSTEP Science Transcription Nature Inorganic JavaScript Go Lua Meditate Millennial);
@array2 = sort {$a cmp $b} @array2;

print "@array1\n";
print "@array2\n";

# test number search
$i = 0;
$rv = recursiveBinarySearch(\@array1, $num1);
print "binary search complete... Item $num1 ", ($rv == -1) ? "NOT " : "", "FOUND. Index: $rv This took $i iterations\n";
$i = 0;
$rv = recursiveBinarySearch(\@array1, $num2);
print "binary search complete... Item $num2 ", ($rv == -1) ? "NOT " : "", "FOUND. Index: $rv This took $i iterations\n";

# test string search
$i = 0;
$rv = recursiveBinarySearch(\@array2, $string1);
print "binary search complete... Item $string1 ", ($rv == -1) ? "NOT " : "", "FOUND. Index: $rv This took $i iterations\n";
$i = 0;
$rv = recursiveBinarySearch(\@array2, $string2);
print "binary search complete... Item $string2 ", ($rv == -1) ? "NOT " : "", "FOUND. Index: $rv This took $i iterations\n";

sub recursiveBinarySearch($$) {
   my ( $arrayRef, $value ) = @_;
   my (@tempArray);
   my $high = scalar(@$arrayRef) - 1;
   my $mid = int(scalar(@$arrayRef) / 2);

   my $operatorEq = ' == '; #default operators assuming the array is filled with numbers
   my $operatorGr = ' > ';
   my $operatorLess = ' < ';
   if ($arrayRef -> [$mid] =~/[a-zA-Z]/){ #check if the mid value (which should always exist) is a string (contains any letters), if so convert the operators
      $operatorEq = ' eq ';
      $operatorGr = ' gt ' ;
      $operatorLess = ' lt ';
   }

   # print $high, " HIGH \n"; #If You ever wish to understand how the binary search is working uncomment these
   # print $mid, " MID \n";
   # print "@$arrayRef ARRAY \n";

   # the eval (EXPR) function ('string eval') lets perl interpreter execute the string as if it were a "little Perl program", hence we can allow for numeric and string operators (we would get an error if we directly put a scalar inbetween the two values)

   if ( eval('$arrayRef -> [$mid]' . $operatorEq . '$value')) { #base case, if you find the value you are looking for!
      $rv = $mid;
   }

   elsif (scalar(@$arrayRef) == 1){ #base case, if you DONT find the value you're looking for (because we already verified it in the earlier 'if')!
      $rv = -1;
   }

   elsif ( eval('$value' . $operatorLess . '$arrayRef -> [$mid]')){ #mid is greater than value
      @tempArray = @$arrayRef[0 .. ($mid - 1)]; #take the smaller portion of the array (1st half), put it in an a temporary array so we dont lose integrity
      $rv = (recursiveBinarySearch(\@tempArray, $value));
   }

   elsif ( eval('$value' . $operatorGr . '$arrayRef -> [$mid]')){ #mid is less than value
      @tempArray = @$arrayRef[($mid + 1) .. $high]; #take the greater portion of the array (2nd half), put it in an a temporary array so we dont lose integrity
      $rv = (recursiveBinarySearch(\@tempArray, $value));
      $rv = ($rv + $mid + 1) if $rv >= 0 ; #we need this line of code as we have sliced the left hand side of the array during recursive calls so the indexing has been compromised, fortunately when the return executes we can slowly build the integrity of the array (at least until we get the index)
   }
   # print $rv, " return value \n"; #If You ever wish to understand how recursion and the call stack works (with respect to a binary search especially) uncomment this
   $i++;
   return $rv;
}
