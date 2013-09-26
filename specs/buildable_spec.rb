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


  context "build rules" do
    it "should raise error if no root class was specified and it was not found automatically" do
      expect do
        class TestBuilderWithoutNameByConvention
          build_rules do
          end
        end
      end.to_raise error(AggregateBuilder::Errors::UndefinedRootClassError)
    end

    class TestBuilderWithoutNameByConvention
      include AggregateBuilder::Buildable

      build_rules_for Contact do
        search_key :id do |entity_key, key|
          if key.present?
            entity_key == key.to_s.to_i
          end
        end

        delete_term :_destroy do |value|
          ['1', 'true'].include?(value)
        end

        unmapped_fields_error_level :warn, :error, :silent

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

    it "should raise missing required fields error when required fields are missing" do
    end
  end

  attributes['first_name'] == nil


  context "Assign root attributes" do
    class TestAggregateBuilder
      build_rules_for AggregateRoot do
        field :string_value
        field :integer_value, type: :integer
        field :date_value, type: :date
        field :boolean_value, type: :boolean
        field :float_value, type: :float
        field :time_value, type: :time
        field :custom_value do
          attributes
        end
      end
    end

    subject do
      root_attributes = {
        string_value: 'string',
        integer_value: '1',
        date_value: '2013/09/13',
        boolean_value: 'true',
        float_value: '2.133',
        time_value: '2013/09/13 12:57',
        custom_value: 'custom'
      }
      builder = TestAggregateBuilder.new
      builder.build(nil, root_attributes)
    end

    its(:string_value) { should  == 'string' }
    its(:integer_value) { should  == 1 }
    its(:date_value) { should    == Date.parse('2013/09/13') }
    its(:boolean_value) { should == true }
    its(:float_value) { should   == 2.133 }
    its(:time) { value.should    == Time.new('2013/09/13 12:57') }
    its(:custom_value) { should  == 'custom' }
  end

  context "Assign children attributes" do
    subject do
      attributes = {
        string_value: 'string'
      }
    end
  end
end
