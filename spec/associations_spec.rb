require 'spec_helper'

describe Revisionist::Associations do

  let :model do
    Widget.new
  end

  let :klass do
    Widget
  end

  subject do
    model
  end

  it "supports association attributes setter" do
    expect(model).to respond_to(:fluxors_attributes=)
  end

  it "makes the association attributes setter accessible" do
    expect(klass.accessible_attributes).to include("fluxors_attributes")
  end

end
