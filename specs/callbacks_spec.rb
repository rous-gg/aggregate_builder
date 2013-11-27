require_relative 'spec_helper'

describe "Builder callbacks" do

  class Animal
    attr_accessor :name, :type, :status, :stage, :description, :position
  end

  class AnimalBuilder
    include AggregateBuilder::Buildable

    build_rules do
      before_change :set_name
      before_build  :set_type
      before_update :set_status
      after_build   :set_stage
      after_update  :set_description
      after_change  :set_position
    end

    build_rules do
      fields :name, :type, :status, :stage
    end

    def set_name(animal, attributes)
      attributes[:name] = 'cat'
    end

    def set_type(animal, attributes)
      attributes[:type] = 'mammal'
    end

    def set_status(animal, attributes)
      attributes[:status] = 'walking'
    end

    def set_stage(animal, attributes)
      animal.stage = 'live'
    end

    def set_description(animal, attributes)
      animal.description = 'funny cat'
    end

    def set_position(animal, attributes)
      animal.position = 'high'
    end
  end


  it "should call :change and :build callbacks on build" do
    builder = AnimalBuilder.new
    animal = builder.build({})
    animal.name.should == 'cat'
    animal.type.should == 'mammal'
    animal.status.should == nil # cause it's update callback
    animal.stage.should == 'live'
    animal.description.should == nil # cause it's update callback
    animal.position.should == 'high'
  end

  it "should call :change and :update callbacks on update" do
    cat = Animal.new
    builder = AnimalBuilder.new
    animal = builder.update(cat, {})
    animal.name.should == 'cat'
    animal.type.should == nil # cause it's build callback
    animal.status.should == 'walking'
    animal.stage.should == nil # cause it's build callback
    animal.description.should == 'funny cat'
    animal.position.should == 'high'
  end

end
