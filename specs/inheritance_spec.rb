require_relative 'spec_helper'

describe "Builders inheritance" do
  class Company
    attr_accessor :id, :name, :users
  end

  class User
    attr_accessor :id, :name, :position
  end

  class Deal
    attr_accessor :id, :name, :description
  end

  class BaseBuilder
    include AggregateBuilder::Buildable

    build_config do
      search_block {|entity, hash| entity.name == hash[:name] }
      delete_block {|entity, hash| hash[:_remove] == true }
      log_type     :exception
    end

    build_rules do
      before_build do |entity, attributes|
        'before build call'
      end
    end
  end

  class UserBuilder
    include AggregateBuilder::Buildable
    build_rules do
      fields :name, :position
    end
  end

  class CompanyBuilder < BaseBuilder
    include AggregateBuilder::Buildable
    build_rules_for Company do
      field :name
      objects :users, builder: UserBuilder
    end
  end


  class DealBuilder
    include AggregateBuilder::Buildable
    build_rules_for Deal do
      field :name
      objects :users, builder: UserBuilder
    end
  end

  it "should use search_block defined in parent" do
    company = CompanyBuilder.new.build(nil, {
      name: 'John LLC',
      users: [
        { name: 'John Smith', position: 'Developer' },
        { name: 'Bill Smith', position: 'Developer' }
      ]
    })
    company = CompanyBuilder.new.build(company, {
      name: 'John LLC',
      users: [
        { name: 'John Smith', position: 'Manager' },
        { name: 'Bill Smith', position: 'Manager' }
      ]
    })
    company.users.count.should == 2
    pp company
    company.users[0].position.should == 'Manager'
    company.users[1].position.should == 'Manager'
  end

  #it "should not have rules from other builders" do
    #rules = DealBuilder.rules
    #rules.fields_collection.size.should == 1
  #end

  #it "should have proper rules" do
    #rules = DealBuilder.rules
    #rules.fields_collection.find(:due_at).should_not be_nil
  #end
end

