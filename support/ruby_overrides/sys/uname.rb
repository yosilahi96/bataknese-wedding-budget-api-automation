require "rbconfig"

module Sys
  module Uname
    Result = Struct.new(:version, keyword_init: true)

    def self.uname
      Result.new(version: RbConfig::CONFIG.fetch("target_os", "windows"))
    end
  end
end
