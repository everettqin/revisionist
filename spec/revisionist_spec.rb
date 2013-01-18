require 'spec_helper'

describe Revisionist do

  context "on update" do

    context "of has_many assoc" do

      context "updating via nested attributes" do

        let :widget do
          Widget.create name: "foo"
        end

        let :fluxor do
          Fluxor.create name: 'baz'
        end

        it "adds 1 revision" do
          expect{
            widget.update_attributes(fluxors_attributes: [{name: 'baz'}])
          }.to change{widget.revisions.count}.by(1)
        end

        context "after save" do
          it "has the correct attributes" do
            widget.update_attributes(fluxors_attributes: [{name: 'baz'}])
            attrs = widget.revisions.last.object['fluxors_attributes'][0]
            expect(attrs['name']).to eql 'baz'
          end
        end

      end # updating via nested attributes

      # TODO: add support for direct editing of associations via injected callbacks
      context "when editing associated model directly" do

        context "without touch option" do

          let :widget do
            Widget.create name: "foo"
          end

          let :fluxor do
            Fluxor.create name: 'baz'
          end

          it "doesn't add a revision" do
            widget.fluxors << fluxor
            widget.save
            expect{
              fluxor.update_attributes(name: 'qux')
            }.to_not change{widget.revisions.count}
          end

        end # without touch option

        context "with touch option" do

          let :widget do
            Widget.create name: "foo"
          end

          let :wotsit do
            Wotsit.create name: 'baz'
          end

          it "doesn't add a revision" do
            widget.wotsits << wotsit
            widget.save
            expect{
              wotsit.update_attributes(name: 'qux')
            }.not_to change{widget.revisions.count}
          end
        end # with touch option

      end # when editing associated model directly

      context "when adding a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :fluxor do
          Fluxor.create name: 'baz'
        end

        it "adds a revision" do
          expect{widget.fluxors << fluxor}.to change{widget.revisions.count}.by(1)
        end

      end # when adding a child-model

      context "when removing a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :fluxor do
          Fluxor.create name: 'baz'
        end

        it "adds a revision" do
          widget.fluxors << fluxor
          widget.save
          expect{widget.fluxors.clear}.to change{widget.revisions.count}.by(1)
        end

      end # when removing a child-model

    end # of has_many assoc

    context "of belongs_to assoc" do

      context "updating via nested attributes" do

        let :person do
          Person.create first_name: "Steve", last_name: "Dallas"
        end

        let :company do
          Company.create name: 'Bloom County'
        end

        it "adds 1 revision" do
          person.company = company
          person.save
          expect{
            person.update_attributes(company_attributes: {name: 'Cathy'})
          }.to change{person.revisions.count}.by(1)
        end

        context "after save" do

          before do
            person.update_attributes(company_attributes: {name: 'Cathy'})
          end

          it "has the correct attributes" do
            attrs = person.revisions.last.object['company_attributes']
            expect(attrs['name']).to eql 'Cathy'
          end

        end

      end

      context "updating the model directly" do

        let :person do
          Person.create first_name: 'Milo', last_name: 'Bloom'
        end

        let :company do
          Company.create name: 'The Daily Texan'
        end

        it "doesn't add a revision" do
          person.company = company
          person.save
          expect{
            company.update_attributes(name: 'The Far Side')
          }.not_to change{person.revisions.count}
        end

      end

      context "when attaching" do

        let :person do
          Person.create first_name: "Steve", last_name: "Dallas"
        end

        let :company do
          Company.create name: 'Bloom County Law'
        end

        it "adds a revision" do
          expect{person.company = company; person.save}.to \
            change{person.revisions.count}.by(1)
        end

      end # when attaching

      context "when detaching" do

        let :person do
          Person.create first_name: "Cutter", last_name: "John"
        end

        let :company do
          Company.create name: 'Army'
        end

        it "adds a revision" do
          person.company = company
          person.save
          expect{person.company = nil; person.save}.to \
            change{person.revisions.count}.by(1)
        end

      end # when detaching

    end # of belongs_to assc

    context "of has_one assoc" do

      let :person do
        Person.create first_name: 'Bill', last_name: 'The Cat'
      end

      let :title do
        Title.create name: 'Janitor'
      end

      context "updating via nested attributes" do

        it "adds a revision" do
          person.title = title
          person.save
          expect{
            person.update_attributes(title_attributes: {name: 'President & CEO'})
          }.to change{person.revisions.count}.by(1)
        end

      end

      context "updating the model directly" do

        it "doesn't add a revision" do
          person.title = title
          person.save
          expect{
            title.name = 'President'
            title.save
          }.not_to change{person.revisions.count}
        end

      end # updating the model directly

      context "when attaching" do

        it "doesn't add a revision" do
          expect{person.title = title; title.save}.to_not \
            change{person.revisions.count}
        end

      end # when attaching

      context "when detaching" do

        it "doesn't add a revision" do
          expect{person.title = nil; person.save}.to_not \
            change{person.revisions.count}
        end

      end # when detaching

    end # of has_one assoc

    context "of has_and_belongs_to_many assoc" do

      let :widget do
        Widget.create name: 'foo'
      end

      let :cog do
        Cog.create name: 'bar'
      end

      context "updating via nested attributes" do

        it "adds 1 revision" do
          widget.cogs << cog
          widget.save
          expect{widget.update_attributes(cogs_attributes: [{name: 'baz'}])}.to \
            change{widget.revisions.count}.by(1)
        end

        context "after save" do
          it "has the correct attributes" do
            widget.update_attributes(cogs_attributes: [{name: 'baz'}])
            attrs = widget.revisions.last.object['cogs_attributes'][0]
            expect(attrs['name']).to eql 'baz'
          end
        end

      end

      context "when adding a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :cog do
          Cog.create name: 'baz'
        end

        it "adds a revision" do
          expect{widget.cogs << cog}.to change{widget.revisions.count}.by(1)
        end

      end # when adding a child-model

      context "when removing a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :cog do
          Cog.create name: 'baz'
        end

        it "adds a revision" do
          widget.cogs << cog
          widget.save
          expect{widget.cogs.clear}.to change{widget.revisions.count}.by(1)
        end

      end # when removing a child-model

    end # of has_and_belongs_to_many assoc

    context "of has_many through assoc" do

      let :widget do
        Widget.create name: 'foo'
      end

      let :gear do
        Gear.create name: 'bar'
      end

      context "updating via nested attributes" do

        it "adds 1 revision" do
          widget.gears << gear
          widget.save
          expect{
            widget.update_attributes(
              gears_attributes: [ {id: gear.id, name: 'baz'} ]
            )
          }.to change{widget.revisions.count}.by(1)
        end

        context "after save" do
          it "has the correct attributes" do
            widget.update_attributes(gears_attributes: [{name: 'baz'}])
            attrs = widget.revisions.last.object['gears_attributes'][0]
            expect(attrs['name']).to eql 'baz'
          end
        end

      end

      context "when adding a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :gear do
          Gear.create name: 'baz'
        end

        it "adds a revision" do
          expect{widget.gears << gear}.to change{widget.revisions.count}.by(1)
        end

      end # when adding a child-model

      context "when removing a child-model" do

        let :widget do
          Widget.create name: "foo"
        end

        let :gear do
          Gear.create name: 'baz'
        end

        it "adds a revision" do
          widget.gears << gear
          widget.save
          expect{widget.gears.clear}.to change{widget.revisions.count}.by(1)
        end

      end # when removing a child-model

    end # of has_many through assoc

  end # on update

end
