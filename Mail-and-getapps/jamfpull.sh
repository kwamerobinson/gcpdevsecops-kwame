#!/bin/bash

rm -f ~/macapps.csv
touch ~/macapps.csv

#email fields
	mailbody="Hi there, here is your CSV file containing all apps found via Jamf :)"
        recipient="krobinson@friendmts.com"

#path to csvs
	AllIDsCSV=/tmp/all-ids.csv			#The CSV that stores every Computer ID
	AllAppsCSV_temp=/tmp/macapps-temp.csv		#Temporary store for the list of mac apps
	AllAppsCSV=~/macapps.csv			#definitive list of mac apps

#Authcreds
	jssurl="https://friendmts.tramscloud.co.uk"
	apiUser="jamfapi-read"
	apiPass=""

#list all computer IDs
	allCompIDs=$(curl -v -k -u $apiUser:$apiPass $jssurl/JSSResource/computers | xmlstarlet sel -t -v '//id' -n ) #select only the IDs 

#put the IDs into a CSV then have that CSV be read into a variable
	echo $allCompIDs | tr ' ' '\n' > $AllIDsCSV

	IDs=$(awk -F, '{print $1}' $AllIDsCSV)

#loop through the IDs and grab the apps in each mac
		for IDValue in $IDs; do curl -k -u $apiUser:$apiPass $jssurl/JSSResource/computers/id/$IDValue |  	
														xmlstarlet format | 								#format output into xml (pretty-print)
														xmlstarlet sel -t -c "/computer/software/applications/application/name" | 	#select only the application names
														sed -e "s/<name>//g" | 								#remove the "<name>" tag from the output
														sed 's/<\/name>/\n/g'  >> $AllAppsCSV_temp; 					#remove the "</name>" tag from the output"
																done




#remove duplicates if there are any
	awk '!seen[$0]++' $AllAppsCSV_temp >> $AllAppsCSV

#sort CSV alphabetically
	sort -n -o $AllAppsCSV $AllAppsCSV

#email and attach document to recipient
	echo $mailbody | mailx -s 'Jamf API pull - Apps On Mac' -a $AllAppsCSV  $recipient

#remove files
	rm -f $AllAppsCSV_temp


