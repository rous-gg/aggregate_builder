
describe "Builders inveritance" do
  context "Inheritance" do

    class Company
      attr_accessor :id, :name
    end

    class People
      attr_accessor :id, :name
    end

    class Deal
      attr_accessor :id, :name
    end

    class BaseBuilder
      include AggregateBuilder::Buildable

      build_config do
        search_block {|entity, hash| entity.name == hash[:name] }
        delete_block {|entity, hash| hash[:_destroy] == true }
        log_type :exception # :log, :ignore
      end

      build_rules do
        before_build do |entity, attributes|
          'before build call'
        end
      end
    end

    class PeopleBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :name
      end
    end

    class CompanyBuilder < BaseBuilder
      include AggregateBuilder::Buildable
      build_rules_for Company do
        field :name
        objects :people, builder: PeopleBuilder
      end
    end


    class DealBuilder
      include AggregateBuilder::Buildable
      build_rules_for Deal do
        field :name
        objects :people, builder: PeopleBuilder
      end
    end

    it "should use search_block defined in parent" do
      CompanyBuilder.new.build(nil, {
        name: 'John LLC',
        people: {
          name: 'John Smith'
        }
      })
    end

    it "should not have rules from other builders" do
      rules = DealBuilder.builder_rules
      rules.fields_collection.size.should == 1
    end

    it "should have proper rules" do
      rules = DealBuilder.builder_rules
      rules.fields_collection.find(:due_at).should_not be_nil
    end
  end

