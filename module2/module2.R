#####################################################################
###R Bootcamp for Programming
###Module 2: Vectors, Data Frames, Subsetting, Filtering, and Ordering
####################################################################

##Before you start: remember to set your working directory to the 
##module2 folder!

###load up the workspace
load("module2.RData")

#########################
###Part 1: Vectors
#########################
###let's look at a vector in the workspace
weights

###each slot in a vector can have a unique name
names(weights)

###a vector has a length
length(weights)

###weights can be subsetted
###get the very first weight
weights[1]

###get the first 5 weights
weights[1:5]

###values can also be retrieved by name
weights["M15"]

####QUESTION 1-1: How would we get the last 5 weights?
####QUESTION 1-2: How would we get the first 5 weights in reverse order?

###assignment
###in general, assignment is done by using the <- operator
b <- weights[1:5]
b

###operations on vectors
###in general, if you can do an operation on a vector all at once,
###try to do it (R is optimized for this)
###run the mean on a vector
meanWeight <- mean(weights)

###Missing numeric values tend to be coded as NAs. Not all functions will
###handle NAs the same. In module 3, we will talk about the na.omit() function.

#vector operations
#some operations output a vector of the same length
#let's get the residual sum of squares
resids <- weights - meanWeight

####QUESTION 1-3: what happened here? Why can we subtract a scalar
####from a vector?

####QUESTION 1-4: what happens when you try to subtract two vectors of unequal lengths?
weights[1:5] - weights[1:2]

##Another example of a vector operation
##look at resids
resids
##square the residuals
sqResids <- resids^2
##produce residual sum of squares
sum(sqResids)


##making vectors
##in general, you can use the c() (concatenate) command
##to make vectors

vec <- c(1,2,3:5)
vec

##you can also concatenate a vector to another vector

vec2 <- c(vec,5,5)
vec2

####QUESTION 1-5: what happens when you try to mix characters and
####numbers?  What does this tell you about vectors?

c("This is character data", 1:5)


####QUESTION 1-6: how might you combine c() and a series of names to
####pull out only the "M1", "M5", and "M10" weights?
####this is another kind of subsetting operation, and we'll cover it more 
####in detail later.


#descriptive statistics and exploratory data analysis
#can run on a single vector
#show mean and quantiles
summary(weights)

#show a histogram
hist(weights)

####QUESTION 1-7: What can you say about the distribution of weights?
####i.e., are they distributed normally?


##vector datatypes and casting
##There are four useful vector datatypes to keep in mind: numeric, character, boolean
##and factor.

##we've already seen numeric vectors
c(1,2,3,5)

##another useful way to initialize a vector is using a sequence
c(1:10)

##boolean vectors are simply TRUE/FALSE
c(TRUE,TRUE,TRUE,FALSE)

##to some extent, we can convert between vector types using as.numeric() and 
##as.character()

as.character(c(1,2,3,5))


##factor vectors can be ordered (by specifying the level argument) or
##unordered (by not specifying the level argument). The ordering impacts
##properties such as the order the factors are plotted, the order in which
##factors are reported in table() and the way other functions treat them.
##
##note that levels has to contain all factors.
testVecFac <- factor(c("D", "D", "E"), levels=c("D", "E"))



##character and factor vectors are for the most part interchangable for tables
testVecChar <- c("A", "B", "C","C", "D")
testVecFac <- factor(c("A", "B", "C","C", "D"))

table(testVecChar)
table(testVecFac)

##However, when we use numbers as factors be aware that as.numeric() doesn't work.
##This is due to the internal representation of factors as integers.
testVecFac <- factor(c(1,5,5,56), levels=c(1,5,56))
as.numeric(testVecFac)

##instead, we must first cast to character, and then numeric:
as.numeric(as.character(testVecFac))

##A final note: you may notice that read.table() will treat any strings as factors
##when loading. You can override this behavior by setting the argument stringsAsFactors
##to FALSE (refer to ?read.table for more information.)
##whether you will want your strings represented as characters or factors is dependent
##on the application.  

testTable <- read.table("mouseData.txt", header=TRUE)
summary(testTable)
##you can always cast a factor as a string, remember
testTable$Strain <- as.character(testTable$Strain)
summary(testTable)

##let's try to read the table as characters
testTable2 <- read.table("mouseData.txt", stringsAsFactors=FALSE, header=TRUE)
##note the numeric property of Weight is preserved
summary(testTable2)


#################################
###Part 2: More about Data Frames
#################################
##data.frames consist of associated vectors that have the same length
##in a matrix-like format
##columns do not have to be the same data type; can mix
##boolean, character, factor, and numeric data types in the same data frame

##show a dataframe example (that we have already seen)
MouseFrame

##dataframes have two properties: number of rows
##and number of columns

nrow(MouseFrame)
ncol(MouseFrame)

##can also get both of these properties by dim
dim(MouseFrame)

##show only the first five rows
##useful for checking that you read in data properly
MouseFrame[1:5,]

##QUESTION: note that the column of each data frame is pretty much a vector, but a
##row is actually a list. Why is that?

##data frames have two kinds of names associated with them:
##column names (usually corresponds to variables):
colnames(MouseFrame)

##row names (usually subjects (such as patients) or gene names)
##one requirement of rownames is that each row name is unique
##so that subsetting by name will return a unique result. Patients
##and genes tend to have a unique identifier that we can use. In
##this case, the unique identifier is the MouseID
rownames(MouseFrame)

##access only the Weights column of MouseFrame
MouseFrame$Weight

####QUESTION 2-1: what happens when you access the Gender column?
####How does it differ from the weights column?
####Hint: use class() to compare the different columns

