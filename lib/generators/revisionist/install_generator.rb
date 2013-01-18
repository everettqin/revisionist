require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module Revisionist
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    desc "Generates (but does not run) a migration to add a revisions table."

    def create_migration_file
      migration_template 'create_revisions.rb', File.join(%w[db migrate create_revisions.rb])
    end

    def create_initializer_file
      template 'initializer.rb', File.join(%w[config initializers revisionist.rb])
    end
  end
end
