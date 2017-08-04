require 'scormgen/generator'

module Scormgen
  class CLI
    def self.execute(args)
      identifier = args.count > 0 ? args[0] : nil
      name = args.count > 1 ? args[1] : nil
      Scormgen::Generator.new.run identifier, name
    end
  end
end
