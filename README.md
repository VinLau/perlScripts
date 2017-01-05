# perlScripts
Some perl scripts usually (but not always) related to bioinformatics (see READ ME)
-----------------------------------------------------------------------------------------------------------------------------------------
This repo will host a number of succinct perl scripts that will serve two purposes.   
1) Be an autodidactical tool so that I may have a reference of the process and tools (i.e. built-in functions) that solved the problem.  
2) Show others how elegant solutions can automate routine tasks (I'm 100% open to suggestions and always looking to improve!).  
** This readme will be regularly updated with notes and any particular comments about a particular perl script.

-----------------------------------------------------------------------------------------------------------------------------------------
Notes as I have begun learning perl (for bioinformatics) via self-study and class:
- The substr function is utilized extensively (especially within for loops). The substr function allows one to extract from a string N 
  number of characters at a specificed offset. Hence the value is that one is able to compare incremently one nucleotide from a DNA 
  sequence to another within a loop. 
- For simplicity's sake (not efficiency), try to find a regex solution over a loop-substr solution like above.

-----------------------------------------------------------------------------------------------------------------------------------------
Script comments:
typingGame.pl
- This game is to showcase perl's extensive built-in functions that are particularly handy for string processing (nudge bioinformatics).

Script comments:
weatherPOPApp.pl
- I made this weather app as I scoured through CPAN to find a working weather (Yahoo/Google Weather) module to only find that most had been outdated or that the host had ended API support. This app uses LWP::Simple (preloaded with Strawberry Perl) to web scrape from the HTML output from The Weather Network to provide the user with up-to-date information about their city's conditions. 
- Currently it only provides the percentage of precipitation (with a cute feature to let them know when to bring an umbrella) for the next 7 days with an option to export to an xls file (Spreadsheet::WriteExcel module required). More features may be added in the future.
- It was a useful exercise to use REGEX to filter what one requires in a very cluttered HTML form. I tried to cut it down to a smaller section (i.e. from the whole page to just the seven day section HTML form via REGEX and search from there again) but I found a shortcut. Nonetheless, this method is very finnicky and is suspectible to the webpage's changes. 

Script comments:
decisionMatrix.pl
- This program should serve useful to anyone trying to decide on a challenging issue (moving, choosing a partner, choosing a career). It is my belief that such large life-changing issues should hold some rational weight before the final decision. At the very least, it provides the person with the subjective feeling that they have consciously decided on their possible choices before deciding. Best of all, this matrix can be completed in mere minutes. How often do humans spend more (total) time deciding their dinner than their careers? Oftentimes large life choices are often imprinted via culture, peers, unconscious processing, and numerous other factors that we are oblivious to. 
- This program was more challenging to create than it looked! First I had to keep track of many variables and use them in the correct manner to apply the correct calculation. However more challenging was the formating of the spaces in the matrix (which depends on the user's values). I also had to use two dimensional arrays to create arrays dynamically. It is convenient for memory that the matrix convention in Perl follows the same convention in math, that is Aij where i is the row and j is the column. Therefore we can just think of every j as an element in the i row. Or that every i row is an array. 
