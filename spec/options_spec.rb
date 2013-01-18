require 'spec_helper'

describe Revisionist::Options do
  let :model do
    Widget
  end

  context "single argument" do

    it "transforms options into arrays" do
      expect(Widget.revisionist_options[:include]).to be_an(Array)
    end

    it "transforms strings into symbols" do
      expect(Widget.revisionist_options[:include].first).to be_a(Symbol)
    end

  end

end
