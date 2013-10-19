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
      rules.fields_collection.size.should == 1
    end

    it "should have proper rules" do
      rules = DealBuilder.builder_rules
      rules.fields_collection.find(:due_at).should_not be_nil
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
        field  :rating, type: :integer
        field  :average_rating, type: :float
        field  :date_of_birth, type: :date
        field  :type_id, type: :integer
        field  :is_private, type: :boolean
        field  :created_at, type: :time
        field  :company_name
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
        company_name: "John Doe Inc."
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

        field :wheels, type: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          object_builder: WheelBuilder,
          reject_if: ->(entity, attrs){ attrs[:manufacturer].nil? },
          deletable: true
        }

        field :engine, type: :hash, field_builder: :object, build_options: { object_builder: EngineBuilder }
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

  context "Setting custom search block" do
    class Book
      attr_accessor :name, :authors, :pages

      def initialize
        @authors = []
        @pages   = []
      end
    end

    class Writer
      attr_accessor :first_name, :last_name, :age
    end

    class Page
      attr_accessor :number, :content
    end

    class WriterBuilder
      include AggregateBuilder::Buildable
      build_rules Writer do
        field :first_name
        field :last_name
        field :age, type: :integer
      end
    end

    class PageBuilder
      include AggregateBuilder::Buildable
      build_rules Page do
        #field :number
        field :content
      end
    end


    class BookBuilder
      include AggregateBuilder::Buildable
      build_rules Book do
        field :name
        field :authors, type: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          object_builder: WriterBuilder,
          deletable: true,
          search_block: ->(author, attrs){ author.first_name == attrs[:first_name] && author.last_name == attrs[:last_name] },
        }
        field :pages, type: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          deletable: true,
          object_builder: PageBuilder,
          search_block: ->(page, attrs){ page.number && page.number == attrs[:number] }
        }
      end
    end


    describe "build with custom id field" do
      it "should update find and update books by custom id field" do
        book_builder = BookBuilder.new
        book = book_builder.build(nil, {
          name: 'Funny games',
          authors: [
            { first_name: 'Bill', last_name: 'Smith', age: 30 },
            { first_name: 'John', last_name: 'Snow', age: 23 },
          ],
          pages: [
            { content: 'First page' },
            { content: 'Second page' },
          ]
        })

        # set search keys
        book.pages[0].number = 1
        book.pages[1].number = 2
        pp book

        book_builder.build(book, {
          name: 'Funny games',
          authors: [
            { first_name: 'Bill', last_name: 'Smith', age: 32 },
            { first_name: 'John', last_name: 'Snow', age: 25 },
          ],
          pages: [
            { number: 1, content: 'Updated first page' },
            { numbder: 2, content: 'Second page', _delete: true },
            { content: 'Third page' },
          ]
        })
      end
    end
  end
end
