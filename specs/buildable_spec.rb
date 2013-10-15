require_relative 'spec_helper'

describe AggregateBuilder::Buildable do
  context "Defining build object class" do
    class Car
      attr_accessor :name, :model
    end

    it "should build object of the specified class in build_rules_for" do
      class TestCarBuilder
        include AggregateBuilder::Buildable

        build_rules_for Car do
          fields :name, :model
        end
      end

      builder = TestCarBuilder.new
      builder.build(nil, {
        name: 'Porshe', model: 'Cayene'
      }).should be_instance_of(Car)
    end

    it "should automatically define build object class from aggregate name" do
      class CarBuilder
        include AggregateBuilder::Buildable

        build_rules do
          fields :name, :model
        end
      end

      builder = CarBuilder.new
      builder.build(nil, {
        name: 'Porshe', model: 'Cayene'
      }).should be_instance_of(Car)
    end

    it "should raise error when build class was not found" do
      expect do
        class TestBuilder
          include AggregateBuilder::Buildable

          build_rules do
          end
        end
      end.to raise_error(AggregateBuilder::Errors::UndefinedRootClassError)
    end
  end

  context "Building defaults" do
    class Animal
      attr_accessor :name, :type
    end

    it "should allows to assign defaults" do
      class AnimalBuilder
        include AggregateBuilder::Buildable

        build_defaults do
          before_build :setup_defaults
        end

        build_rules do
          fields :name, :type
        end

        def setup_defaults(animal, attributes)
          attributes[:type] = :mammal
        end
      end

      builder = AnimalBuilder.new
      animal = builder.build(nil, name: 'Dog')
      animal.type.should == 'mammal'
    end
  end

  context "Checking required fields" do
    class Bike
      attr_accessor :name, :model, :max_speed
    end

    class BikeBuilder
      include AggregateBuilder::Buildable

      config_builder do
        unmapped_fields_error_level :error # raise exceptions
      end

      build_rules_for Bike do
        field :name, required: true
        field :model, required: :model_required?
        field :max_speed
      end

      private

      def model_required?(entity, attributes)
        true
      end
    end

    it "should raise error when required field is missing" do
      builder = BikeBuilder.new
      expect do
        builder.build(nil, { model: 'AS7', max_speed: 70 })
      end.to raise_error(AggregateBuilder::Errors::RequireAttributeMissingError,
                         "Required field name is missing for BikeBuilder builder")
    end

    it "should raise error when required field with condition is missing" do
      builder = BikeBuilder.new
      expect do
        builder.build(nil, { name: 'Astra', max_speed: 70 })
      end.to raise_error(AggregateBuilder::Errors::RequireAttributeMissingError,
                         "Required field model is missing for BikeBuilder builder")
    end

    it "should not raise error when required field present" do
      builder = BikeBuilder.new
      expect do
        field = builder.build(nil, { name: 'Astra', model: 'AS7' })
      end.to_not raise_error
    end
  end

  context "Inheritance" do
    class BaseBuilder
      include AggregateBuilder::Buildable

      build_defaults do
        before_build do |entity, attributes|
          'before build call'
        end
      end
    end

    class Company
      attr_accessor :name
    end

    class Deal
      attr_accessor :due_at
    end

    class CompanyBuilder < BaseBuilder
      build_rules_for Company do
        field :name
      end
    end

    class DealBuilder < BaseBuilder
      build_rules_for Deal do
        field :due_at, type: :date
      end
    end

    it "should not have rules from other builders" do
      rules = DealBuilder.builder_rules
      rules.fields_collection.should have(1).item
    end

    it "should have proper rules" do
      rules = DealBuilder.builder_rules
      rules.fields_collection.map(&:field_name).should == [:due_at]
    end
  end

  context "Building objects" do
    class Contact
      attr_accessor :id, :first_name, :last_name, :type_id, :date_of_birth,
                    :is_private, :rating, :average_rating, :created_at, :company_name
    end

    class ContactBuilder
      include AggregateBuilder::Buildable

      build_rules_for Contact do
        fields :first_name, :last_name
        field  :rating, type: :integer do |entity, attributes|
          attribute_for :rating, attributes
        end
        field  :average_rating, type: :float
        field  :date_of_birth, type: :date
        field  :type_id, type: :integer
        field  :is_private, type: :boolean
        field  :created_at, type: :time
        field  :company_name do |entity, attributes|
          'John Doe Inc.'
        end
      end
    end

    it "should properly set object fields" do
      contact = ContactBuilder.new.build(nil, {
        first_name: 'John',
        last_name: 'Doe',
        rating: 10,
        average_rating: '2.1',
        date_of_birth: '12/09/1965',
        type_id: 3,
        is_private: true,
        created_at: "2013-09-30 08:58:28 +0400",
      })

      contact.first_name.should == 'John'
      contact.last_name.should == 'Doe'
      contact.rating.should == 10
      contact.average_rating.should == 2.1
      contact.date_of_birth.should == Date.parse('12/09/1965')
      contact.type_id.should == 3
      contact.is_private.should == true
      contact.created_at.should == Time.new("2013-09-30 08:58:28 +0400")
      contact.company_name.should == 'John Doe Inc.'
    end

    it "should update existing built object" do
      builder = ContactBuilder.new
      contact = builder.build(nil, {
        first_name: 'John',
        last_name: 'Doe',
        rating: 10,
        average_rating: '2.1',
        date_of_birth: '12/09/1965',
        type_id: 3,
        is_private: true,
        created_at: "2013-09-30 08:58:28 +0400",
      })
      updated_contact = builder.build(contact, first_name: 'Bill', rating: 20)
      updated_contact.first_name.should == 'Bill'
      updated_contact.rating.should == 20
    end
  end

  context "Building children objects" do
    class Motocycle
      attr_accessor :id, :name, :wheels, :engine

      def initialize
        @wheels = []
      end
    end

    class Wheel
      attr_accessor :id, :manufacturer
    end

    class Engine
      attr_accessor :id, :model
    end

    class WheelBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :manufacturer
      end
    end

    class EngineBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :model
      end
    end

    class MotocycleBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :name

        build_children :wheels do
          builder WheelBuilder
          reject_if do |entity, attributes|
            attributes[:manufacturer].nil?
          end
          deletable true
        end

        build_children :engine do
          builder EngineBuilder
        end
      end
    end

    it "should build children objects" do
      motocycle = MotocycleBuilder.new.build(nil, {
        name: 'Suzuki',
        wheels: [
          { manufacturer: 'Nokian' },
          {},
        ],
        engine: {
          model: 'BSX75',
        }
      })
      motocycle.name.should == 'Suzuki'
      motocycle.wheels.count.should == 1
      motocycle.wheels.first.manufacturer.should == 'Nokian'
      motocycle.engine.model.should == 'BSX75'
    end

    it "should update existing child objects" do
      builder = MotocycleBuilder.new
      motocycle = builder.build(nil, {
        name: 'Suzuki',
        wheels: [
          { manufacturer: 'Nokian' },
          { manufacturer: 'Kama' },
          {},
        ],
        engine: {
          model: 'BSX75',
        }
      })

      # set ids to allow updating objects
      motocycle.id = 1
      motocycle.wheels[0].id = 1
      motocycle.wheels[1].id = 2
      motocycle.engine.id = 1

      updated_motocycle = builder.build(motocycle, {
        name: 'Kawasaki',
        wheels: [
          { manufacturer: 'Peroni', id: 1 },
          { manufacturer: 'Kama', id: 2, _delete: true },
          { manufacturer: 'Yetti' },
        ],
        engine: {
          id: 1,
          model: 'BSX75-2',
        }
      })
      updated_motocycle.name.should == 'Kawasaki'
      updated_motocycle.wheels.count.should == 2
      updated_motocycle.wheels[0].manufacturer.should == 'Peroni'
      updated_motocycle.wheels[1].manufacturer.should == 'Yetti'
      updated_motocycle.engine.model.should == 'BSX75-2'
    end
  end
end
