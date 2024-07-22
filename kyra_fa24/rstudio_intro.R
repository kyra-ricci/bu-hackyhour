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

# 


# Source + console panels -----------------------------------------

# Create a new R script file (File > New File > R Script)
# R is fundamentally a computer. Using your source and console panels, you can ask it to do things like simple math problems:

4 + 10 

# Highlight and press "Run" OR use Ctrl + Enter when your cursor is at the end of the line you want to run
# Notice that the script file you are typing in did not change.
# Look below at the console. You should see the code you just typed (4 + 10) followed by the output delivered by R (14)

# Edit your problem above to be 4 + 11 instead of 4 + 10 and run it again
# Notice that new content is added to the console, not edited

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
