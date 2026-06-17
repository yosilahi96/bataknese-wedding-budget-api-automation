require "dotenv/load"
require "httparty"
require "json"
require "rspec/expectations"

require_relative "api_client"
require_relative "world"

World(ApiAutomation::World)
