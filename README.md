Revisionist<a id="top"></a> [![Dependency Status](https://gemnasium.com/spiegela/revisionist.png)](https://gemnasium.com/spiegela/revisionist) [![Build Status](https://travis-ci.org/spiegela/revisionist.png?branch=master)](undefined) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/spiegela/revisionist)
===========

Revisionist an ActiveRecord versioning done a little differently to support a
few features that have been tricky in other implementations.

Uhh... Aren't there already Rails versioning libraries?
--------------------------------------------------------

Well... for one, wheels are made to be reinvented.  For another, they didn't
everything I wanted them to do -- a couple of features I wanted in  particular:
 1. Association support
 2. Use of existing ActiveRecord serializers

After doing some evaluation, and a lot of code reading, I also found
features I liked in both [PaperTrail](http://github.com/airblade/paper_trail/)
and [VestalVersions](http://github.com/laserlemon/vestal_versions). I decided
that merging the two (i.e. wholesale lifting code from each :) would make
something greater than the sum of their parts.

Before we dive into code, I want to highlight some big differences with
Revisionist vs. these alternatives:

 **1. Revisionist serializes the full object**

That means it takes up more space than the alternatives. I went this
direction beause managing changes to associations in an incremental way
became too complex.  I'd entertain alternative approaches, but this is what
I've come up with so far.

 **2. Revisionist uses _after_ callbacks, rather than _before_ callbacks**

Again, this is for association support. Some association changes don't work
reliably when the database doesn't match the records. This also means that
Revisionist will use more storage than the alternatives, since it's always
serializing & storing the current version in addition to the historical.

If you don't need my differentiating features, you can always stick with the
alternatives; however, I'd invite you to take a stroll through the code either
way. I've spent some time making it nice for you.

[Back to Top](#top)
A few words (and a chart) on associations:
------------------------------------------
As this is still a young library, associations are not yet complete.
I'm working on some solutions, but for now here's what's working & not:

| Association      | updated via nested attrs | editing child directly | adding child | removing child |
|:-----------------|:------------------------:|:----------------------:|:------------:|:--------------:|
| has_many         | yes                      | no                     | yes          | yes            |
| belongs_to       | yes                      | no                     | yes          | yes            |
| habtm            | yes                      | no                     | yes          | yes            |
| has_many through | yes                      | no                     | yes          | yes            |
| has_one          | yes                      | no                     | no           | no             |

A full list of the features
---------------------------
 * Stores on create, update & destroy (not configurable yet)
 * Association support as detailed above
 * Stores new revisions only when changes exist
 * Exempt fields from triggering revisions (ignore option)
 * Skip fields entirely (skip option)
 * Uses ActiveRecord serialization feature to store data -- means it works with
   any of the available coders
 * Store calculated fields or dynamic info using _meta_ fields
 * Recall deleted items via revisions
 * Supports STI models transparently

[Back to Top](#top)
Some other things I'm rather proud of
-------------------------------------
 * A well organized & complete test suite
 * Modular design making it easy to add/change/remove functionality

On with the code
----------------
Not configuration is required.  Just tell me that you want revisions in your model

```ruby
class Widget < ActiveRecord::Base
  attr_accessible :name

  has_revisions
end
```

This will get you running with revisions create on create, update & destroy. Of
course one problem, is that this doesn't cover all of my data structure.  I also
have associations that complete my widget:

```ruby
class Widget < ActiveRecord::Base
  attr_accessible :name

  has_many :fluxors
  has_many :wotsits

  has_revisions include: [:fluxors, :wotsits]
end
```

This will add the associations to your model, and also allow you to recreate them
from the revision like magic.

Other features you'll be familiar with if you've used any libraries like this. For
one, often you'll want to _skip_ a field entirely removing it from the revision.

Also, you can simply _ignore_ a field, so that it doesn't trigger a revision, but
still keeps the data.

```ruby
  attr_accessible :name, :crank_count, :sprocket_style

  has_revisions include: [:fluxors, :wotsits],
                skip:    :counter_field,
                ignore:  :style
```

**NOTE:** You must set the field as *attr_accessible*; otherwise, creating the
instance from a revision won't work.

Also, you may want to store some dynamic or calculated information.  This works
nicely for methods that you wan to _cache_ in the model.  Just use the meta option,
and specify the method name:

```ruby
  has_revisions include: [:fluxors, :wotsits],
                skip:    :counter_field,
                ignore:  :style
                meta:    :crank_output
```

To change the serializer, just change it in the initializer.rb:

```ruby
  Revisionist.configure do |config|
    config.serializer = JSON
  end
```

Want to use the new Postgres Hstore? Be sure to add it to your Gemfile, and then:

```ruby
  Revisionist.configure do |config|
    config.serializer = ActiveRecord::Coders::Hstore
  end
```

Right now, this is a global setting, but when we have custom Revision classes it'll
be more flexible.

Now that you have your revisions, you might want to actually use one. We just
pick a revision and "reify" it:

```ruby
temp_widget = widget.revisions.last.reify
```
Our latest revision widget will be back in all it's glory, with all of it's
included associations as new records. One things I should note, if you want it
to maintain a *belongs_to* relationship without duplicating the associated
record, *don't* include it... the foreign_key field will get preserved unless
you specifically skip it.

Examples also exist in the specs/dummy app.

[Back to Top](#top)
Known issues
------------
 * Circular revisions != Good:

    Right now, if you revision both sides of an association, there are cases
    (like has_many through associations) where you can create "stack level too
    deep" problems.  The solution right now:  don't do that.

Other things I'm still working on
--------------------------------------
 * Direct edits on an associated record should trigger a revision on the parent
 * Skipped/Ignored fields in the associations
 * Convenience methods for playing with revisions
 * Controller integration & helper methods
 * Add whodunnit support (like PaperTrail has)
 * Conditions to disable revisioning (like PaperTrail)
 * Convenience blocks for disabling/merging revisions (like VestalVersions)
 * Support custom revision classes
 * Investigate support for other ORMs with the same API (Mongoid, DataMapper, etc)
