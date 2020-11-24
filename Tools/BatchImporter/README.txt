#########################################################################################
#											#
# TITLE: Batch Import.R									#
#											#
# DESCRIPTION: 	This function allows you to load multiple model parameters into the R 	#
#		global environment from an Excel spreadsheet. Parameters are defined	#
#		'type' (Beta, Gamma, Normal, etc.) and converted into a vector of	#
#		'num_iter' probabilisticly sampled values with mean and SD matching	#
#		that of the baseline estimates.						#
#											#
# AUTHOR: Ian Andrew Cromwell								#
#											#
# DATE: August, 2020									#
#											#
#########################################################################################

Step 1 - Set the working directory where your Excel table is saved

	A few notes about setting up your Excel table:
	
	- The column headings must be the same as in the 'ModelInputs.xls' sample file
	- You can leave 'Description' blank
	- Variable 'types' (August, 2020):
		1 - Beta distributed (probabilities)
		2 - Normally distributed
		3 - Gamma distributed
		4 - Utilities

		Please contact Ian (ian.cromwell@cadth.ca) if you need to add another
		variable type and don't know how.

Step 2 - Read in the table (make sure you update the file name)

Step 3 - Load the 'ImportVars.R' file

	This file contains a function that creates a list of three data-containing lists:
		1 - A list of variable names
		2 - A list of mean values for each variable
		3 - A list of probabilistically sampled values for each variable

Step 4 - Run the ImportVars function (you can specify the number of probabilistic iterations)

Step 5 - Create the variables (either deterministically or probabilistically) in the global environment