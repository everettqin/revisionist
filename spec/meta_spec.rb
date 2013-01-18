require 'spec_helper'

describe Revisionist::Meta do
  fixtures :widgets
  context "on create" do
    let :person do
      Person.create first_name: 'Milo', last_name: 'Bloom'
    end

    subject do
      person.revisions.last.object
    end

    it "has the attribute fields" do
      expect(subject['first_name']).to eql 'Milo'
      expect(subject['last_name']).to eql 'Bloom'
    end

    it "has the `meta` field serialized" do
      expect(subject['full_name']).to eql 'Milo Bloom'
    end
  end
end
