require 'scormgen/generator'

module Scormgen
  class CLI
    def self.execute(path=nil)
      Scormgen::Generator.new.run
    end
  end
end
