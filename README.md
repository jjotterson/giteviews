# Git or Git GUI Eviews add-in

- This repository contains the add-in used to run Git from EViews
- The implementation needs Git and R installed in the computer

## Core folders/files:

- ./giteviews.prg is the EViews program that executes any git command line 
- ./giteviews_gui.prg runs Git GUI
- ./Docs contains the documentation of the add-in
- ./Installers/kmeans.aipz contains the needed files such that opening it will begin the EViews install process on your PC


## Installing giteviews add-in

- Git users: clone the repo to your local machine & run ./installers/giteviews.aipz
- Non-Git users: click the "view raw" link at: .../kmeans.aipz
- Click yes to all the buttons - giteviews add-in is now installed!
- Open up the docs in your add-in manager to see an application & documentation