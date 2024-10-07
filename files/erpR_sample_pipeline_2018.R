############################################
## erpR SAMPLE PIPELINE
############################################
# ver 0.2 11/2018

###############
## Load package
################

# install erpR package 
#install.packages("erpR")

# load erpR package
library(erpR)


################
### Import data
#################

# to play around with erpR you can load directly the data frames included in the package
# load the sample datasets
data(erplistExample)


# alternatively you may import .txt data (you can download the same examples contained in ERPdatasets from XXXXX) 
# by running the following lines
### change path, by setting YOUR path of the folder containing the .txt files 
setwd("/Users/giorgioarcara/Downloads/sample_files_erpR")

# load all the files of "word" condition in the erplist named erplistExample. "Outname" indicates the name that will be given to the objects in R
#erplistExample=import.erp(filenamebase="Exp1_word_subj", numbers=1:20, outname="Exp1_word_subj", fileinfo=TRUE, startmsec=-200, endmsec=1500)

# load all the files of the "nonword" condition and add them to the erplist named erplistExample
#erplistExample=import.erp(filenamebase="Exp1_nonword_subj", numbers=1:20, outname="Exp1_nonword_subj", fileinfo=TRUE, startmsec=-200, endmsec=1500, erplist=erplistExample)



#####################################
### Create a data frame with all data
######################################

# The next steps lead to creating a data frame "datall.long" that contains all the necessary information for the analysis.
# In these 2 nested cycles we calculate an average across all subjects for each selected interval. 

# Create a list with couples of numbers that indicate the intervals for which mean amplitude will be calculated
my_intervals=list(c(130,190), c(400,600), c(500, 700))


# Create a vector of experimental conditions, that will be used for naming the final datased.
# The "base" part of the filename be uniform for all the files of the same experimental condition, varying only by subject number added at the end.
# E.g. we have two conditions - "word" and "nonword", so the "word" files may be named like "Exp1_word_subj1", "Exp1_word_subj2" etc.

my_bases=c("Exp1_word_subj", "Exp1_nonword_subj")
my_conditions=c("WORD", "NONWORD")
my_numbers = 1:20
my_startmsec=-200
my_endmsec = 1500

# Create an empty dataframe before starting the cycle 
datall.long= erp.fun.loop(bases = my_bases, numbers = my_numbers, intervals = my_intervals, 
                          conditions.names = my_conditions, intervals.var=TRUE, erp.fun=erp.mean, 
                          startmsec=my_startmsec, endmsec=my_endmsec, erplist = erplistExample, 
                          name.dep= "Ampl")


############################################
# Note: the above cycle works well in case of a within-subject experimental design.
# In case of a between-subject design it will be necessary to make separate cycles for each condition, where one may change the "base" 
# (if different experimental groups have different "base" name), the "numbers" (if the subjects from different groups have different numbers), or both of them.
# This depends on the encoding made during the experiment.
############################################




#############################################################
### Create a data frame suitable for the statistical analysis
##############################################################

# to be suited for ANOVA analysis the data frame should contain only ONE observation for each combination of factors and the Subject variable.

############################################
### Example 1: analysis on midline electrode
#############################################

# Compare the amplitudes between some electrodes of the midline
# Create an object selecting the electrodes for the analysis

datall.long.midline=datall.long[datall.long$electrode%in%c("FPZ", "FZ", "CPZ"),]


# Group the data so that ANOVA works correctly
# The function below does this grouping, calculating the mean of the data for all the conditions to collapse.
# Define 1) the dependent variable, 2) all and only the independent variables for the analysis, 3) Subject variable
# Here the analysis is confined to the interval "130-190"

datmidline=named.agg(Ampl~condition+electrode+Subject, data=datall.long.midline[datall.long.midline$interval=="130-190",], FUN=mean)


# Check that the data is organized correctly. 
# If it is, a single value should be returned for each combination of all the variables, including Subject, EXCEPT the dependent variable (Ampl in this case)

with(datmidline, table(electrode, Subject, condition))

# before ANOVA, transform all relevant variables in factors
datmidline[,c("Subject", "condition", "electrode")]=factorall(datmidline[,c("Subject", "condition", "electrode")])


# compute ANOVA

datmidline.aov=aov(Ampl~condition*electrode+Error(Subject/(condition*electrode)), datmidline)
summary(datmidline.aov)




##################################
### Example 2: analysis on two ROI
###################################

# Group the electrodes for ROI (region of interest)
# As a first step, create the variables that group the electrodes.
# Create two vectors to define laterality of the ROI (two levels: "left", "right")

datall.long$laterality=create.roi(datall.long, electrode="electrode", groups=list(c("F3", "FC3", "C3", "CP3"), c("F4", "FC4", "C4", "CP4")), roi.levels=c("left", "right"))


# Check for correct grouping

table(datall.long$laterality, datall.long$electrode)

# Create other grouping variables

datall.long$caudality=create.roi(datall.long, electrode="electrode", groups=list(c("F3", "FC3", "F4", "FC4"), c("C3", "CP3", "C4", "CP4")), roi.levels=c("anterior", "posterior"))

# Check for correct grouping
table(datall.long$caudality, datall.long$electrode)


# Group the data so that ANOVA works correctly
#The function below does this grouping, calculating the mean of the data for all the conditions to collapse (this is specified in FUN=mean)

# Define 1) the dependent variable, 2) all and only the independent variables for the analysis, 3) Subject variable
# Here the analysis is confined to the interval "400-600"
 
