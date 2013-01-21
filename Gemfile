source "http://rubygems.org"

# Declare your gem's dependencies in revisionist.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
group :test do
  gem 'rake'
end

platform :mri do
  gem 'pry-debugger'
end

gem 'sqlite3', platform: [:ruby, :mswin, :mingw]

platform :jruby do
  gem 'jdbc-sqlite3'
  gem 'activerecord-jdbcsqlite3-adapter'
end
