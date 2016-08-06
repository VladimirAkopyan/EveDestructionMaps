# EveDestructionMaps
I mapped destruction of ships in eve online for my final year project

##Data Harvester

This is a very simple console applicaiton that connects to Zkillboard, donwloads ''kill-mails' - player death records, and connects to a local MSSQL server to save the data. 
There is no ORM or any intelligence, if there isn't already a database with te correct name and schema, the operation will fail.
The data aquired from killboards contains ID's of ships and equipment that were involved. The data that they are reffering to can be obtained from CCP, the company that develops Eve Online. 
Currently you can get this data at: https://developers.eveonline.com/resource/resources
If at the time you are reding this the company has moved the resources and the link is broken, search for "eve online static data export" and you should be able to find it.
This database forms the basis for the schema that this software is looking for. If you have basic SQL skills, you should be able to create a table for storing killmails without much trouble just by reading the code. 

##CrowdsourcingWebsite

This is a simple PHP web-page that reads a CSV with kills that needs to be categorised, displays them in iFrame to Zkillboard and saves the player category to a different file. 
*Anonymous Crowdsourced Data* shows direct output of this operation. Next I would import this into SQL server and join it with other data tables

##SQL

There is no SQL for creating 'Killmails' table, I used the SQL Management Studio GUI to do that. 
Here is the SQL that I used to create aggregate vews. It's data aquired above, after some joins and transformations. 
You could really join this data in any way you want, and what I have here is definately sub-optimal. 

##Datasets
This is what the data looks like right before I input it into machine learning.  
This folder contains two sets: training set with ~800 rows and a larger set wiht ~150,000 rows 
The training set is already categorised through crowd-sourcing (last column). That is the player's judgement on the circumstances under which the victim was killed. 
The Larger dataset is an extract from the database, this is the data I was classifying automatically. The entire database was a couple of Gigabytes
