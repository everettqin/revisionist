require 'revisionist/constants'
require 'revisionist/configuration'
require 'revisionist/options'
require 'revisionist/model'
require 'revisionist/control'
require 'revisionist/serialization'
require 'revisionist/associations'
require 'revisionist/callbacks'
require 'revisionist/revision'
require 'revisionist/meta'

module Revisionist
  extend Configuration
end

ActiveSupport.on_load :active_record do
  include Revisionist::Model
end
