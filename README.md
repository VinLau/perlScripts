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
