require_relative 'spec_helper'

describe "Builders inheritance" do
  class Company
    attr_accessor :id, :name, :users, :created_by_id
  end

  class User
    attr_accessor :id, :name, :position, :created_by_id
  end

  class Deal
    attr_accessor :id, :name, :description, :users
  end

  class BaseBuilder
    include AggregateBuilder::Buildable

    build_config do
      search_block {|entity, hash| entity.name == hash[:name] }
      delete_block {|entity, hash| hash[:_remove] == true }
      log_type     :exception
    end

    build_rules do
      field :id, type_caster: :integer, build_options: { immutable: true }

      before_build do |entity, attributes|
        attributes[:created_by_id] = 10
      end
    end
  end

  class UserBuilder < BaseBuilder
    include AggregateBuilder::Buildable
    build_rules do
      fields :name, :position
      field :created_by_id, type_caster: :integer
    end
  end

  class CompanyBuilder < BaseBuilder
    include AggregateBuilder::Buildable
    build_rules_for Company do
      field :name
      field :created_by_id, type_caster: :integer
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

  it "inherited callbacks should be called" do
    company = CompanyBuilder.new.build({
      name: 'John LLC',
      users: [
        { name: 'John Smith', position: 'Developer' }
      ]
    })
    company.created_by_id.should == 10
    company.users[0].created_by_id.should == 10
  end

  it "CompanyBuilder should use search_block defined in parent" do
    company = CompanyBuilder.new.build({
      name: 'John LLC',
      users: [
        { name: 'John Smith', position: 'Developer' },
        { name: 'Bill Smith', position: 'Developer' }
      ]
    })
    company = CompanyBuilder.new.update(company, {
      name: 'John LLC',
      users: [
        { name: 'John Smith', position: 'Manager' },
        { name: 'Bill Smith', position: 'Manager' }
      ]
    })
    company.users.count.should == 2
    company.users[0].position.should == 'Manager'
    company.users[1].position.should == 'Manager'
  end

  it "DealBuilder should use default search block" do
    deal = DealBuilder.new.build({
      name: 'By a car',
      users: [
        { name: 'John Smith', position: 'Developer' },
        { name: 'Bill Smith', position: 'Developer' }
      ]
    })
    deal.users[0].id = 1
    deal.users[1].id = 2
    deal = DealBuilder.new.update(deal, {
      name: 'By a car',
      users: [
        { id: 1, name: 'John Smith', position: 'Manager' },
        { id: 2, name: 'Bill Smith', position: 'Manager' }
      ]
    })
    deal.users.count.should == 2
    deal.users[0].position.should == 'Manager'
    deal.users[1].position.should == 'Manager'
  end

end

