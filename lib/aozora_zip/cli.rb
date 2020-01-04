require 'thor'
require 'aozora_zip/core'

module AozoraZip
  class CLI < Thor
    class_option :verbose, :type => :boolean
    class_option :force, :type => :boolean

    option :file
    desc "zip DIRNAME", "zip directory DIRNAME"
    def zip(dirname)
      filename = options[:file] || dirname+".zip"
      if options[:verbose]
        puts "zip directory #{dirname} into #{filename}"
      end

      AozoraZip::Core.zip(filename, dirname, verbose: options[:verbose], force: options[:force])
    end

    option :dir, aliases: :d
    desc "unzip FILENAME", "unzip file FILENAME"
    def unzip(filename)
      dirname = options[:dir] || File.basename(filename, ".*")
      if !options[:dir] && dirname == filename
        raise AozoraZip::Error, "filename #{filename} should have ext, usually `.zip`"
      end

      if options[:verbose]
        puts "unzip #{filename} to #{dirname}"
      end

      AozoraZip::Core.unzip(filename, dirname, verbose: options[:verbose], force: options[:force])
    end
  end
end
