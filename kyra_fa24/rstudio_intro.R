# Physical layout --------------------------------------------------

# Source panel = where your scripts are = gets saved
# Console panel = where your outputs are = not saved, but you can type code in
# Environment panel = your saved environment
# Lower right panel = files, plots, packages, help, etc.

# You can change the orientation of your panels in Tools > Global Options > Pane Layout
# You can change the color of your RStudio theme in Tools > Global Options > Appearance

# When you add a # in front of content, R will ignore it. This is how you add comments.
# If you want to run code, you should not have a # in front

# Projects -------------------------------------------------------

# Create new project using either:
## File > New Project 
# or
## Upper right hand corner - should be a box with an R in it - click it and click New Project

# Select New Directory
# Select New Project
# Name your project folder (e.g., "hackyhour")
# Select where you want the project to be located (it will create a new file folder in your file explorer) - e.g., I usually put them on my desktop
# R should open in a new session and the top right corner should have the box with the R and the name of your new project

# Source + console panels -----------------------------------------

# Create a new R script file (File > New File > R Script) and name it "test"
# R is fundamentally a computer. In your script files, you can ask it to do things like simple math problems:

4 + 10 

# Highlight and press "Run" OR use Ctrl + Enter when your cursor is at the end of the line you want to run
# Notice that the script file you are typing in did not change.
# Look below at the console. You should see the code you just typed (4 + 10) followed by the output delivered by R (the answer: 14)

# Edit your problem above to be 4 + 11 instead of 4 + 10 and run it again
# Notice that new content is added to the console. The old query and response are still in the console even though it has been edited in the script.

# Try putting your cursor down in the console and typing a different problem (e.g., 20 + 14) and press enter
# Notice how nothing has changed in the script file
# Try to edit the problem in the console

# Script files = permanent text that you can save
# Console = impermanent text that will disappear when you close your R session; but this is where you will see the outputs/results

# Environment ----------------------------------------------------

# The environment is used to store data and variables

# Add some variables to your environment
# Don't worry about the code or what it's doing, just notice how the panels change

x <- 1:100 # variable x is a vector list of the numbers 1-100 (1, 2, 3, 4, 5, ...)
y <- x * 2 # variable y is a vector list 100 numbers which are x*2 (2, 4, 6, 8, 10, ...)

# Notice how the code appears in the console
# Notice how the environment now has two variables, x and y
# Add another variable z using the console by entering this code: z <- x + 10
# New variable z now appears in the environment
# Call variables to inspect them in the console
x
y
z

# Use the broom to clean your environment 
# Run the code above again to repopulate the environment. Why do we get an error that 'z' is not found?
# Always start with a fresh, clean environment

# Bottom right pane -------------------------------------------------

# Files tab: should contain the files in your project just like a file explorer

# Plots tab: When you make figures/plots, they will appear here. Use the variables we created earlier to see an example:
plot(x,y)
plot(y,x)
# Press back and forward arrows in plots tab to get previous plots

# Packages tab: will have a list of all of the packages you've installed (we will talk about packages later, just know that it's here)

# Help tab: Every function in RStudio can be queried to ask, how do I use this? Do this using ? followed by the function name
?boxplot
?lm
?data.frame
# Press back and forward arrows in help tab

# Basic Atomic Classes and Data Structures --------------------------------

#5 main types of atomic classes (depending on who you ask)
#Logical (T/F)
#integer (2L)
#numeric (real or decimal)
#complex (3i)
#character('a')

##Different Types of Data Structures: ----------------

#vectors: most common data structure in R
#Two types: atomic vectors (vectors of characters, logical, integers, or numeric) and lists 

#general pattern of a vector:
#x <- vector(class of object, length)
#you can also use c() to make a vector -- c() stands for concatenate

#Let's make an empty vector:
a <- c()
#this creates an object in your global environment named 'a'. If you take a look in your environment, you'll see that the value stored in 'a' is NULL

#Let's add some values to 'a'
a <- c(0, 1, 1, 2, 3, 5, 8, 13, 21) #creates a numeric vector

#Let's make a character vector
flowers <- c("sunflower", "rose", "lily", "daisy", "tulip") #notice how we popped them in quotes and it turned the text green? If we leave the words out of quotation marks, R doesn't recognize it as text and will think you are typing a command incorrectly. Try leaving out the quotes and see what happens.

#Matrices: a special type of vector - contains rows and columns (is a 2D data structure)

#let's make a matrix that stores values 1-9
#we'll want to save it as an object, so let's give it a name
max <- matrix(1:9, nrow = 3, ncol = 3) #the matrix() function creates the matrix. 1:9 tells R that we want to include values 1 through 9 (':' denotes that in R) and nrow/ncol= 3 tells R we want three rows and three columns

#let's view max
max
#you'll see we have three rows and three columns, but they are unlabeled. Take a closer look at you'll see all of the numbers for columns have a comma in front of them and all of the numbers for rows have a comma after them. This has to do with bracket ([n,m]) notation in R. The notation is [row, column].

