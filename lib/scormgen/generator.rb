module Scormgen
  class Generator

    def run
      puts "Generate"
    end

    protected

    def list_files
      files = Dir.glob("**/*")
      files.each do |path|
        next if File.directory? path
        next if ignored_files.include? path
        imsmanifest += "      <file href=\"#{ path }\" />
      "
      end
    end

    def ignore
      ['scorm_generator.rb', 'fire_app_log.txt', 'crossdomain.xml', 'config.rb']
    end
  end
end
