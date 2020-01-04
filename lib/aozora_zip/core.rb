require 'fileutils'
require 'zip'
require 'pathname'

module AozoraZip
  class Core

    attr_reader :text_file, :dirname

    def self.zip(filename, dirname, **kargs)
      self.new(dirname).zip(filename, **kargs)
    end

    def self.unzip(filename, dirname, **kargs)
      self.new.unzip(filename, dirname, **kargs)
    end

    def initialize(dirname = nil)
      @dirname = dirname

      if @dirname
        unless File.directory?(@dirname)
          raise AozoraZip::Error, "No such directory '#{dirname}'"
        end

        @text_file = find_text_file(@dirname)
      end
    end

    def find_text_file(dir)
      path = Pathname.new(Dir.glob("#{dir}/*.txt")[0])
      path.relative_path_from(dir).to_s
    end

    def zip(filename, force: nil, verbose: nil)
      if File.exist?(filename) && !force
        raise AozoraZip::Error, "target file '#{filename}' already exists"
      end

      Zip::File.open(filename, Zip::File::CREATE) do |f|
        Dir.chdir(dirname) do
          Dir.entries('.').each do |item|
            next if (item == '.' || item == '..')
            next if !File.file?(item)

            puts "add #{item}" if verbose

            fullpath = File.join(Dir.pwd, item)
            filetime = File.mtime(fullpath)
            entry = Zip::Entry.new(f, item, nil, nil, nil, nil, nil, nil, Zip::DOSTime.at(filetime))
            f.add(entry, fullpath)
          end
        end
      end
    end

    def unzip(filename, dirname, force: nil, verbose: nil)
      if !File.exist?(filename)
        raise AozoraZip::Error, "No such file '#{filename}'"
      end

      if File.exist?(dirname) && !force
        raise AozoraZip::Error, "target directory '#{dirname}' already exists"
      end

      @dirname = dirname

      Zip::File.open(filename) do |f|
        f.each do |entry|
          next if (entry.directory? || entry.name.end_with?('/'))
          sep = if entry.name.start_with?('/')
                  ''
                else
                  '/'
                end
          filepath = dirname + sep + entry.name

          puts "extract #{filepath}" if verbose

          FileUtils.mkdir_p(File.dirname(filepath))
          entry.extract(filepath)
          ::FileUtils.touch(filepath, mtime: entry.time)
        end
      end

      @text_file = find_text_file(@dirname)
    end
  end
end
