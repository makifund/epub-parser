require 'epub/constants'
require 'epub/ocf'
require 'nokogiri'

module EPUB
  class Parser
    class OCF
      DIRECTORY = 'META-INF'
      EPUB::OCF::MODULES.each {|m| self.const_set "#{m.upcase}_FILE", "#{m}.xml"}

      class << self
        def parse(root_directory)
          new(root_directory).parse
        end
      end

      def initialize(root_directory)
        @dir = root_directory
        @ocf = EPUB::OCF.new
      end

      def parse
        EPUB::OCF::MODULES.each do |m|
          @ocf.send "#{m}=", send("parse_#{m}")
        end
        @ocf
      end

      def parse_container
        container = EPUB::OCF::Container.new
        doc = Nokogiri.XML open(File.join @dir, DIRECTORY, CONTAINER_FILE)

        doc.xpath('/container:container/container:rootfiles/container:rootfile', EPUB::NAMESPACES).each do |elem|
          rootfile = EPUB::OCF::Container::Rootfile.new
          %w[full-path media-type].each do |attr|
            rootfile.send(attr.gsub(/-/, '_') + '=', elem[attr])
          end
          container.rootfiles << rootfile
        end

        container
      end

      def parse_encryption
      end

      def parse_manifest
      end

      def parse_metadata
      end

      def parse_rights
      end

      def parse_signatures
      end
    end
  end
end