dat400600=named.agg(Ampl~caudality+laterality+condition+Subject, data=datall.long[datall.long$interval=="400-600",], FUN=mean)


# Check that the data is organized correctly. 
# If it is, a single value should be returned for each combination of all the variables, including Subject, EXCEPT the dependent variable (Ampl in this case)

with(dat400600, table(caudality, laterality, condition, Subject))

# before ANOVA, transform all relevant variables in factors
dat400600[,c("Subject", "caudality", "laterality", "condition")]=factorall(dat400600[,c("Subject", "caudality", "laterality", "condition")])

# compute ANOVA

dat400600.aov=aov(Ampl~condition*caudality*laterality+Error(Subject/(condition*caudality*laterality)), dat400600)
summary(dat400600.aov)



######################
# Graphics
######################

# Create an average of all the subjects for the "word" condition
word=grandaverage("Exp1_word_subj", 1:20, erplist=erplistExample) 


# Create an average of all the subjects for the "nonword" condition
nonword=grandaverage("Exp1_nonword_subj", 1:20, erplist=erplistExample)


# Visualize a single electrode of the grand average of all the subjects 
erp(word, electrode="Fp1",  col="blue", startmsec=-200, endmsec=1500)


# Add nonword diagram to the word one
erp.add(nonword, electrode="Fp1", col="red", startmsec=-200, endmsec=1500)


# Visualize a single electrode of a single subject (subj1 here)
# notice the syntax to retrieve the subject from the erplist named erplistExample
erp(erplistExample$Exp1_word_subj1, electrode="Fp1",  col="blue", startmsec=-200, endmsec=1500, ylim=c(-20,20))


# Visualize the whole scalp for all the subjects
scalp(list(word), layout=1, ylim=10, startmsec=-200, endmsec=1500)

# From this diagram we see an anomaly in OZ
# The following diagrams help to track the OZ anomaly origins

# Visualize if there are subjects that have a particular influence on the average
# Requires Rpanel and Tcl/Tk packages

if (require(rpanel)){


scalp.infl("Exp1_word_subj", 1:20, layout=1, startmsec=-200, endmsec=1500, erplist=erplistExample)


# Note that Subject 1 is clearly particularly influential for the average on OZ.
erp.infl(base="Exp1_word_subj", numbers=1:20, electrode="Fp1", startmsec=-200, endmsec=1500, erplist=erplistExample)

scalp.subj("Exp1_word_subj", 1:20, layout=1, startmsec=-200, endmsec=1500, erplist=erplistExample)


}

#The anomaly of the Subject 1 on OZ is also visible on a Butterfly plot
butterfly(base="Exp1_word_subj", numbers=1:20, electrode="OZ",startmsec=-200, endmsec=1500, outline=1, out.col="red", ylim=c(-50,50), erplist=erplistExample)

# Check the grand average of the nonword condition as well
scalp(list(nonword),  layout=1, ylim=10)


# Here's also an anomaly
butterfly(base="Exp1_nonword_subj", numbers=1:20, electrode="OZ",  startmsec=-200, endmsec=1500, outline=1, ylim=c(-50,50), erplist=erplistExample)

# The Butterfly plot confirms that the problem is in the Subject 1.


#Create a backup of Subject 1
Exp1_word_subj1_backup=erplistExample$Exp1_word_subj1
Exp1_nonword_subj1_backup=erplistExample$Exp1_nonword_subj1

# Modify the Subject 1 changing the data we want to exclude to NA.

erplistExample$Exp1_word_subj1$OZ=NA
erplistExample$Exp1_nonword_subj1$OZ=NA


# Create an object that contains the average of all the subjects for the "word" condition
word.adj=grandaverage("Exp1_word_subj", 1:20, erplist=erplistExample, NA.sub=T)
# Note the warning that something abnormal has been done


# Create an object that contains the average of all the subjects for the "nonword" condition
nonword.adj=grandaverage("Exp1_nonword_subj", 1:20, erplist=erplistExample, NA.sub=T)
# Note the warning that something abnormal has been done


# Check OZ
scalp(list(word, word.adj),  layout=1, ylim=10, legend=T)
# Note that this diagram and the previous one are identical except for the OZ


# Check the differences word-nonword
scalp(list(word.adj, nonword.adj), layout=1, ylim=10, legend=T)


# Exploratory t-tests for every timepoint. Grey bands indicate significant differences for a given timepoint.
scalp.t("Exp1_word_subj", "Exp1_nonword_subj", 1:20, 1:20, layout=1, ylim=10, legend=T, erplist1=erplistExample, erplist2=erplistExample)



# draw a topographic plot

# check if some electrodes are not present in the list
# and create an object with these electrode names.
# NOTE, that this won't plot anything, it is just a check for
notfound=topoplot(word, return.notfound=TRUE)
print(notfound)


#define a layout for
mat=matrix(c(1,2), 1, 2, byrow=TRUE)

layout(mat, widths=c(0.8, 0.2))

#make a topoplot excluding not found electrode
par(pty="s")
topo.data=topoplot(word, startmsec=-200, endmsec=1500, win.ini=400, 
win.end=600, exclude=notfound)

#draw the palette on a new empty plot.
par(pty="m", mar=c(0,0,0,0))
plot.new()
topoplot.palette(cols=topo.data$palette, 
palette.lim=topo.data$zlim, p.height=0.6 )

