require_relative '../spec_helper'

describe AggregateBuilder::FieldBuilders::EscapedStringFieldBuilder do
  subject do
    AggregateBuilder::FieldBuilders::EscapedStringFieldBuilder
  end

  describe ".cast" do
    it "should escape html tags" do
      subject.cast(:text, 'Usage: foo "bar" <baz>').should == "Usage: foo &quot;bar&quot; &lt;baz&gt;"
    end
  end
end
