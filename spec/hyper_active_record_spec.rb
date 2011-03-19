require 'spec_helper'

describe HyperActiveRecord do
  describe "all" do
    Project.class_eval do
      scope :started_after, lambda { |time| where('start_date > ?', time) }
    end

    it "should be queryable with scope name" do
      old_project = Factory(:project, :start_date => 2.years.ago)
      new_project = Factory(:project, :start_date => Date.today)

      Project.all(:conditions => {:started_after => 1.year.ago}).should == [new_project]
    end

    it "should be queryable with combination of column name and scope name" do
      old_critical_project = Factory(:project, :start_date => 2.years.ago, :priority => 1)
      new_simple_project = Factory(:project, :start_date => Date.today, :priority => 2)
      new_critical_project = Factory(:project, :start_date => Date.today, :priority => 1)

      Project.all(:conditions => {:started_after => 1.year.ago, :priority => 2}).should == [new_simple_project]
    end
  end
end