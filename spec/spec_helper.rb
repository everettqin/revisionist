require 'spork'

require File.expand_path("../dummy/config/environment", __FILE__)

ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate", __FILE__)

Spork.prefork  do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = File.expand_path("../fixtures", __FILE__)
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
  end

end

Spork.each_run do

end
