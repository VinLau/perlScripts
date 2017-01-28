#!/usr/bin/perl

use DBI;
use Cwd;
use strict;
use warnings;

my ($cwd, $file, @gbFiles, $rawData, @rawGB, @sqlQueryArray, @attributes, $attriAns);
my @attributeTemplate = ("URL", "LOCUS", "DEFINITION", "ACCESSION", "VERSION", "KEYWORDS", "SOURCE", "FEATURES", "ORIGIN");
my $baseURL = "https://www.ncbi.nlm.nih.gov/nuccore/";
my ($DBMS, $driver, $dataBase, $dataBaseConnect, $userid, $passwd, $dbh);
my ($tableName, $sqlCreate, $sqlInsertBaseFirst, $sqlInsertBaseSecond, $sqlInsert, $rv, $sth );
my $primaryID = 1;

print <<__END__;
\nWelcome to the automated GenBank Database and Table Generator, made by Vincent Lau 2017!\n
This tool will be useful to automate input of certain fields of NCBI (nucleotide/genBank) records, please note the below dependencies\n
1. You will need to know your type of DBMS you're using (SQLite, MySql, etc.), this script was tested with SQLite3, not all may be supported by DBI\n
1.1 If you enter your own database you may need to change the data types in the script (for example, INT is not qualified in Oracle)\n
2. You will need to have the DBI module installed (a core module that is included in some Perl installations)\n
3. You will be prompted to declare the fields of the record you wish to extract from the GenBank record\n
4. Rarely, certain GenBank (.gb) files will contain keywords which will misidentify the REGEX parse, so go take a few scans at the table created\n
5. A solution to the above is to use a BioPerl module (Bio::SeqIO) which has lengthy documentation online. However, this alone will not create a database\n
6. You will need to have your GenBank (.gb) files in the same folder as this script and you should only have one .gb for each sequence\n\n
NB: If you have a list of accession numbers or GIs that you wish to parse then I suggest using 'Batch Entrez' to retrieve the records (tutorials online)\n
__END__

print "Please enter your database, select 1 for SQLite, 2 for MySQL, or alternatively type your own DBMS: ";
chomp($DBMS = <STDIN>);
if ($DBMS eq "1"){
   $driver = "SQLite";
}
elsif ($DBMS eq "2"){
   $driver = "mysql";
}
else{
   $driver = $DBMS;
}

print "\nEnter the database user ID: ";
chomp($userid = <STDIN>);

print "\nEnter the database password: ";
chomp($passwd = <STDIN>);

print "\nEnter your database name: ";
chomp($dataBase = <STDIN>);
$dataBase .= ".db";

print "\nEnter your table name: ";
chomp($tableName = <STDIN>);

print "\nNow lastly you be prompted for each field of the GenBank record that you would like to extract\n\n";
foreach (@attributeTemplate){
   print "Would you like to add column $_ to your table? Enter 'y' to confirm: ";
   chomp($attriAns = <STDIN>);
   if (lc($attriAns) eq "y"){
      push @attributes, $_;
   }
}

print "\n";

$dataBaseConnect = "DBI:$driver:dbname=$dataBase";

$cwd = getcwd();
#print $cwd; #uncomment this to check your current working directory (should be the folder in which this script is stored)

opendir (curDIR, $cwd) or die $!;

while ($file = readdir(curDIR)) { #look into current directory (DIR)
   if ($file =~ m/.*\.gb$/){
      push @gbFiles, $file;
   }
}

closedir(curDIR);

# print "@gbFiles\n"; #mid-point check

$/ = undef;

foreach my $gbItem (@gbFiles){
   print "Reading $gbItem \n";
   open(FD, "< $gbItem") || die("Error opening file... $gbItem $!\n");
   $rawData = <FD>;
   push @rawGB, $rawData;
   close(FD);
}

$/ = "\n"; #reset default record separator

# print "@rawGB done\n"; #check if raw text genBank files have been pushed correctly

