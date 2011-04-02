Description
===========

Hyper Active Record is to showcase the features that would make active record awesome

Install
=======

    gem install hyper_active_record

If you are using bundler - add dependency in gem file

    gem 'hyper_active_record'

What do you get
===============
The active record methods *where, all, count* can take scope names as conditions. It works just like passing column names in conditions. Hence the scope on a active record acts as a virtual column.

For example : If Project model is defined as

      class Project < ActiveRecord::Base
        #Columns - :name, :start_date, :end_date, :priority
        scope :started_after, lambda { |date| where('start_date > ?', date) }
        scope :completed, lambda { where('end_date IS NOT NULL') }
      end

You can do

      Project.where(:completed => true, :started_after => 2.years.ago, :priiority => 1)

This works on any active record relation

      Company.projects.where(:completed => true, :started_after => 2.years.ago)

Also you can use *scoped_by* method on a active record relation. This method accepts a hash of scope name and parameters and returns a scoped object.

      Project.scoped_by(:completed => true, :started_after => 2.years.ago)