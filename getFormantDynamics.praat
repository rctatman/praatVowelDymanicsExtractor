############################################################################
## getFormantDynamics.praat
##
## For all .wav files in a directory, measures marked vowel(s) and writes F1, F2 & F3 measurements at five
## equally-spaced intervals for each labelled .textgrid segment to file.
##
## Modified to get formant values at multiple timepoints by Rachael Tatman, supported by NSF grant DGE-1256082.
## This script now gets fomant measures at timepoints roughly equivelent to the 20, 35, 50, 65 and 80% provided 
## by FAVE extract (http://fave.ling.upenn.edu/extractFormants.html). The column headings are also the same as 
## automatically provided by FAVE extract, for parallelism.
## 
## Written by Rachael Tatman
## Dept. of Linguistics at the University of Washington
## rctatman@uw.edu
## 10/18/2016
##
## Adapted from code written by Robert Daland
## Dept. of Linguistics @ Northwestern University
## r-daland@northwestern.edu
## 10/18/2004
##
## Which was in turn adapted from code written by:
## Pauline Welby
## welby@ling.ohio-state.edu
## January 12, 2003
## 
############################################################################

# script arguments

form Input Enter directory and output file name
	sentence outFile formant-values.txt
	sentence dirName /home/rachael/Dropbox/dissertation/experiment2/vowelFormantDynamics/extractingDymanics/
endform

maxFormant = 5500
# men: 5000, women: 5500, children: 6000

# creates an output file with the specified name and adds headings 
# NB: if the named output file exists, it will be overwritten

outLine$ = "sound" + tab$ + "vowel" + tab$ +
	... "F1.20." + tab$ + "F1.35." + tab$+ "F1.50." + tab$ + "F1.65." + tab$ + "F1.80." + tab$+ 
	... "F2.20." + tab$ + "F2.35." + tab$+ "F2.50." + tab$ + "F2.65." + tab$ + "F2.80." + tab$+ 
	... "F3.20." + tab$ + "F3.35." + tab$+ "F3.50." + tab$ + "F3.65." + tab$ + "F3.80." + newline$
outLine$ > 'dirName$''outFile$'

Create Strings as file list... fileList 'dirName$'*.TextGrid
nFiles = Get number of strings

for i to nFiles
	# Read in sound file, textgrid, and calculate formant object
	select Strings fileList
	fileName$ = Get string... i
	Read from file... 'dirName$''fileName$'
	name$ = selected$("TextGrid")
	Read from file... 'dirName$''name$'.wav
	To Formant (burg)... 0.01 5 'maxFormant' 0.025 50

	# For each labeled interval (vowel), get measurements
	select TextGrid 'name$'
	nIntervals = Get number of intervals... 1
	for j to nIntervals
		select TextGrid 'name$'
		segment$ = Get label of interval... 1 'j'
		if length(segment$) > 0
			# GET TIMEPOINTS
			start = Get starting point... 1 'j'
			end = Get end point... 1 'j'
			duration = (end-start)
			step = duration/6
			onset = start+ (1 * step)
			onset1 = start + (2 * step)
			midpoint = start + (3 * step)
			midpoint1 = start + (4 * step)
			offset = start + (5 * step)

			# TAKE FORMANT MEASUREMENTS
			select Formant 'name$'

			f1_on = Get value at time... 1 'onset' Hertz Linear
			f2_on = Get value at time... 2 'onset' Hertz Linear
			f3_on = Get value at time... 3 'onset' Hertz Linear

			f1_on1 = Get value at time... 1 'onset1' Hertz Linear
			f2_on1 = Get value at time... 2 'onset1' Hertz Linear
			f3_on1 = Get value at time... 3 'onset1' Hertz Linear

			f1_mid = Get value at time... 1 'midpoint' Hertz Linear
			f2_mid = Get value at time... 2 'midpoint' Hertz Linear
			f3_mid = Get value at time... 3 'midpoint' Hertz Linear

			f1_mid1 = Get value at time... 1 'midpoint1' Hertz Linear
			f2_mid1 = Get value at time... 2 'midpoint1' Hertz Linear
			f3_mid1 = Get value at time... 3 'midpoint1' Hertz Linear

			f1_off = Get value at time... 1 'offset' Hertz Linear
			f2_off = Get value at time... 2 'offset' Hertz Linear
			f3_off = Get value at time... 3 'offset' Hertz Linear
		
			# PRINT OUTPUT
			outLine$ =  name$ + tab$ + segment$ + tab$ + 
				... "'f1_on:1'" +tab$ + "'f1_on1:1'" + tab$ + "'f1_mid:1'" + tab$ + "'f1_mid1:1'" + tab$ + "'f1_off:1'" + tab$ + 
				... "'f2_on:1'" +tab$ + "'f2_on1:1'" + tab$ + "'f2_mid:1'" + tab$ + "'f2_mid1:1'" + tab$ +"'f2_off:1'" + tab$ + 
				... "'f3_on:1'" +tab$ + "'f3_on1:1'" + tab$ + "'f3_mid:1'" + tab$ + "'f3_mid1:1'" + tab$ +"'f3_off:1'" + newline$
			#outLine$ = name$ +  tab$ + segment$ + newline$
			outLine$ >> 'dirName$''outFile$'
		endif
	endfor

	# clean up
	select TextGrid 'name$'
	plus Sound 'name$'
	plus Formant 'name$'
	Remove
endfor

# clean up
select Strings fileList
Remove