for (my $i = 0; $i < scalar(@rawGB); $i++){
   for (my $j = 0; $j < scalar(@attributes); $j++){
      if ($attributes[$j] eq "ORIGIN") {
         push @sqlQueryArray, $1 while ($rawGB[$i] =~ /(ORIGIN.*\/\/)/gs);
         $sqlQueryArray[-1] =~ s/[^agct]//sg; #remove whitespace and numbers
         next;
      }
      elsif ($attributes[$j] eq "URL") {
         push @sqlQueryArray, $1 while ($rawGB[$i] =~ /ACCESSION(.*?)VERSION/gs);
         $sqlQueryArray[-1] = $1 if $sqlQueryArray[-1] =~ /(\w+)/; #remove white space and any additional accession numbers as we would get a faulty URL
         $sqlQueryArray[-1] = $baseURL . $sqlQueryArray[-1];
         next;
      }
      elsif ($attributes[$j] eq "KEYWORDS") {
         push @sqlQueryArray, $1 while ($rawGB[$i] =~ /KEYWORDS(.*?)SOURCE/gs);
         next;
      }
      elsif ($attributes[$j] eq "FEATURES") {
         push @sqlQueryArray, $1 while ($rawGB[$i] =~ /FEATURES(.*?)ORIGIN/gs);
         $sqlQueryArray[-1] =~ s/"//gs; #remove those pesky ' " ' which interfere with SQL statements
         next;
      }
      while ($rawGB[$i] =~ /${attributes[$j]}(.*?)([A-Z]){7,10}\s{2,}/gs){
         push @sqlQueryArray, $1;
         $sqlQueryArray[-1] =~ s/^\s+//gs; #remove leading whitespace
         $sqlQueryArray[-1] =~ s/"//gs; #remove those pesky ' " ' which interfere with SQL statements
         # $sqlQueryArray[-1] =~ s/\s{2,}//gs; #remove any whitespace that will likely form a new line ) #this is not needed in some databases as whitespace and newlines are not imported, included for convenience
      }
   }
}

# foreach my $item (@sqlQueryArray){ # to check if @sqlQueryArray has the corrrect fields
#    print $item, "\n";
# }

print "\n", scalar(@sqlQueryArray), " total cells will be inputed into your database (excluding primary keys)! This should be equivalent to ", scalar(@gbFiles) * scalar(@attributes);
exit if scalar(@sqlQueryArray) != (scalar(@gbFiles) * scalar(@attributes));
print "\n\nNow connecting to Database\n\n";

sleep(2);

$dbh = DBI->connect($dataBaseConnect, $userid, $passwd, { RaiseError => 1 })
	    or die $DBI::errstr;
print "Successfully Opened database...\n";

$dbh->do("DROP TABLE IF EXISTS $tableName") or die $DBI::errstr;

$sqlCreate = qq/CREATE TABLE $tableName (ID INT PRIMARY KEY NOT NULL, /;
foreach my $columnName (@attributes){
   $sqlCreate .= "$columnName TEXT NOT NULL,";
}
chop $sqlCreate; #remove that last comma which will mess up the SQL statement
$sqlCreate .= ");";

print "\n$sqlCreate\n";

$rv = $dbh->do($sqlCreate); #insert table statement
if($rv < 0) {
   print $DBI::errstr;
}
else {
   print "\nSuccessfully Created Table...\n\n";
}

# We will run this for loop until all entries are filled in the DB, however we will increment this by the number of attributes/columns(excluding the ID) per row

$sqlInsertBaseFirst = qq/INSERT INTO $tableName (ID,/; #Initializing the INSERT statement, recall the typical INSERT statement is INSERT INTO <TABLENAME> (COLUMN1, COLUMN2) VALUES ("lol", "kek");
foreach my $column (@attributes){
   $sqlInsertBaseFirst .= "$column,";
}
chop $sqlInsertBaseFirst; #remove that last comma which will mess up the SQL statement


for (my $k = 0; $k < scalar(@sqlQueryArray); $k = $k + scalar(@attributes)){ #a for loop to add each row
   $sqlInsertBaseSecond = $sqlInsertBaseFirst;
   $sqlInsertBaseSecond = $sqlInsertBaseFirst . ") VALUES (" . $primaryID . ",";
   $sqlInsert = $sqlInsertBaseSecond;
   for (my $l = 0; $l < scalar(@attributes); $l++) { # a for loop to add each item in that row
      $sqlInsert .= qq/"$sqlQueryArray[$k + $l]",/;
   }
   chop $sqlInsert; #remove that last comma which will mess up the SQL statement
   $sqlInsert .= ");";
   $sth = $dbh->prepare($sqlInsert) or die $DBI::errstr;
   $sth->execute( ) or die $DBI::errstr;
   $sth->finish( ) or die $DBI::errstr;
   $primaryID++;
}

print "-----------------------------------------------------------\n\n";
print "Table Insertion Complete!";
