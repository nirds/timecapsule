# timecapsule

![Gem Version](https://badge.fury.io/rb/timecapsule.png)
![Build Status](https://travis-ci.org/nirds/timecapsule.png?branch=master)
[![Code Climate](https://codeclimate.com/github/nirds/timecapsule/badges/gpa.svg)](https://codeclimate.com/github/nirds/timecapsule)

Gem for importing and exporting ActiveRecord data as CSV files.
Great for creating seed data from data entered through your app's UI or the console.

## Install:
Add it to your Gemfile
```
gem 'timecapsule'
```

Or install it to your system:
```bash
$ gem install timecapsule
```

For Rails <3.0 use:
```bash
$ gem install --version '= 1.0.0' timecapsule
```

## Usage:

***As a Rake Task***

* Export all models as individual CSV files. *If your database is huge, this could take a while.*
```bash
$ rake timecapsule:all
```

* Export a model from your app to a CSV file. User model as an example.
```bash
$ rake timecapsule:users
```

* To view all models that timecapsule can export:
```bash
$ rake -T
```

***For Rails Console***

* Export a model from your app to a csv file via rails console.
```ruby
Timecapsule.export_model(User)
```
* Import a model from the csv file:
```ruby
Timecapsule.import_model(User)
```
* To specify a different import or export directory, besides the default db/seed_data, open the automatically generated `config/timecapsule.yml` file and change the export directory.
* To import all the csv files in your import directory call the import method:
```ruby
Timecapsule.import
```
* If the order of import matters for your models, you can specify the order at export time:
```ruby
Timecapsule.export_model(User, 1)
Timecapsule.export_model(Post, 2)
```
* Remember that if you want to maintain relationships between import/export
  you must reset the primary key sequence (id) for each of the tables for your models.
  Or drop and re-create your database.

Copyright (c) 2011-present MIT

Authors: Renée Hendricksen, Kerri Miller, Risa Batta
