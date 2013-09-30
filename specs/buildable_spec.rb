require_relative 'spec_helper'

describe AggregateBuilder::Buildable do
  class Emails < Array
    attr_accessor :email, :email_type
  end

  class Address
    attr_accessor :street, :city, :postal_code, :state
  end

  class Contact
    module ContactTypes
      PERSON  = 0
      COMPANY = 1
    end

    attr_accessor :first_name, :last_name, :type_id, :date_of_birth, :private,
                  :rating, :created_at, :company_name

    def initialize
      @emails  = Emails.new
      @address = Address.new
    end
  end

  context "Set root class" do
    it "should set specified root class" do
      class TestBuilder
        include AggregateBuilder::Buildable

        build_rules_for Contact do
        end
      end

      rules = TestBuilder.send(:builder_rules)
      rules.root_class.should == Contact
    end

    it "should properly define root class from aggregate name" do
      class ContactBuilder
        include AggregateBuilder::Buildable

        build_rules do
        end
      end

      rules = ContactBuilder.send(:builder_rules)
      rules.root_class.should == Contact
    end

    it "should raise error when root class was not defined" do
      expect do
        class TestFactory
          include AggregateBuilder::Buildable

          build_rules do
          end
        end
      end.to raise_error(AggregateBuilder::Errors::UndefinedRootClassError)
    end
  end

  context "build rules" do
    class TestBuilderWithoutNameByConvention
      include AggregateBuilder::Buildable

      build_rules_for Contact do
        search_key :id do |entity_key, key|
          if key.present?
            entity_key == key.to_s.to_i
          end
        end

        delete_key :_destroy do |value|
          ['1', 'true'].include?(value)
        end

        unmapped_fields_error_level :warn#, :error, :silent

        fields :first_name, :last_name, required: true
        field  :rating, type: :integer, required: true
        field  :date_of_birth, type: :date
        field  :type_id, type: :integer, required: true
        field  :private, type: :boolean do |private_flag|
          private_flag == '0' ? false : true
        end
        field  :created_at, type: Time
        field  :company_name, required: true do
          (attributes['company'] || {})['name']
        end
      end
    end
  end
end
