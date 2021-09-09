# backup.rb
Script for load databases backups from remote to local database

## Prerequisites
* For postgresql install postgresql-client package

## How run it
Install gems

`bundle install`

Only download backup:

`bundle exec ruby backup.rb config_name stage`

Download backup and apply in local db:

`bundle exec ruby backup.rb config_name stage apply`