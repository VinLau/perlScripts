# perlScripts
Some perl scripts usually (but not always) related to bioinformatics (see READ ME)
-----------------------------------------------------------------------------------------------------------------------------------------
This :octocat: repo will host a number of succinct perl scripts that will serve two purposes.   
1) Be an autodidactical tool so that I may have a reference of the process and tools (i.e. built-in functions) that solved the problem.  
2) Show others how elegant solutions can automate routine tasks (I'm 100% open to suggestions and always looking to improve!).  
** This readme will be regularly updated with notes and any particular comments about a particular perl script.

----------------------------------------------------------------------------------------------------------------------------------------
Notes as I have begun learning perl (for bioinformatics) via self-study and class:
- The substr function is utilized extensively (especially within for loops). The substr function allows one to extract from a string N
  number of characters at a specificed offset. Hence the value is that one is able to compare incremently one nucleotide from a DNA
  sequence to another within a loop.
- For simplicity's sake (not efficiency), try to find a regex solution over a loop-substr solution like above.
- For matrices (2D arrays), use the [row][col] format when possible to avoid confusion, if not then [y][x] is OK.

----------------------------------------------------------------------------------------------------------------------------------------

To run these programs via terminal:
> perl typingGame.pl

Windows Users will need to install Perl (I suggest Strawberry Perl), Mac Users may need to install a separate Perl with the packages

Script comments:
typingGame.pl
- This game is to showcase perl's extensive built-in functions that are particularly handy for string processing (nudge bioinformatics).

Script comments:
weatherPOPApp.pl
- I made this weather app as I scoured through CPAN to find a working weather (Yahoo/Google Weather) module to only find that most had been outdated or that the host had ended API support. This app uses LWP::Simple (preloaded with Strawberry Perl) to web scrape from the HTML output from The Weather Network to provide the user with up-to-date information about their city's conditions.
- Currently it only provides the percentage of precipitation (with :umbrella:  ASCII art) for the next 7 days with an option to export to an xls file (Spreadsheet::WriteExcel module required). More features may be added in the future.
- It was a useful exercise to use REGEX to filter what one requires in a very cluttered HTML form. I tried to cut it down to a smaller section (i.e. from the whole page to just the seven day section HTML form via REGEX and search from there again) but I found a shortcut. Nonetheless, this method is is susceptible to the webpage's changes.

Script comments:
decisionMatrix.pl
- This program should serve useful to anyone trying to decide on a challenging issue (moving, choosing a partner, choosing a career). It is my belief that such large life-changing issues should hold some rational weight before the final decision. At the very least, it provides the person with the subjective feeling that they have consciously decided on their possible choices before deciding. Best of all, this matrix can be completed in mere minutes. How often do humans spend more (total) time deciding their dinner than their careers? Oftentimes large life choices are often imprinted via culture, peers, unconscious processing, and numerous other factors that we are oblivious to.
- This program was more challenging to create than it looked! First I had to keep track of many variables and use them in the correct manner to apply the correct calculation. However more challenging was the formating of the spaces in the matrix (which depends on the user's values). I also had to use two dimensional arrays to create arrays dynamically. It is convenient for memory that the matrix convention in Perl follows the same convention in math, that is Aij where i is the row and j is the column. Therefore we can just think of every j as an element in the i row. Or that every i row is an array. This is much more convenient than denoating x and y as in 2D arrays programmers often use [x][y] and [y][x] interchangeably, [row][col] is much more concrete.
- Lastly I should remind myself to use printf (formatted print) instead of calculating the spaces needed to print a nice table. It is algorithmically slower and slightly less pleasing to the eye.

Script comments:
genbank Extractor and Database Creator Tool (folder) / genbankExtractAndDatabaseTool.pl
- This program allows the user to extract certain fields (ORIGIN, ACCESSION) of GenBank records (specifically, separate .gb files that are contained in the same directory) to be added into a database (SQLite was tested here). Core Perl modules (DBI and Cwd) are used here. Some GenBank files are included for example.
- I see a lot of potential for improvement/extension in this program such as:
  - I used quite a few nested loops which are typically fairly inefficient. I should look into using some recursive functions (to potentially balance CPU and memory usage?) and/or scaling back a loop(s).
  - Add extensions for different databases such as Oracle or Postgres which use different data types and INSERT/CREATE SQL.
  - Allow the user to 'regex' a desired keyterm to be parsed through the genBank files and create a new column.
  - <del>I do not believe (currently as of Jan 27 2017) there is a way to download multiple GenBank records as .gb files separately, instead NCBI outputs as a single .gb file. Thus it would be incredibly useful if I could modify this tool so that it would parse through a single .gb file and denote how many separate GenBank records it contains</del>. see genbank file delimiter tool
- One challenge of creating this program was automating the REGEX such that I do not have to create a REGEX for each field:
      ```
      /ACCESSION(.\*?)VERSION/
      ```
  however this is still necessary for some fields. Another was to creating the SQL statements which are interweaved with variables, that  is I had to use a lot of string concatenation and even loops to create a simple CREATE statement. I suppose this is the trade-off that   comes with automation. And I thought basic SQL (command-line) was finnicky! I have to type the right SQL statement via a database API of  a programming language which I have not mastered, BAH!

Script comments:
recursionBinarySearchTwoArgu.pl

- This script is an introductory classical problem (Binary Search [a Divide and Conquer algorithm]) made slightly more difficult by applying recursion and restricting to only pass-through two arguments (the array by reference and the search key) in one subroutine/function. A lot of the examples I see online usually compare Binary Search to Linear Search in an iterative fashion (while loop), and take in the arguments of low, high, mid and the array. Creating this program taught me to apply three things: recursion, binary search, and the eval() built-in.
   - A key element in this program is the
   
   ```perl
   eval('$arrayRef -> [$mid]' . $operatorEq . '$value')
   ```
   This built-in is often called 'string eval' as it executes whatever is between the parentheses as if it were a Perl program itself (it takes in outer lexical variables). It was useful because I tried to simply assign string and numeric operators depending on the contents of the arrays and perform:

   ```perl
   if($arrayRef -> [$mid]  $operatorEq  $value){ $rv = $mid }
   ```
   However, the Perl interpreter simply thinks $operatorEq is a string and cannot process the whole statement as a valid expression. With the eval() we can bypass this by creating a complete string that will be executed. Nonetheless perldocs has an extensive explanation of eval() http://perldoc.perl.org/functions/eval.html
   - I learned good subroutine/function definition practice. Originally I had 'spaghetti' returns in that my recursion was a CALL-CALL-CALL(RETURN -> COLLAPSE CALL STACK)-(STATEMENTS -> RETURN)-(STATEMENTS -> RETURN). That is, I had an intermediate return (where it would collapse the stack when the key was found or the whole array was searched). After this return, a bunch of conditional statements based on that return value would execute to either return that value or another value. Simpler, elegant recursion should be: CALL-CALL-CALL(Collapse)-RETURN-RETURN-RETURN. So I had to redesign it such that return would be at the end of the subroutine and to adjust the return value within conditional statements above it.  
   - Lastly the most difficult part of designing this script was to keep 'memory' of the index of the original array of the search key. This is so because the recursive function sends in a temporary sliced array to be procssed again for a binary search iteration. Therefore you could lose the integrity of the original array if you ever chop off the left hand side (WRT search key) of the array. The solution here was to send back information to the return value each time the return is sent if the array was chopped at that iteration. IE
   ```perl
   $rv = ($rv + $mid + 1) if $rv >= 0;
   ```

Script comments:
genbank File Delimiter Tool / genbankFileDelimiterTool.pl
- The script splits the multiple NCBI files into each respective genbank file for further processing. This script is useful as by default, NCBI downloads multiple genbank files as 'sequence.gb'. To use this script enter the name of the downloaded genbank file next to script name:
```
> perl genbankFileDelimiterTool.pl "sequence.gb"
```

Script comments:
needlemanWunschAlignment.pl
- This script is a classic bioinformatics alignment problem which uses the Needleman-Wunsch global approach (i.e. aligning all of the nucleotides in both sequences). Currently work in progress (need to include protein sequences, and traceback).
- I strongly recommend extending your console window stream (powershell -> rightclick -> layout -> screen buffer 'width' to 9999 ) for long sequence comparisons.
- Of note is that this script can parse through GenBank (via the Genbank BioPerl module) Accession numbers to find your DNA sequence of interest on top manual entry. Remember that BioPerl 'Seq' are objects, not simple strings, if you need to retrieve the string, use a method call i.e. ```->seq```
