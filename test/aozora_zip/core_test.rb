require 'test_helper'
require 'tmpdir'
require 'zip'

module AozoraZip
  class CoreTest < Test::Unit::TestCase
    def test_text_file
      core = AozoraZip::Core.new("test/fixtures/unzip/59300_ruby_69898")
      assert_equal "nekoto_shozoto_futarino_onna_bunko.txt", core.text_file
    end

    def test_new_raise_error
      assert_raise(AozoraZip::Error.new("No such directory 'test/fixtures/unzip/invalid_dir'")) do
        core = AozoraZip::Core.new("test/fixtures/unzip/invalid_dir")
      end
    end

    def test_unzip_files
      Dir.mktmpdir do |tmpdir|
        path = tmpdir+"/test"
        AozoraZip::Core.unzip("test/fixtures/zip/59300_ruby_69898.zip",
                              path)
        ent = Dir.entries(path).sort
        ent_orig = Dir.entries("test/fixtures/unzip/59300_ruby_69898").sort
        assert_equal ent_orig, ent
      end
    end

    def test_zip_files
      Dir.mktmpdir do |tmpdir|
        path = tmpdir+"/test.zip"
        AozoraZip::Core.zip(path,
                            "test/fixtures/unzip/59300_ruby_69898")
        ent_orig = Dir.entries("test/fixtures/unzip/59300_ruby_69898").reject{|item| item == "." || item == ".." }.sort
        Zip::File.open(path) do |zip|
          ent = zip.glob('*.*').map(&:name).sort
          assert_equal ent_orig, ent
        end
      end
    end

  end
end
