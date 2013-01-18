require 'spec_helper'

describe Revisionist::Callbacks do
  context "on create" do
    let :widget do
      Widget.new name: 'foo'
    end

    subject do
      widget
    end

    it "adds a revision" do
      expect{
        subject.save
      }.to change{subject.revisions.count}.
           by(1)
    end
  end

  context "on update" do
    let :widget do
      Widget.create name: 'foo'
    end

    subject do
      widget
    end

    it "adds a revision" do
      expect{
        subject.update_attributes(name: 'bar')
      }.to change{subject.revisions.count}.
           by(1)
    end
  end
end
