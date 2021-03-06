# MONOGRAFIA MATHEUS - DOWNLOADING PNAD DATA FROM 2001 - 2013

###################################################################################
# Analyze the 2001 - 2013 Pesquisa Nacional por Amostra de Domicilios file with R #
###################################################################################


# set your working directory.
# the PNAD 2001 - 2013 data files will be stored here
# after downloading and importing them.
# use forward slashes instead of back slashes

# uncomment this line by removing the `#` at the front..
setwd( "/Users/mlobo/Documents/Monografia/PNAD/Microdata/2001 - 2013/" )
# ..in order to set your current working directory


# # # are you on a non-windows system? # # #
if ( .Platform$OS.type != 'windows' ) print( 'non-windows users: read this block' )
# ibge's ftp site has a few SAS importation
# scripts in a non-standard format
# if so, before running this whole download program,
# you might need to run this line..
options( encoding="windows-1252" )
# ..to turn on windows-style encoding.
# # # end of non-windows system edits.


# remove the # in order to run this install.packages line only once
# install.packages(c("survey", "RSQLite", "SAScii", "descr", "downloader", "digest", "stringr"))


# define which years to download #

# uncomment this line to download all available data sets
# uncomment this line by removing the `#` at the front
# do not attempt to download all the years at once, it will not work
years.to.download <- c(2001, 2002, 2004, 2005, 2006, 2008, 2013)

# name the database (.db) file to be saved in the working directory
pnad.dbname <- "pnad.db"


############################################
# no need to edit anything below this line #
############################################

# # # # # # # # #
# program start #
# # # # # # # # #

# if the pnad database file already exists in the current working directory, print a warning
if ( file.exists( paste( getwd() , pnad.dbname , sep = "/" ) ) ) warning( "the database file already exists in your working directory.\nyou might encounter an error if you are running the same year as before or did not allow the program to complete.\ntry changing the pnad.dbname in the settings above." )


library(RSQLite) 	# load RSQLite package (creates database files in R)
library(SAScii) 	# load the SAScii package (imports ascii data with a SAS script)
library(descr) 		# load the descr package (converts fixed-width files to delimited files)
library(downloader)	# downloads and then runs the source() function on scripts from github

# load the download_cached and related functions
# to prevent re-downloading of files once they've been downloaded.
source_url( 
	"https://raw.github.com/ajdamico/asdfree/master/Download%20Cache/download%20cache.R" , 
	prompt = FALSE , 
	echo = FALSE 
)

# save the function from: https://raw.githubusercontent.com/ajdamico/asdfree/master/SQLite/read.SAScii.sqlite.R 
# and save it in your computer as Function1.R
# load the read.SAScii.sqlite function (a variant of read.SAScii that creates a database directly)
source( "/Users/mlobo/Documents/Monografia/Scripts/PNAD Data/2001_2013/Function1.R" , prompt = FALSE )

# save the function from: https://raw.githubusercontent.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/pnad.survey.R
# and save it in your computer as Function2.R
# load pnad-specific functions (to remove invalid SAS input script fields and postStratify a database-backed survey object)
source( "/Users/mlobo/Documents/Monografia/Scripts/PNAD Data/2001_2013/Function2.R" , prompt = FALSE )


# create a temporary file and a temporary directory..
tf <- tempfile() ; td <- tempdir()

# open the connection to the sqlite database
db <- dbConnect( SQLite() , pnad.dbname )


# download and import the tables containing missing codes
download( "https://raw.github.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/household_nr.csv" , tf )
household.nr <- read.csv( tf , colClasses = 'character' )

download( "https://raw.github.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/person_nr.csv" , tf )
person.nr <- read.csv( tf , colClasses = 'character' )

# convert these tables to lowercase
names( household.nr ) <- tolower( names( household.nr ) )
names( person.nr ) <- tolower( names( person.nr ) )

# remove all spaces between missing codes
household.nr$code <- gsub( " " , "" , household.nr$code )
person.nr$code <- gsub( " " , "" , person.nr$code )

# convert all code column names to lowercase
household.nr$variable <- tolower( household.nr$variable )
person.nr$variable <- tolower( person.nr$variable )


