module Scormgen
  class Generator
    def run
      puts "Generate"
      list_files
      puts "#{@files.count} files found"
    end

    protected

    def list_files
      @files = []
      Dir.glob("**/*").each do |path|
        next if File.directory? path
        next if ignored_files.include? path
        @files << path
      end
    end

    def ignored_files
      ['scorm_generator.rb', 'fire_app_log.txt', 'crossdomain.xml', 'config.rb']
    end
  end
end