##summarize mouse frame
summary(MouseFrame)

####QUESTION 2-2: How many Males and Females are there?
####Is this a balanced design?

##initializing a dataframe from a set of vectors
factorVec <- factor(c("A", "A", "B", "C", "C"))
massVec <- c(12, 1.4, 2.4, 6.4, 10)
nameVec <- c("Moe", "Minnie", "Curly", "Mickey", "Larry")

dF <- data.frame(nameVec, massVec,factorVec)

##note that column names are derived from the original vector names
##however, using assignment, you can change the column names when you 
##initialize them.
##in terms of reproducibility, try to make a new copy of a data frame
##whenever you manipulate the contents.  This leaves a clear audit trail
##in your script.

dF2 <- data.frame(idVec=nameVec, mass=massVec,class=factorVec)

##can also add an extra column to a data frame

anotherVec <- c(1,4,4,10,10)

dF3 <- data.frame(dF2, anotherVec)

##accessing individual columns can also be done using $
##this is useful for filtering operations

dF3$anotherVec

##if you need to do a lot of column based opertions on a data.frame,
##you can use attach()
attach(dF3)
idVec
mass

##when you're done with manipulating the data frame, remember to detach it.
##otherwise things get confusing, especially when you have data frames
##with identical column names.

detach(dF3)


#######################################################
##Part 3: Subsetting
#######################################################
##Many data structures can be subsetted to produce a smaller result set
##We've encountered this by using numerics, grabbing the first five rows
##mouseFrame
MouseFrame[1:5,]

##we can mix subsetting vectors as well, grabbing only the first five rows and
##the Strain and Weight Columns
MouseFrame[1:5,c("Strain","Weight")]

##if we don't want a column or row, we can remove it by using the "-" operator.
##note that this doesn't work for any index vectors except the numerical index.
##I tend not to use this and instead will use a colnames or rownames subset as above.
MouseFrame[-c(1:3), -1]

##another way of subsetting is by using a boolean vector, which seems kind of dumb,
##until you realize that you can generate this boolean vector using other methods.
##(see Part 4).  In general, we are trying to avoid hardcoding values, and subsetting
##on specific criteria makes our code more generalizable.

MouseFrame[,c(TRUE,TRUE,FALSE)]

####QUESTION 3-1: what happens when you use a boolean vector that's shorter than the number
####of columns? What happens with the remaining columns?  Are they returned?

####QUESTION 3-2: How would we select every third row? Hint: help("%%")

#######################################################
##Part 4: Filtering
#######################################################
##filtering operations are done by generating a boolean vector using a comparator
##such as <, >, or ==
##Here's how to filter on a vector to select those weights with only 

weights[weights < 50]

####QUESTION 4-1: What does the comparator operator 
####weights < 50
####generate? Why does it work?

#Filtering on a data frame is identical to filtering on a vector
#note that we must filter on a column as a criterion.
#specifically, both MouseFrame$Gender and 
#subsetting data frames - filtering
#select only females

MouseFrame[MouseFrame$Gender == "F",]

####QUESTION 4-2: What does 
####MouseFrame$Gender == "F" 
####do?  Why does it select the correct cases?


####QUESTION 4-3: how do you select females of strain D2?
#Hint: it's ok to use more than one operation
#Hint: you can also chain selections using the & (and) or the | (or) operators
#Hint: don't forget the comma!

####QUESTION 4-4: How would we select those mice with a weight
####less than 50 grams?

##chaining subsetting and filtering operations
##the difference between subsetting and filtering is largely semantic, but you
##can think of filtering as part of subsetting operations using some sort of
##conditional operators.

##because they are essentially producing the same thing (boolean vectors), you can 
##use a combination of subsetting or filtering operators to produce a reduced dataset

MouseFrame[MouseFrame$Strain == "B6", c("Strain","Weight")]

##many statistical methods may require you to recode a group
##ifelse() works very well for this when you have two groups. 
##ifelse() takes a test condition, such as a filtering operation, and
##will produce a code (in this case 1) if the condition is true and another
##code (in this case 0) if the condition is false.

lowWeight <- ifelse(test = MouseFrame$Weight < 45, yes = 1, no = 0)

####QUESTION 4-5: produce a cross table between MouseFrame$Strain and lowWeight
####(you may need to cast lowWeight as a factor).  Do Weight and Strain appear to
####be associated?

##############################
#Part 5: Sampling and ordering
##############################
###Both sampling and ordering can be thought of as subsetting operations as well.
###Let's sort MouseFrame by Weight

####QUESTION 5-1: what does order() do? How can you use it to sort a data frame?
order(MouseFrame$Weight, decreasing=TRUE)

###we can also specify sorting by multiple factors
order(MouseFrame$Weight, MouseFrame$Gender)

####QUESTION 5-2: How can we sort the data frame by Strain then Weight?

#Let's produce bootstrap samples of our dataframe

####QUESTION 5-3: What does the sample() code below do?  How
#####can we use it to produce samples of our dataframe?
sample(1:nrow(MouseFrame), 5, replace=TRUE)

####QUESTION 5-4: Produce a bootstrap sample without replacement of 7 rows
####of MouseFrame. Confirm that you have sampled unique rows in your dataframe.

###A note about make.names()

###***FINAL PROBLEM: Load the iris dataset using data(iris). (this will load the data
###***as the iris object).  
###***
###***Produce two different data frames for the setosa and virginica
###***species, selecting the Petal.Length and Petal.Width columns.  
###***
###***How many setosa samples have a Petal Length less than 3.5? 
###***How many virginica samples have a Petal Width less than 2.0?
