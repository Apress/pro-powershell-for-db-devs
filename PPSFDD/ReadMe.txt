Readme

Code listings from the book are in the folder named Listings under the appropriate Chapter for the folder.  The listing names match the listing id from the look, i.e. listing-2-1 would be the first listing in Chapter 2.

Script modules are in the folder named Modules with each module in its own folder.  Each module folder should be copied to \WindowsPowerShell\Modules under the user's Documents folder. Each module must be in a folder of the same name as the module.

Data files are in the folder named Data.  For the most part these should be copied to the user's Documents folder except as noted below.


Notes

- All data files are for demonstration purposes only and should not be relied on for accuracy.

- Chapter 3 listing 3-8 will produce an error if script.sql is in the Documents folder.  It is needed to run a subsequent script so I recommend ignoring the error.

- Chapter 5 - For convenience, the listings for language translations, listings-5-25 through listing-5-30, are cosolidated into the folder \translate in that chapter's Listings folder.  All the languge folders with their string translation files are under the translate folder so you can just execute the translate script in the translate folder. 

- Chapter 6 -There are two versions of module umd_simple.  The first is named umd_simple and does not include the Export_ModuleMember cmdlet so everything is exported matching the first example of umd_simple in chapter 6.  Later, the chapter covers using the  Export-ModuleMember cmdlet so a different version named umd_simple_withexport is provided that matches the code in the chapter that discusses exporting module members.

Chapter 9 - The notes below are for Listing 9 - 1 - ETL Load Script.

When you run the script that polls for the data file, it looks in the sub folder \FTP under the user's Documents folder.  After you run the script, copy the file there and the load script will copy/move the file to other folders as it is processed.  Note: \Inbound, \Unzipped, \Process, and \Archive folders must already be created under the user's Documents folder.

The test file provided is  sales_abccompany_20141015.zip. Put it in FTP folder when you are ready to test the script.

The ETL script polls for file pattern sales_*.zip in \Documents\FTP\

Where is is moved to the folders below for each step of processing...

Documents\Inbound\ 
Documents\unzipped\
Documents\Process\
Documents\Archive\

In summary, overall ETL script run the script and then copy sales_abccompany_20141015.zip to \Documents\FTP\.


Chapter 10 

The file psappconfig.csv must be saved to c:\pasappconfig\psappconfig.csv. 
The file psappconfig.txt must be saved to  c:\pasappconfig\psappconfig.txt

Note:  psappconfig.txt is also in the module folder umd_psappconfig for use by that module.

Chapter 12 - umd_jobs - Is not mentioned in book but incorporates listings 12-1 and 12-2.






