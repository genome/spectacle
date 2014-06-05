# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

#Capybara
require 'capybara/rspec'
require 'capybara/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end
