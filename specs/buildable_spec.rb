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
        TestBuilder.new.build(nil, {})
      end.to raise_error(AggregateBuilder::Errors::UndefinedRootClassError)
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
        field  :rating, type_caster: :integer
        field  :average_rating, type_caster: :float
        field  :date_of_birth, type_caster: :date
        field  :type_id, type_caster: :integer
        field  :is_private, type_caster: :boolean
        field  :created_at, type_caster: :time
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
        field :id, type_caster: :integer, build_options: { immutable: true }
        field :manufacturer
      end
    end

    class EngineBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :id, type_caster: :integer, build_options: { immutable: true }
        field :model
      end
    end

    class MotocycleBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :name

        field :wheels, type_caster: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          builder: WheelBuilder,
          reject_if: ->(attrs){ attrs[:manufacturer].nil? },
          deletable: true
        }

        field :engine, type_caster: :hash, field_builder: :object, build_options: {
          builder: EngineBuilder
        }
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

  context "Using aliases" do
    class Person
      attr_accessor :id, :name, :work_address, :phone_numbers
    end

    class WorkAddress
      attr_accessor :id, :city, :street
    end

    class PhoneNumber
      attr_accessor :id, :number
    end

    class WorkAddressBuilder
      include AggregateBuilder::Buildable

      build_rules do
        fields :city, :street
      end
    end

    class PhoneNumberBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :number
      end
    end

    class PersonBuilder
      include AggregateBuilder::Buildable

      build_rules do
        field :name
        object :work_address, builder: WorkAddressBuilder
        objects :phone_numbers, builder: PhoneNumberBuilder
      end
    end

    it "should build Person" do
      person = PersonBuilder.new.build(nil, {
        name: "John Smith",
        work_address: {
          city: "Kazan",
          street: "Pushkin St."
        },
        phone_numbers: [
          { number: '12343214343' },
          { number: '43212452343' },
        ]
      })
      person.name.should == 'John Smith'
      person.work_address.city.should == 'Kazan'
      person.work_address.street.should == 'Pushkin St.'
      person.phone_numbers[0].number.should == '12343214343'
      person.phone_numbers[1].number.should == '43212452343'
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
        field :age, type_caster: :integer
      end
    end

    class PageBuilder
      include AggregateBuilder::Buildable
      build_rules Page do
        field :number, type_caster: :integer, immutable: true
        field :content
      end
    end


    class BookBuilder
      include AggregateBuilder::Buildable
      build_rules Book do
        field :name
        field :authors, type_caster: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          builder: WriterBuilder,
          deletable: true,
          search_block: ->(author, attrs){ author.first_name == attrs[:first_name] && author.last_name == attrs[:last_name] },
        }
        field :pages, type_caster: :array_of_hashes, field_builder: :array_of_objects, build_options: {
          deletable: true,
          builder: PageBuilder,
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

        book_builder.build(book, {
          name: 'Funny games',
          authors: [
            { first_name: 'Bill', last_name: 'Smith', age: 32 },
            { first_name: 'John', last_name: 'Snow', age: 25 },
          ],
          pages: [
            { number: 1, content: 'Updated first page' },
            { number: 2, content: 'Second page', _delete: true },
            { content: 'Third page' },
          ]
        })
      end
    end
  end
end