#what if we want to give our rows and columns names?
colnames(max) <- c("A", "B", "C") #here we are telling R we want to store the following column names in max
rownames(max) <- c("a", "b", "c") #here we are telling R we want to store the following row names in max

#let's view it again
max
#now we have row and column names!

#lists: lists are vectors that contain other objects. They can have any data type, so each element of a list can be a different class.

stuff <- list(1, "beetle", TRUE, 1+4i) #here we have a list with classes of number, character, logical, and complex
str(stuff) #this lets you check the structure of your data.

#Factors: special vectors that represent categorical data. These are really useful when you are modeling and plotting - we'll come back to these later!

#data frames: data structure for most tabular data and what we use for statistics. We generally create them in R using read.csv() or read.table(), but this week we are going to use a dataset already built into R.

#Iris is a dataset built into R. It was introduced by Ronald Fisher in his paper 'The use of multiple measurements in taxonomic problems'. It has data for three plant species (setosa, virginica, and versicolor) and four measurements for each species. Let's take a look at the data

#let's save it as an object in R so we can manipulate it
dat <- iris

#lets take a look at the first six rows of data
head(dat) #head() automatically lets you look at the first six rows.
#What if we want to look at the first 10 rows?
head(dat, n = 10) #adding n= 10 tells R we want to look at a different number of rows.

#What about bracket notation?
dat[1:6,] #this tells R we want to look at rows 1-6 and all columns

#What if we want to see the last six rows of data?
tail(dat) #tail() works just like head() but shows us the 'tail' end of the data instead of the beginning

#Lets check the structure of our data
str(dat) #all variables are numeric except Species - it is already set to a factor
#what about the dimensions of our data?
dim(dat) #this tells us we have a data frame with 150 rows and 5 columns
#We can check this individually using the following commands:
nrow(dat) #gives us the number of rows in dat
ncol(dat) #gives us the number of columns in dat

#what if we just want the column names?
names(dat)

#What if we are only interested in one column? How can we take a look at it?
dat$Species #the '$' is a logical operator that tells R we are interested in the "Species" column in the data frame dat

#If we want to make a new column in dat, we can use the "$" operator
dat$test <- 1 #this tells R that in the data frame 'dat' we want to create a new column named "test" and we want to store '1' in that column.
#Let's take a look at the structure of our data:
str(dat)
#you'll see that we now have a sixth column called 'test' that has '1' stored in it!

#What if we are only interested in one of the three species? Can we use the '$' operator to create a separate data frame with only 'virginica'?
#Yes! What we will need to do is subset the data to include only values related to 'virginicia'. We can do this by creating a new object in R. We'll call it 'virginica'.
virginica <- subset(dat, dat$Species == 'virginica')
#the subset function tells R we want to subset the data, but we need to tell R where to look. To do that, we have to include 'dat' followed by a comma and dat$Species. This tells R we are using the dat data frame and we are specifically interested in the 'Species' column. The '==' is a logical operator and it is telling R we are only interested in values that are 'absolutely equal to' virginica.

#let's check out our new data
head(virginica)
dim(virginica) #now we have a data frame of 50 rows and 6 columns

#What if we are interested in Virginica and Setosa but NOT Versicolor?
vs <- subset(dat, dat$Species != "versicolor") #we are using the subset function again, but we've changed our logical operator. Here, the "!" means "NOT". The "!=" tells R we are interested in all species in dat except for versicolor.

#lets check out our new data frame
dim(vs) #we now have a data frame of 100 rows and 6 columns

#how can we be sure that we didn't accidentally include 'versicolor'?
which(vs == 'versicolor') #this command is asking R which of the variables in R is absolutely equal to versicolor
#integer(0) tells us that none of the values stored in vs are versicolor.

#What if we are interested in the mean value of Sepal Width across all species?
mean(dat$Sepal.Width)
#What about the maximum and minimum values?
max(dat$Sepal.Width)
min(dat$Sepal.Width)

#Here is a link to a great R cheat sheet: https://images.datacamp.com/image/upload/v1697642178/Marketing/Blog/R_Cheat_Sheet_PNG_1.pdf

#This will cover a lot of what we talked about and go a little deeper into some newer functions.

#Basic Plots Using Our Data Frames ---------------------------------------

#what if we want to see a histogram of Sepal length in data?
hist(dat$Sepal.Length) #the hist() command tells R we want a histogram
#what about in vs?
hist(vs$Sepal.Length)

#Try it on one of the other variables!

#What if we are interested in the relationship between petal length and petal width?
plot(dat$Petal.Width ~ dat$Petal.Length)
#The above code creates a scatter plot with petal width as the response (dependent) variable and petal length as the independent variable.

#how does this look different when we use our "vs" dataset?
plot(vs$Petal.Width ~ vs$Petal.Length)