# begin looping through every pnad year specified
for ( year in years.to.download ){

	cat( 'currently working on' , year )

	# # # # # # # # # # # #
	# load the main file  #
	# # # # # # # # # # # #

	# this process is slow.
	# for example, the PNAD 2011 file has 358,919 person-records.

	# note: this PNAD ASCII (fixed-width file) contains household- and person-level records.

	if ( year < 2013 ){
		
	  # if yu need to download the years 2003, 2007, 2009, 2011 or 2012, use the following:
	  # ftp.path <-
	    # paste0(
	      # "ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_" ,
	      # year ,
	      # "_20150814.zip"
	    # )
		# figure out the exact filepath of the re-weighted pnad year
		ftp.path <-
			paste0(
				"ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/reponderacao_2001_2012/PNAD_reponderado_" ,
				year ,
				".zip"
			)

		# download the data and sas importation instructions all at once..
		download_cached( ftp.path , tf , mode = "wb" )
		
		# ..then also unzip them into the temporary directory
		files <- unzip( tf , exdir = td )

	# if the files aren't already in a convenient zipped file..
	} else {
	
		# point to their main path
		ftp.path <-
			paste0( 
				"ftp://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_anual/microdados/" , 
				year , 
				"/" 
			)
	
		# blank out the files object from the previous go-round of the loop
		files <- NULL
	
		# loop through each of the files you might need
		for ( this.file in c( "Dados.zip" , "Dicionarios_e_input_20150814.zip" ) ) {
		
			try({
				
				# give downloading 'em a shot
				download_cached( paste0( ftp.path , this.file ) , tf , mode = 'wb' )
				
				# unzip them into the same place
				files <- c( files , unzip( tf , exdir = td ) )
				
			} , silent = TRUE )
			
		}
	
	}

	# manually set the encoding of the unziped files so they don't break things.
	Encoding( files ) <- 'UTF-8'
	
	# remove the UF column and the mistake with "LOCAL �LTIMO FURTO"
	# described in the remove.uf() function that was loaded with source_url as pnad.survey.R
	dom.sas <- remove.uf( files[ grepl( paste0( 'input[^?]dom' , year , '.txt' ) , tolower( files ) ) ] )
	pes.sas <- remove.uf( files[ grepl( paste0( 'input[^?]pes' , year , '.txt' ) , tolower( files ) ) ] )

	# since `files` contains multiple file paths,
	# determine the filepath on the local disk to the household (dom) and person (pes) files
	dom.fn <- files[ grepl( paste0( 'dados/dom' , year ) , tolower( files ) ) ]
	pes.fn <- files[ grepl( paste0( 'dados/pes' , year ) , tolower( files ) ) ]

	# store the PNAD household records as a SQLite database
	read.SAScii.sqlite ( 
		dom.fn , 
		dom.sas , 
		zipped = F , 
		tl = TRUE ,
		# this default table naming setup will name the household-level tables dom2001, dom2002, dom2003 and so on
		tablename = paste0( 'dom' , year ) ,
		conn = db
	)
	
	# store the PNAD person records as a SQLite database
	read.SAScii.sqlite ( 
		pes.fn , 
		pes.sas , 
		zipped = F , 
		tl = TRUE ,
		# this default table naming setup will name the person-level tables pes2001, pes2002, pes2003 and so on
		tablename = paste0( 'pes' , year ) ,
		conn = db
	)

	# the ASCII and SAS importation instructions stored in temporary files
	# on the local disk are no longer necessary, so delete them.
	attempt.one <- try( file.remove( files ) , silent = TRUE )
	# weird brazilian file encoding operates differently on mac+*nix versus windows, so try both ways.
	if( class( attempt.one ) == 'try-error' ) { Encoding( files ) <- '' ; file.remove( files ) }
	
	
	# missing level blank-outs #
	# this section loops through the non-response values & variables for all years
	# and sets those variables to NULL.
	cat( 'non-response variable blanking-out only occurs on numeric variables\n' )
	cat( 'categorical variable blanks are usually 9 in the pnad\n' )
	cat( 'thanks for listening\n' )
	
	# loop through each row in the missing household-level  codes table
	for ( curRow in seq( nrow( household.nr ) ) ){

		# if the variable is in the current table..
		if( household.nr[ curRow , 'variable' ] %in% dbListFields( db , paste0( 'dom' , year ) ) ){

			# ..and the variable should be recoded for that year
			if( year %in% eval( parse( text = household.nr[ curRow , 'year' ] ) ) ){
		
				# update all variables where that code equals the `missing` code to NA (NULL in SQLite)
				dbSendQuery( 
					db , 
					paste0( 
						'update dom' , 
						year , 
						' set ' , 
						household.nr[ curRow , 'variable' ] , 
						" = NULL where " ,
						household.nr[ curRow , 'variable' ] ,
						' = ' ,
						household.nr[ curRow , 'code' ]
					)
				)
			
			}
		}
	}

	# loop through each row in the missing person-level codes table
	for ( curRow in seq( nrow( person.nr ) ) ){

		# if the variable is in the current table..
		if( person.nr[ curRow , 'variable' ] %in% dbListFields( db , paste0( 'pes' , year ) ) ){
		
			# ..and the variable should be recoded for that year
			if( year %in% eval( parse( text = person.nr[ curRow , 'year' ] ) ) ){
		
				# update all variables where that code equals the `missing` code to NA (NULL in SQLite)
				dbSendQuery( 
					db , 
					paste0( 
						'update pes' , 
						year , 
						' set ' , 
						person.nr[ curRow , 'variable' ] , 
						" = NULL where " ,
						person.nr[ curRow , 'variable' ] ,
						' = ' ,
						person.nr[ curRow , 'code' ]
					)
				)
			
			}
		}
	}

	
	# create indexes to speed up the merge of the household- and person-level files.
	dbSendQuery( db , paste0( "CREATE INDEX pes_index" , year , " ON pes" , year , " ( v0101 , v0102 , v0103 )" ) )
	dbSendQuery( db , paste0( "CREATE INDEX dom_index" , year , " ON dom" , year , " ( v0101 , v0102 , v0103 )" ) )

	# clear up RAM
	gc()
	
	# create the merged file
	dbSendQuery( 
		db , 
		paste0( 
			# this default table naming setup will name the final merged tables pes2001, pes2002, pes2003 and so on
			"create table pnad" , 
			year , 
			# also add a new column "one" that simply contains the number 1 for every record in the data set
			# also add a new column "uf" that contains the state code, since these were thrown out of the SAS script
			# also add a new column "region" that contains the larger region, since these are shown in the tables
			# NOTE: the substr() function luckily works in SQLite() databases, but may not work if you change SQL database engines to something else.
			" as select * , 1 as one , substr( a.v0102 , 1 , 2 ) as uf , substr( a.v0102 , 1 , 1 ) as region from pes" , 
			year , 
			" as a inner join dom" , 
			year , 
			" as b on a.v0101 = b.v0101 AND a.v0102 = b.v0102 AND a.v0103 = b.v0103" 
		)
	)

	# determine if the table contains a `v4619` variable.
	# v4619 is the factor of subsampling used to compensate the loss of units in some states
	# for 2012, the variable v4619 is one and so it is not needed.
	# if it does not, create it.
	any.v4619 <- 'v4619' %in% dbListFields( db , paste0( 'pnad' , year ) )

	# if it's not in there, copy it over
	if ( !any.v4619 ) {
		dbSendQuery( db , paste0( 'alter table pnad' , year , ' add column v4619 real' ) )
		dbSendQuery( db , paste0( 'update pnad' , year , ' set v4619 = 1' ) )
	}
	
	# now create the pre-stratified weight to be used in all of the survey designs
	# if it's not in there, copy it over
	dbSendQuery( db , paste0( 'alter table pnad' , year , ' add column pre_wgt real' ) )
	dbSendQuery( db , paste0( 'update pnad' , year , ' set pre_wgt = v4619 * v4610' ) )
	
	
	# confirm that the number of records in the pnad merged file
	# matches the number of records in the person file
	stopifnot( 
		dbGetQuery( db , paste0( "select count(*) as count from pes" , year ) ) == 
		dbGetQuery( db , paste0( "select count(*) as count from pnad" , year ) ) 
	)

	
}

# take a look at all the new data tables that have been added to your RAM-free SQLite database
dbListTables( db )

# disconnect from the current database
dbDisconnect( db )

# remove the temporary file from the local disk
file.remove( tf )

# print a reminder: set the directory you just saved everything to as read-only!
message( paste0( "all done.  you should set the file " , file.path( getwd() , pnad.dbname ) , " read-only so you don't accidentally alter these tables." ) )


# for more details on how to work with data in r
# check out my two minute tutorial video site
# http://www.twotorials.com/

# dear everyone: please contribute your script.
# have you written syntax that precisely matches an official publication?
message( "if others might benefit, send your code to ajdamico@gmail.com" )
# http://asdfree.com needs more user contributions

# let's play the which one of these things doesn't belong game:
# "only you can prevent forest fires" -smokey bear
# "take a bite out of crime" -mcgruff the crime pooch
# "plz gimme your statistical programming" -anthony damico
