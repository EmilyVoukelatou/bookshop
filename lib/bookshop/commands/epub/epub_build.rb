require 'thor/group'
require 'erb'
require 'yaml'

module Bookshop
  module Commands

    # Builds the EPUB version of the book
    class EpubBuild < Thor::Group
      include Thor::Actions
      
      # Define source root of application
      def self.source_root
        File.dirname(__FILE__)
      end      
      
      def clean_up
        puts "Deleting any old builds"
        FileUtils.rm_r Dir.glob('builds/epub/*')
        FileUtils.rm_r Dir.glob('builds/html/*')
      end
      
      def compile_erb_source
        @output = :epub

        erb = import('book.html.erb')

        # Generate the html from ERB
        puts "Generating new html from erb"
        File.open('builds/epub/OEBPS/book.html', 'a') do |f|
          f << erb
        end
      end
      
      # Load the book.yml into the Book object
      @book = Book.new(YAML.load_file('config/book.yml'))
      @toc = Toc.new(TAML.load_file('config/toc.yml'))
      
      def create_epub_structure
        directory "templates/epub", "builds/epub"
      end
      
      def generate_content_opf_file
        template "templates/content.opf.tt" "builds/epub/OEBPS"
      end

      def generate_toc
        template "templates/toc.ncs.tt" "builds/epub/OEBPS"
      end
      
      def zip_epub
        # zip the contents into book.epub
      end
      
      def validate_epub
        cmd = %x[tools/epubcheck book_#{Time.now.strftime('%m-%e-%y').epub]
      end
    end
  end
end