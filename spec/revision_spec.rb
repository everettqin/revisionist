describe Revision do
  fixtures :revisions, :widgets

  context "#reify" do

    context "on create" do
      let :revision do
        revisions :created
      end

      subject do
        revision.reify
      end

      it "is a Widget instance" do
        expect(subject).to be_a(Widget)
      end

      it "has the revisioned attributes" do
        expect(subject.name).to eq("foo")
      end

      it "doesn't have an id" do
        expect(subject.id).to be_nil
      end

      it "doesn't have any timestamps" do
        expect(subject.created_at).to be_nil
        expect(subject.updated_at).to be_nil
      end

      context "with has_many" do

        let :revision do
          revisions :created_with_hm
        end

        subject do
          revision.reify
        end

        it "has fluxors" do
          expect(subject.fluxors.size).to eq(1)
        end

      end # with has_many

      context "with STI model" do

        let :revision do
          revisions :created_sti
        end

        subject do
          revision.reify
        end

        it "is of the inherited class" do
          expect(subject.class).to eql Employee
        end

        it "has the revisioned attributes" do
          expect(subject.first_name).to eql('Milo')
          expect(subject.last_name).to eql('Bloom')
        end

      end # with STI model

    end # on create

    context "on update" do
      let :revision do
        revisions :updated
      end

      subject do
        revision.reify
      end

      it "is a Widget instance" do
        expect(subject).to be_a(Widget)
      end

      it "has the revisioned name" do
        expect(subject.name).to eq("bar")
      end

      it "doesn't have an id" do
        expect(subject.id).to be_nil
      end

      context "with has_many assoc" do

        let :revision do
          revisions(:updated_hm)
        end

        subject do
          revision.reify
        end

        it "has a fluxor with the previous name" do
          expect(subject.fluxors.first.name).to eq("baz")
        end

      end # with has_many assoc

      context "has_many assoc removed" do
        let :revision do
          revisions :updated_destroyed_hm
        end

        subject do
          revision.reify
        end

        it "is a Widget instance" do
          expect(subject).to be_a(Widget)
        end

        it "has the same name" do
          expect(subject.name).to eq("foo")
        end

        it "has a fluxor with the previous name" do
          expect(subject.fluxors.size).to eq(0)
        end

        it "doesn't have an id" do
          expect(subject.id).to be_nil
        end

      end # has_many assoc removed

      context "with STI model" do

        let :revision do
          revisions :updated_sti
        end

        subject do
          revision.reify
        end

        it "is of the inherited class" do
          expect(subject.class).to eql Manager
        end

        it "has the revisioned attributes" do
          expect(subject.first_name).to eql('Steve')
          expect(subject.last_name).to eql('Dallas')
        end

      end # with STI model

    end # on update

    context "on destroy" do

      let :revision do
        revisions :destroyed
      end

      subject do
        revision.reify
      end

      it "is a Widget instance" do
        expect(subject).to be_a(Widget)
      end

      it "has the revisioned name" do
        expect(subject.name).to eq("bar")
      end

      it "doesn't have an id" do
        expect(subject.id).to be_nil
      end

      context "with has_many assoc" do

        let :revision do
          revisions :destroyed_hm
        end

        subject do
          revision.reify
        end

        it "is a Widget instance" do
          expect(subject).to be_a(Widget)
        end

        it "has the same name" do
          expect(subject.name).to eq("foo")
        end

        it "has a fluxor with the previous name" do
          expect(subject.fluxors.first.name).to eq("qux")
        end

        it "doesn't have an id" do
          expect(subject.id).to be_nil
        end

      end # with has_many assoc

      context "with STI model" do

        let :revision do
          revisions :destroyed_sti
        end

        subject do
          revision.reify
        end

        it "is of the inherited class" do
          expect(subject.class).to eql Manager
        end

        it "has the revisioned attributes" do
          expect(subject.first_name).to eql('Cutter')
          expect(subject.last_name).to eql('John')
        end

      end # with STI model

    end # on destroy

  end #reify

end
