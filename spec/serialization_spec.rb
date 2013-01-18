require 'spec_helper'

describe Revisionist::Serialization do
  fixtures :widgets

  context "without associations" do

    let :widget do
      Widget.new name: 'foo'
    end

    subject do
      widget.serialized_object
    end

    it "has the right name" do
      expect(subject["name"]).to eql "foo"
    end

    it "excludes timestamp fields" do
      expect(subject["created_at"]).to be_nil
      expect(subject["updated_at"]).to be_nil
    end

  end

  context "with associations" do

    let :widget do
      Widget.new name: 'foo'
    end

    subject do
      widget.fluxors_attributes = [{name: 'baz'}, {name: 'qux'}]
      widget.serialized_object
    end

    it "has the right name" do
      expect(subject["name"]).to eql "foo"
    end

    it "has the correct number of fluxors" do
      expect(subject["fluxors_attributes"].count).to eql(2)
    end

    it "has right fluxor attributes" do
      expect(subject["fluxors_attributes"].map{|x| x["name"]}).to eql(["baz", "qux"])
    end

    it "excludes timestamp fields" do
      expect(subject["fluxors_attributes"][0]["created_at"]).to be_nil
      expect(subject["fluxors_attributes"][0]["updated_at"]).to be_nil
      expect(subject["fluxors_attributes"][1]["created_at"]).to be_nil
      expect(subject["fluxors_attributes"][1]["updated_at"]).to be_nil
    end

  end

  context "custom serializer" do
    before do
      Revisionist.configure{ |c| c.serializer = JSON }
    end

    after do
      Revisionist.configure{ |c| c.serializer = nil }
    end

    let :widget do
      Widget.create name: 'foo'
    end

    subject do
      widget.revisions.last.attributes_before_type_cast["object"].serialized_value
    end

    it "is formatted in JSON" do
      expect{ JSON.load(subject) }.to_not raise_error
    end
  end

  context "with STI model" do
    let :employee do
      Employee.new first_name: 'Bill', last_name: 'The Cat'
    end

    subject do
      employee.serialized_object
    end

    it "has the right attributes" do
      expect(subject["first_name"]).to eql 'Bill'
      expect(subject["last_name"]).to eql 'The Cat'
      expect(subject["type"]).to eql 'Employee'
    end
  end

  context "with skipped fields" do
    let :widget do
      Widget.new name: 'foo', counter_field: 5
    end

    subject do
      widget.serialized_object
    end

    it "skips the counter_field" do
      expect(subject["counter_field"]).to be_nil
    end

  end
end
