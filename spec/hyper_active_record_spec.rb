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

      conditions = {:started_after => 1.year.ago}
      expected_records = [new_project]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "with combination of column name and scope name" do
    it "should apply scoped and match by column value" do
      old_critical_project = Factory(:project, :start_date => 2.years.ago, :priority => 1)
      new_simple_project = Factory(:project, :start_date => Date.today, :priority => 2)
      new_critical_project = Factory(:project, :start_date => Date.today, :priority => 1)

      conditions = {:started_after => 1.year.ago, :priority => 2}
      expected_records = [new_simple_project]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "when scope or column does not exist" do
    it "should raise error" do
      conditions = {:non_existing_scope => 1.year.ago}
      expected_error = /no such column: projects.non_existing_scope/

      lambda { Project.where(conditions).to_a }.should raise_error(expected_error)
      lambda { Project.all(:conditions => conditions) }.should raise_error(expected_error)
      lambda { Project.count(:conditions => conditions) }.should raise_error(expected_error)
    end
  end

  context "context when scope name is same as column name" do
    it "should apply scope" do
      Project.class_eval { scope :priority, lambda { |value| where('priority <= ?', value) } }
      project_1 = Factory(:project, :priority => 1)
      project_2 = Factory(:project, :priority => 2)
      project_3 = Factory(:project, :priority => 3)

      conditions = {:priority => 2}
      expected_records = [project_1, project_2]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "for scope which does not take parameters" do
    context " when value is true" do
      it "should apply scope" do
        project_1 = Factory(:project, :end_date => Date.today)
        project_2 = Factory(:project, :end_date => nil)
        project_3 = Factory(:project, :end_date => Date.today)

        conditions = {:completed => true}
        expected_records = [project_1, project_3]

        Project.where(conditions).should == expected_records
        Project.all(:conditions => conditions).should == expected_records
        Project.count(:conditions => conditions).should == expected_records.size
      end
    end

    context "when value is false" do
      it "should not apply scope" do
        project_1 = Factory(:project, :end_date => Date.today)
        project_2 = Factory(:project, :end_date => nil)
        project_3 = Factory(:project, :end_date => Date.today)

        conditions = {:completed => false}
        expected_error = /no such column: projects.completed/

        lambda { Project.where(conditions).to_a }.should raise_error(expected_error)
        lambda { Project.all(:conditions => conditions) }.should raise_error(expected_error)
        lambda { Project.count(:conditions => conditions) }.should raise_error(expected_error)
      end
    end
  end
end