# Resources ---------------------------------------------------------------

# Credit to https://happygitwithr.com/ for a lot of guidance in making this - check the link for more detailed instructions and explanations of each step.
## I do deviate from this site a bit in this guide, but both versions should work, depending on your preferences.

# Connecting Git and Github https://docs.github.com/en/get-started/getting-started-with-git/set-up-git

# Connecting Github and RStudio: https://resources.github.com/github-and-rstudio/

# Other: https://r-bio.github.io/intro-git-rstudio/

# Intro -------------------------------------------------------------------

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


# Install usethis package -------------------------------------------------

install.packages("usethis")

# Install Git--------------------------------------------------------------

# Mac users: you may already have git installed. Open your native command terminal and type git --version
# If you have git already, a version number will appear. Horray! You don't need to install anything. Move to the next step.
# If you don't have git, you will get an error. You need to install Git (instructions below).

# Go to https://git-scm.com/downloads and install Git

# Check the experimental options first check option (something about pseudo controls)

# Windows users: after install, open Git Bash and make sure it's working.

# -------- STOP HERE FOR PREP - WE WILL DO THE REST TOGETHER --------------

# Introduce yourself to Git -----------------------------------------------

# Once Git is installed, we need to configure the settings so Git knows who you are.

# NOTE: You muse use the email that is associated with the Github account you created.

## Option 1: Shell terminal -----------------------------------------------

# To configure Git, we can use the "shell" or command terminal outside of R or RStudio.
# For Mac users, you can use your native command terminal.
# For Windows users, can use something called Git Bash which you installed along with Git.
# In the terminal (Mac) or Git Bash (Windows), set your username and email with the following commands:

# git config --global user.name "Your Name"
# git config --global user.email youremail@example.com

## Option 2: RStudio -----------------------------------------------------------

# Alternatively, you can configure git in R using the usethis package:
usethis::use_git_config(user.name="Your Name", user.email="youremail@example.com")

# Connect Git and Github -------------------------------------------------------

# To connect Github and Git, you can use one of two options: HTTPS or SSH. HTTPS is much easier to use and is recommended for first time users. We will go over how to do this using HTTPS.

# If you want to know more about the difference between HTTPS and SSH, you can learn more here: https://happygitwithr.com/https-pat#https-vs-ssh. If you decide you want to use SSH, you can find instructions here: https://happygitwithr.com/ssh-keys

# Go back the command terminal (native terminal for Mac, Git Bash for Windows). We first need to install a credential cache manager.

# Mac users, install Homebrew:
# brew install gh

# Windows users, install Winget:
# winget install --id GitHub.cli

# Close and reopen the terminal (Bash or native)

# Once this is installed, type the following into your command terminal:
# gh auth login
## When prompted for your preferred protocol for Git operations, select HTTPS.
## When asked if you would like to authenticate to Git with your GitHub credentials, enter Y.
## You can either authenticate in your browser or generate and paste a personal access token (PAT - see optional instructions below)
## If you use the browser option, press enter to open the web browser. Don't copy the one-time code directly from git, as the copy/paste bindings are different. Just manually type in the one-time code in your browser.

## Note: If this doesn't work for you, you may have to reinstall Git with different settings. Reinstalling Git with the option "Enable experimental support for pseudo consoles" fixed the issue for me.

# Congrats! Git and Github are now connected.

## OPTIONAL: Generate a personal access token -----------------------------------

# Go to https://github.com/settings/tokens and click "Generate token"

# Alternatively, run this line in R:
usethis::create_github_token()

# Give your token a name. This could be the name of the computer you are currently using, for example.

# Look through the options - it's recommended to check "repo," "user," and "workflow"

# Click "generate token"

# Copy the PAT

# You should treat this PAT like a password. You can store it in a secure password keeper, you can store it in R (instructions here: 9.4 Store your PAT https://happygitwithr.com/https-pat#https-vs-ssh), or you can just keep it in your clipboard for the time being. You should not hard code your PAT into a command line.

# Connect Github and RStudio --------------------------------------------------

# Create a new repository in Github by clicking "Repositories" and the big green "New" button. 

