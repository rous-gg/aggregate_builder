require_relative 'spec_helper'

describe "Builder callbacks" do

  class Animal
    attr_accessor :name, :type
  end

  class AnimalBuilder
    include AggregateBuilder::Buildable

    build_rules do
      before_build :set_type
      after_build  :set_name
    end

    build_rules do
      fields :name, :type
    end

    def set_type(animal, attributes)
      attributes[:type] = :mammal
    end

    def set_name(animal, attributes)
      animal.name = 'Dog'
    end
  end


  it "before_build callback should be called" do
    builder = AnimalBuilder.new
    animal = builder.build({})
    animal.type.should == 'mammal'
  end

  it "after_build callback should be called" do
    builder = AnimalBuilder.new
    animal = builder.build({})
    animal.name.should == 'Dog'
  end

end
