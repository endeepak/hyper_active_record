Description
===========

Hyper Active Record is to showcase the features that would make active record super awesome

Install
=======

    gem install hyper_active_record

If you are using bundler - add dependency in gem file

    gem 'hyper_active_record'

What do you get
===============
Hyper Active Record adds the ability to query active record models by virtual attributes. This is achieved by *enhancing* the active record query methods *where, all, count* to allow scope names in conditions. It works just like passing column names in conditions. The scope on a model acts as a virtual column.

For example : If Project model is defined as

      class Project < ActiveRecord::Base
        #Columns - :name, :start_date, :end_date, :priority
        scope :started_after, lambda { |date| where('start_date > ?', date) }
        scope :completed, lambda { where('end_date IS NOT NULL') }
      end

You can do

      Project.where(:completed => true, :started_after => 2.years.ago, :priority => 1)

This works on any active record relation

      Company.projects.where(:completed => true, :started_after => 2.years.ago)

Also you can use *scoped_by* method on a active record relation. This method accepts a hash of scope name and parameters and returns a scoped object.

      Project.scoped_by(:completed => true, :started_after => 2.years.ago)

How is this useful?
===================
You can use this to search a model by the query parameters(may be from a search form) in the index action of a controller. The query parameters can be a combination of database columns and virtual columns (provided a scope is defined for the virtual column).

If you are already using [inherited\_resources](https://github.com/josevalim/inherited_resources) and [has\_scope](https://github.com/plataformatec/has_scope), unit testing the controller would become simpler if implementation has\_scope is changed to just pass all the query params to *where* or *all*  method on the model. This would eliminate the need of data setup for testing the has\_scope declaration on a controller. With this change you can just mock the model's query method to verify the scope name was passed as a condition in the method parameters.

What next?
==========
The intention of this gem is to just get a feel of the benefits from this feature.

 I would like to see these features built into the active_record instead of a monkey patch like this.