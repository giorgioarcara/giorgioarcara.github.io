# choose the .azk file

rawdat=readLines(file.choose())


################################################
# In the first passage I exclude the lines with display error warnings.
# Please, note that these warnings are ignored.
################################################

# check warnings: if there are lines with warnings, they are removed

check.warn=grep("!", rawdat)

if (length(check.warn)>0){
	rawdat=rawdat[-grep("!", rawdat)]
	}


############################################################
# With the following lines the start and end of each subjects are identified.
############################################################
Subj.start=grep("^Subject ", rawdat)+2
# Selct the Subject start (i.e. each line that begin with "Subject ") and move two lines 
# down. That line is the beginning of subject data.


# To find the Subject end, I operazionalize the selection as such: three rows before the start of the following subject.
# Please note that I exlude the first element found (with [-1]), because It would indicate the end of a SUbject before Subject 1. Then, I add the final row of the last Subject as the total length of the imported object. 

Subj.end = (grep("^Subject ", rawdat)-3)[-1]
Subj.end = c(Subj.end, length(rawdat))



dat=NULL # first I create an empty data.frame that will contain all the data.


for (i in 1:length(Subj.start)){ # cycle for all Subjects.
		
		cat(rawdat[Subj.start[i]-2], "\n") # 
		curr.subj=rawdat[Subj.start[i]:Subj.end[i]] #
		curr.subj=gsub(" +", ";", curr.subj) # substitution of space (any number) in strings with the separatore ";"		
		
		curr.subj=strsplit(curr.subj, split=";")
		curr.subj=unlist(curr.subj)
		
		curr.subj=matrix(curr.subj, ncol=3, byrow=TRUE)
		
		dat.subj=data.frame(Item=as.numeric(curr.subj[,2]), RT=as.numeric(curr.subj[,3]))
		
		dat.subj$Ntrial=1:dim(dat.subj)[1]
		
		dat.subj$ACC=as.numeric(dat.subj$RT>0) # calculate Accuracy I set a logical test RT > 0.
				
		dat.subj$RT=abs(dat.subj$RT) # then convert all RTs in positive numbers
		
		# here I retrieve the Subject number
		subj.number=strsplit(rawdat[Subj.start[i]-2], " ")[[1]][2]
		subj.number=as.numeric(gsub(",", "", subj.number)) #remove a colon from the string
		subj.ID=strsplit(rawdat[Subj.start[i]-2], " ")[[1]][10]

		
		
		dat.subj$Subject=subj.number # add the subject number
		dat.subj$ID=subj.ID
		
		
		dat=rbind(dat, dat.subj) # combine the data.frame of current subject with general data.frame dat.
	
	
}



