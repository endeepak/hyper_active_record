require 'spec_helper'

describe HyperActiveRecord::QueryMethods do
  describe "all" do
    before(:each) do
      class Project < ActiveRecord::Base
        scope :started_after, lambda { |time| where('start_date > ?', time) }
        scope :completed, lambda { |time| where('end_date IS NOT NULL') }
      end
    end

    after(:each) do
      Project.scopes.clear
      Project.delete_all
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

    it "should raise error when scope or column does not exist" do
      lambda {
        Project.all(:conditions => {:non_existing_scope => 1.year.ago})
      }.should raise_error(/no such column: projects.non_existing_scope/)
    end

    it "should apply scope when scope name is same as column name" do
      Project.class_eval { scope :priority, lambda { |value| where('priority <= ?', value) } }
      project_1 = Factory(:project, :priority => 1)
      project_2 = Factory(:project, :priority => 2)
      project_3 = Factory(:project, :priority => 3)

      Project.all(:conditions => {:priority => 2}).should =~ [project_1, project_2]
    end

    context "for scope which does not take parameters" do
      it "should apply scope when value is true" do
        project_1 = Factory(:project, :end_date => Date.today)
        project_2 = Factory(:project, :end_date => nil)
        project_3 = Factory(:project, :end_date => Date.today)

        Project.all(:conditions => {:completed => true}).should =~ [project_1, project_3]
      end

      it "should not apply scope when value is false" do
        project_1 = Factory(:project, :end_date => Date.today)
        project_2 = Factory(:project, :end_date => nil)
        project_3 = Factory(:project, :end_date => Date.today)

        lambda {
          Project.all(:conditions => {:completed => false})
        }.should raise_error(/no such column: projects.completed/)
      end
    end
  end
end