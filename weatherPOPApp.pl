use strict;
use warnings;

use LWP::Simple;

my %pro = (NL => "newfoundland-and-labrador", PE => "prince-edward-island", NS => "nova-scotia ", QC => "quebec", ON => "ontario", MB => "manitoba",
SK => "saskatchewan", AB => "alberta", BC => "british-columbia", YT => "Yukon", NT => "Northwest-Territories", NU => "Nunavut");
my (@days, @POPs, @YES, $proRes, $town, $fileParse, $url, $excelAns, $weekXLS, $workbook, $worksheet, $format);
my $i = my $j = 0;
my $flag1 = 1;

while ($flag1 == 1){
   print "Please enter the province via its 2 letter abbreviation:\n";
   chomp($proRes = <STDIN>);
   redo unless defined $pro{uc($proRes)};
   $flag1 = 0;
}

print "Thank you, now enter the town/city (use a dash for two worded cities like St-Johns) :\n";
chomp($town = <STDIN>);
$url = "https://www.theweathernetwork.com/ca/weather/" . $pro{uc($proRes)} . "/$town";
$fileParse = get($url);
print "Now enter your threshold to carry an umbrella for rain between 1 and 9 where 1 is a tolerance for 10% POP and so forth: ";
chomp(my $umbRating = <STDIN>);
print "\n";
while ($fileParse =~ m/(details\s">.*?<\/div)/g){
   $POPs[$j] = $1;
   last if $j == 6;
   $j++;
}
while ($fileParse =~ m/(>[A-z]{3} [0-9]{1,2})/g){
   $days[$i] = $1;
   last if $i == 6;
   $i++;
}
foreach my $item (@days){
   $item =~ s/>//; # to remove >
}
foreach my $item (@POPs){
   $item=~ s/[^\d]*//g; # to only have workable digits leftover
}
print "\n The POP in the upcoming days in $town, ", $pro{uc($proRes)}, ": \n";
print " @days \n ";
print join("%   ", @POPs), "%\n";
foreach my $item (@POPs){
   if ($item > ($umbRating * 10)){
      print ' .^. ';
   }
}
print "\n";
foreach my $item (@POPs){
   if ($item >= ($umbRating * 10)){
      print "/_|_\\";
   }
}
print "\n";
foreach my $item (@POPs){
   if ($item >= ($umbRating * 10)){
      print "''J''";
   }
}
print "\n";
print "Print to excel worksheet? (enter 'y', all else will quit) \n";
chomp($proRes = <STDIN>);
if (uc($proRes) eq "Y"){
   require Spreadsheet::WriteExcel;
}
else{
   exit;
}
$weekXLS = $town . $days[0] . "_" . $days[6] . ".xls";
$workbook = Spreadsheet::WriteExcel->new($weekXLS);
$worksheet = $workbook->add_worksheet();
$format = $workbook->add_format();
$format->set_bold();
$format->set_color('red');
for (my $k = 0; $k < 7; $k++){
   $worksheet->write(0, $k, $days[$k]);
   $worksheet->write(1, $k, $POPs[$k]);
   if ($POPs[$k] >= ($umbRating * 10)){
      $worksheet->write(2, $k, "Warning", $format);
   }
}