# Name your test repo. You can just call it "testrepo" or something similar - we will delete this later.
# Feel free to add a description like "test repository to connect Github and RStudio"
# You can make it public or private
# Click "create repository"

# In your new repository, click the green button that says "<> Code"
# Under "Clone," Copy the HTTPS URL

# Back in RStudio, create a new project by cloning your new Github repository:

usethis::create_from_github(
  "https://github.com/USER-NAME/REPO-NAME.git", # HTTPS URL that you copied earlier
  destdir = "C:/your/desired/location/" # The file directory where you want your folder to be created (I usually put them on my desktop)
)

usethis::create_from_github(
  "https://github.com/kyra-ricci/test.git",
  destdir = "C:/Users/kyrad/Desktop"
)

# Alternatively, if you go to File > New Project, you may have the option to clone from a Github repo from the windows.

# Nice work! This RStudio project and Github are now talking to one another.
# You can do this each time you start a new project. 


# Make local changes, save, and commit ------------------------------------

# In the project you just created and connected to Github, create a new blank R script called "test.R".
# Edit this script by adding any text or line of code, e.g.,:

# this is a test

# Click the “Git” tab in upper right pane (or the same pane where you usually find your Environment if it's not in the upper right).

# If you don't see the Git tab, go to Tools > Global Options > Pane Layout > and make sure you have "VCS" checked in your environment tab

# This is where you will interface with Git/Github. You should see three columns: "Staged", "Status", and "Path".
# Check “Staged” box for test.r.
# If you’re not already in the Git pop-up, click “Commit”.
# Type a message in “Commit message”, such as today's date and your initials, or a description of what you have changed (e.g., "test for RStudio and Git").
# Click “Commit”.

# Pushing to Github -----------------------------------------------------------

# To send your newly committed changes to Github, you need to "push" your local changes. 

# Once you have committed all of the changes you want to make locally, click the "Push" button (with the green arrow) in the Git tab.
# You should get a popup window which will tell you if the changes were pushed successfully.

# Go back to Github and refresh this repo. Your changes should be updated here!

# If you've encountered issues somewhere along the way, check this guide to see if you can troubleshoot your issue: https://happygitwithr.com/troubleshooting


# Connecting a second computer --------------------------------------------

# Now that you have made changes to your project and have pushed your local changes to Github, you can retrieve those changes on a second computer if you would like. You can do this using the same process you used to create your test directory

# Go to Github and copy the HTTPS URL of the desired repo (found in <> Code). Let's practice by cloning my hacky hour repo found at: https://github.com/kyra-ricci/bu-hackyhour

# Use the usethis package to clone the repo

usethis::create_from_github(
  "https://github.com/kyra-ricci/bu-hackyhour.git", # HTTPS URL that you copied earlier
  destdir = "your/desired/location", # The file directory where you want your folder to be created 
  forks = FALSE # you may need this line if it doesn't work
)

# This will clone the repo and open it in a new session. You can now push and pull changes from this repo.

# When you're done working on one computer, push your changes to Gtihub.
# To update your second computer with those changes, click the "Pull" button (blue arrow) in the Git tab. This will recieve the latest updates so you can work seamlessly on your other computer.

# The principle is the same if you have a collaborator working in the same repo. You can "Pull" any changes that they have "Pushed."

# You can also upload and change files directly on Github. Just remember to pull those changes locally before continuing to work.

# REMEMBER TO STAGE, COMMIT, AND PUSH YOUR CHANGES OFTEN!


# Notes -------------------------------------------------------------------

# Pick a way to store hacky hour files long-term (this repo or should someone else make it?)

# Test out changing this file and pushing to Git

# Once we pick a location, everyone use Github site to create a new folder and upload documents to practice using the online functions

# Mention Gitignore

# Look at the Git tab in RStudio - especially status and branching

# Mention branching - should we experiment?

# Newest line - changes on Github

# Cloning Stat rethinking summer Github

install.packages("usethis")

usethis::create_from_github(
  "https://github.com/BinghamtonBioHackyHours/Summer-2024-Statistical-Rethinking.git",
  destdir = "C:/Users/kyrad/Desktop"
)
