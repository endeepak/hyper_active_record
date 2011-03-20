require 'factory_girl'
require File.dirname(__FILE__)+ '/factories'

require 'hyper_active_record'
require File.expand_path(File.dirname(__FILE__) + "/db/init.rb")

RSpec.configure do |config|
  # config.before(:each) { Project.delete_all }
  # config.mock_with :mocha
end
