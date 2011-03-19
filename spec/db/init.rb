require File.dirname(__FILE__) + '/test_database'

TestDatabase.initialize

class Project < ActiveRecord::Base
end
