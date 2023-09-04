# Book Scraper

This utility pulls in the page count, word count, and duration in minutes for each of a collection of books.

By default, the script points to the book list in `sample_list.csv`.

To run, edit the CSV with the books you're interested in and then run the following command in PowerShell:
```
.\get-lengthData.ps1
```
The result should look like this
![A demonstration of the output when the script is run.  A table of PSCustomObjects is shown providing the data for each book in the table. Fields printed for each entry are: pageCount, wordCount, duration_mins, author, title](./doc/sample_run.png)

Note that this tool currently misses on some matches and can be further refined.
