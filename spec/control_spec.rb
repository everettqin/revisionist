require 'spec_helper'

describe Revisionist::Control do
  context "with ignored attribute" do

    let :widget do
      Widget.create name: 'foo', style: 'Coggswell'
    end

    context "on create" do

      subject do
        widget.revisions.last.object
      end

      it "stores the style in the revision" do
        expect(subject['style']).to eql 'Coggswell'
      end

    end

    context "on update" do

      subject do
        widget
      end

      it "doesn't create a revision" do
        expect{subject.update_attributes style: 'Spacely'}.
          to_not change{subject.revisions.count}
      end

    end

  end
end
