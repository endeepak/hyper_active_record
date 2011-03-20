require 'spec_helper'

describe HyperActiveRecord::QueryMethods do
  before(:each) do
    class Project < ActiveRecord::Base
      scope :started_after, lambda { |time| where('start_date > ?', time) }
      scope :started_during, lambda { |begining, ending| where('start_date BETWEEN ? AND ?', begining, ending) }
      scope :completed, lambda { |time| where('end_date IS NOT NULL') }
    end
  end

  after(:each) do
    Project.scopes.clear
    Project.delete_all
  end

  context "for scope with no parameters" do
    it "applies scope ignoring parameter" do
      project_1 = Factory(:project, :end_date => Date.today)
      project_2 = Factory(:project, :end_date => nil)
      project_3 = Factory(:project, :end_date => Date.today)

      conditions = {:completed => 'anything'}
      expected_records = [project_1, project_3]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "for scope with single parameter" do
    it "applies scope" do
      old_project = Factory(:project, :start_date => 2.years.ago)
      new_project = Factory(:project, :start_date => Date.today)

      conditions = {:started_after => 1.year.ago}
      expected_records = [new_project]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "for scope with multiple parameters" do
    it "applies scope" do
      project_1 = Factory(:project, :start_date => 1.months.ago, :end_date => Date.today)
      project_2 = Factory(:project, :start_date => 2.months.ago, :end_date => nil)
      project_3 = Factory(:project, :start_date => 5.months.ago, :end_date => Date.today)

      conditions = {:started_during => [3.months.ago, Date.today]}
      expected_records = [project_1, project_2]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "with combination condition and scope name" do
    it "applies scope and matches by condition" do
      old_critical_project = Factory(:project, :start_date => 2.years.ago, :priority => 1)
      new_simple_project = Factory(:project, :start_date => Date.today, :priority => 2)
      new_critical_project = Factory(:project, :start_date => Date.today, :priority => 1)

      conditions = {:started_after => 1.year.ago, :priority => 2 }
      expected_records = [new_simple_project]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "with multiple scope names" do
    it "applies all scopes" do
      project_1 = Factory(:project, :start_date => 1.months.ago, :end_date => Date.today)
      project_2 = Factory(:project, :start_date => 2.months.ago, :end_date => nil)
      project_3 = Factory(:project, :start_date => 5.months.ago, :end_date => Date.today)

      conditions = {:started_after => 3.month.ago, :completed => true}
      expected_records = [project_1]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "with only conditions and no scope names" do
    it "mathes by conditions" do
      project_1 = Factory(:project, :priority => 1)
      project_2 = Factory(:project, :priority => 2)
      project_3 = Factory(:project, :priority => 3)

      conditions = {:priority => 2}
      expected_records = [project_2]

      Project.where(conditions).should == expected_records
      Project.all(:conditions => conditions).should == expected_records
      Project.count(:conditions => conditions).should == expected_records.size
    end
  end

  context "when scope or column does not exist" do
    it "raises error" do
      conditions = {:non_existing_scope => 1.year.ago}
      expected_error = /no such column: projects.non_existing_scope/

      lambda { Project.where(conditions).to_a }.should raise_error(expected_error)
      lambda { Project.all(:conditions => conditions) }.should raise_error(expected_error)
      lambda { Project.count(:conditions => conditions) }.should raise_error(expected_error)
    end
  end

  context "when scope name is same as column name" do
    it "applies scope" do
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
end