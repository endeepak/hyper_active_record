require 'spec_helper'

describe HyperActiveRecord::QueryMethods do
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

  context "with scope name" do
    it "should apply scope" do
      old_project = Factory(:project, :start_date => 2.years.ago)
      new_project = Factory(:project, :start_date => Date.today)

      Project.all(:conditions => {:started_after => 1.year.ago}).should == [new_project]
    end
  end

  context "with combination of column name and scope name" do
    it "should apply scoped and match by column value" do
      old_critical_project = Factory(:project, :start_date => 2.years.ago, :priority => 1)
      new_simple_project = Factory(:project, :start_date => Date.today, :priority => 2)
      new_critical_project = Factory(:project, :start_date => Date.today, :priority => 1)

      Project.all(:conditions => {:started_after => 1.year.ago, :priority => 2}).should == [new_simple_project]
    end
  end

  context "when scope or column does not exist" do
    it "should raise error" do
      lambda {
        Project.all(:conditions => {:non_existing_scope => 1.year.ago})
      }.should raise_error(/no such column: projects.non_existing_scope/)
    end
  end

  context "context when scope name is same as column name" do
    it "should apply scope" do
      Project.class_eval { scope :priority, lambda { |value| where('priority <= ?', value) } }
      project_1 = Factory(:project, :priority => 1)
      project_2 = Factory(:project, :priority => 2)
      project_3 = Factory(:project, :priority => 3)

      Project.all(:conditions => {:priority => 2}).should =~ [project_1, project_2]
    end
  end

  context "for scope which does not take parameters" do
    context " when value is true" do
      it "should apply scope" do
        project_1 = Factory(:project, :end_date => Date.today)
        project_2 = Factory(:project, :end_date => nil)
        project_3 = Factory(:project, :end_date => Date.today)

        Project.all(:conditions => {:completed => true}).should =~ [project_1, project_3]
      end
    end

    context "when value is false" do
      it "should not apply scope" do
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