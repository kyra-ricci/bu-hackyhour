
# Intro -------------------------------------------------------------------

# Credit to https://happygitwithr.com/ for a lot of guidence in making this - check the link for more detailed instructions and explanations.

# Git is a version control system - it was made for developers who may have more than one person working on code at the same time. It is kind of like "Track Changes" in Word.

# Github is a third party website that hosts and stores Git projects so you can access it online and on your computer. It's kind of like Dropbox but much better for code. Github allows you to make both private projects (for only you and any collaborators you invite) as well as public projects that anyone can see and add to/improve on.

# While you might not have multiple people working on your code, Github is still really useful for things like backing up your files, collaborating, publishing your code alongside a manuscript, and/or working on multiple computers (e.g., laptop and home computer and lab/field computer).

# The best way to understand is to go ahead and get started! Follow the steps to start your Github + R integration journey below.


# Make a Github account ---------------------------------------------------

# Create a free account on https://github.com/

# Choose your username carefully - you can change it later but this process can be complicated. HappyGitwithR suggests using some version of your name and/or some version of your username across other social media you use professionally (e.g., my username is just my name: kyra-ricci)


# Update R and RStudio -----------------------------------------------------

# Check your current version of R
R.version.string

# as of 4/18/2024, the current version of R is 4.3.3. If you are not up-to-date, now is a good time to update your R via 
# https://cloud.r-project.org/

# Download R Studio and/or update R Studio to most current version via 
# https://www.rstudio.com/products/rstudio/download/preview/

# Update your R packages. This may take a few minutes.
update.packages(ask = FALSE, checkBuilt = TRUE)

# Install Git--------------------------------------------------------------

# To configure Git, we will have to use the "shell" or command terminal outside of R or RStudio.
# For Mac users, you will use your native command terminal.
# For Windows users, you will use something called Git Bash which you will install along with Git.

# Mac users: you may already have git installed. Open your command terminal and type git --version
# If you have git already, a version number will appear. Horray! You don't need to install anything, but you will still need to configure the settings.
# If you don't have git, you will get an error. You need to install Git.

# Go to https://git-scm.com/downloads and install Git
# Windows users: after install, open Git Bash and make sure it's working.



# ----- STOP HERE FOR PREP - WE WILL DO THE REST TOGETHER ----------------




# Configure Git -----------------------------------------------------------

# Once Git is installed, we need to configure the settings so Git knows who you are.
# In the terminal (Mad) or Git Bash (Windows), set your username and email with the following commands:

# git config --global user.name "Your Name"
# git config --global user.email youremail@example.com

# NOTE: You muse use the email that is associated with the Github account you created.

# Alternatively, you can configure git in R using the usethis package:
usethis::use_git_config(user.name="Your Name", user.email="youremail@example.com")






