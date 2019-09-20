# Mensajasser

Although publicly accessible, the Mensajasser-Project is not meant for wide distribution but for a single use. It is the Statistic-System for a group of friends playing the swiss popular game "Jass" (namely the "Offener Differenzler"). It consists of: 

* A very rudimentary Authentification System (User-Controller), controlling who can enter and change results. 
* The Model with a Round (or Tableau or Ris), Consisting of 4 differenz Jassers (Players) and their results in this round. 
* The Statistics, which are presented in the Ranking-Controller. 



## System dependencies & Configuration
To run this project, you need: 
- Ruby, at least version 2.5.1 (I use rvm for keeping track of ruby versions)
- Rails 5.2.1  (gem install rails)
- Bundler (gem install bundler)
- Postgres
everything else should get installed when running "bundle install"

## Database 
Once Postgres is installed, you should create the databases according to config/database.yml. 
createdb mensajasser_development
createdb mensajasser_test

## Testing
Testing is rudimentary, but running 
rails test
should produce no errors. 

## History
v0.01: Spahni started tracking our games in the Mensa Hauptgebäude in an Excel-Sheet 2002  
v0.1:  mensajasser.mullzk.ch as a PHP-Code-Monster, starting in 2003  
v1.0:  Ported to jasser.mullzk.ch in 2010, as a Rails 2.3-project on Ruby 1.8.7. After Release, the code was not touched anymore, as Updates would have been more and more punitive because of Upgrade to Rails and Ruby  
v1.1  Built in 2018 as a new project on current, stable versions of Rails and Ruby, developed with github and heroku. No new features compared to v1.0, in some cases improved code, more tests.  
v2.0  (2018, this version): 
- Improved Code, especially an improved model. 
- Berseker, Schädlings- und Angstgegner-Statistiken
- Grafiken
- Mobilefriendly layout
- Improved Form for adding new rounds
- Favicon
- Encoding Email-Adresses

## Todo
- A better form for adding new rounds (multi-page-form?)
- Graphs with comparisons with other jassers
- Testing of graph-controller
- System-Tests
- per-jasser-Statistik

## Maintenance
git pull  
git checkout dev-branch  
bundle update 		# Updates *all* gems in Gemfile  
rails test			# runs test-suite  
git add . && git commit -m "Updates" && git push # pushs into dev-branch  
 # Make sure, that heroku dev-app automatically deploys dev-branch, wait until deployed  
 # Test dev-app  
git checkout master  
git merge dev-branch  
rails test  
git add . && git commit -m "Updates" && git push  # pushs into master  
Make sure, that heroku prod-app automatically deploys master, wait until deployed  
git checkout dev-branch # No working in master  