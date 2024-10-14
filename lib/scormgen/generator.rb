require 'zip'
require 'scormgen/version'

module Scormgen
  class Generator
    MANIFEST = 'imsmanifest.xml'
    ZIP = 'module.zip'
    IGNORED_FILES = ['scorm_generator.rb', 'fire_app_log.txt', 'crossdomain.xml', 'config.rb', 'robots.txt', '.DS_Store']

    def run(identifier=nil, name=nil)
      puts "scormgen #{Scormgen::VERSION}"
      @identifier = identifier.nil? ? default_identifier : identifier
      @name = name.nil? ? @identifier : name
      puts "Generating SCORM manifest for #{@name} (#{@identifier})"
      delete_previous_files
      list_files
      create_manifest
      zip_files
      puts "Done"
    end

    protected

    def delete_previous_files
      File.delete MANIFEST if File.exist? MANIFEST
      File.delete ZIP if File.exist? ZIP
    end

    def list_files
      @files = []
      Dir.glob("**/*").each do |path|
        next if File.directory? path
        next if IGNORED_FILES.include? path
        @files << path
      end
      puts "#{@files.count} files found"
    end

    def default_identifier
      File.basename Dir.pwd
    end

    def create_defaults_from(args)
      @identifier = File.basename Dir.pwd
      @identifier = args[0] if args.count > 0
      @name = @identifier
      @name = args[1] if args.count > 1
    end

    def create_manifest
      imsmanifest = "<?xml version=\"1.0\" standalone=\"no\" ?>
<manifest identifier=\"#{@identifier}\"
  xmlns=\"http://www.imsglobal.org/xsd/imscp_v1p1\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
  xmlns:adlcp=\"http://www.adlnet.org/xsd/adlcp_v1p3\"
  xmlns:adlseq=\"http://www.adlnet.org/xsd/adlseq_v1p3\"
  xmlns:adlnav=\"http://www.adlnet.org/xsd/adlnav_v1p3\"
  xmlns:imsss=\"http://www.imsglobal.org/xsd/imsss\"
  xsi:schemaLocation=\"http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd
    http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd
    http://www.adlnet.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd
    http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd
    http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd\">
  <metadata>
    <schema>ADL SCORM</schema>
    <schemaversion>2004 4th Edition</schemaversion>
  </metadata>
  <organizations default=\"#{@identifier}\">
    <organization identifier=\"#{@identifier}\">
      <title><![CDATA[#{@name}]]></title>
      <item identifier=\"item-1\" identifierref=\"elearning\">
        <title><![CDATA[#{@name}]]></title>
      </item>
    </organization>
  </organizations>
  <resources>
    <resource identifier=\"elearning\" type=\"webcontent\" adlcp:scormType=\"sco\" href=\"index.html\">
"
      @files.each do |file|
        imsmanifest += "      <file href=\"#{file.gsub('&', '&amp;')}\" />
"
      end
      imsmanifest += "    </resource>
  </resources>
</manifest>"
      file = File.open(MANIFEST, 'w')
      file.puts imsmanifest
      file.close
      @files << MANIFEST
      puts "#{MANIFEST} generated"
    end

    def zip_files
      puts "Zipping"
      Zip::File.open(ZIP, Zip::File::CREATE) do |zipfile|
        @files.each do |file|
          puts "Adding #{file} to zip"
          zipfile.add file, file
        end
      end
      puts "#{ZIP} generated"
    end
  end
end
