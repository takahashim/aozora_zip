require 'test_helper'
require 'tmpdir'
require 'zip'
require 'diff/lcs'

module AozoraZip
  class TextTest < Test::Unit::TestCase

    def setup
      @core = AozoraZip::Core.new("test/fixtures/unzip/59300_ruby_69898")
      @text = @core.text
    end

    def test_text_context
      original_text = File.read("test/fixtures/unzip/59300_ruby_69898/nekoto_shozoto_futarino_onna_bunko.txt", encoding: "cp932")
      assert_equal original_text.size, @text.content.size
      assert_equal original_text, @text.content
    end

    def test_footer_pos
      assert_equal 74932, @text.footer_pos
    end

    def test_absolute_path
      assert_equal "test/fixtures/unzip/59300_ruby_69898/nekoto_shozoto_futarino_onna_bunko.txt", @text.absolute_path
    end

    def test_absolute_path2
      text = AozoraZip::Core.new("test/fixtures/unzip/59636_ruby_69900").text
      assert_equal "test/fixtures/unzip/59636_ruby_69900/narazumono.txt", text.absolute_path
    end

    def test_create_date_string_short
      assert_equal "2020年1月2日作成", @text.create_date_string(Time.new(2020,1,2))
    end

    def test_create_date_string_long
      assert_equal "2020年10月23日作成", @text.create_date_string(Time.new(2020,10,23))
    end

    def test_find_created_date
      assert_equal Time.new(2019,12,27), @text.find_created_date
    end

    def test_find_created_date2
      text = AozoraZip::Core.new("test/fixtures/unzip/59636_ruby_69900").text
      assert_equal Time.new(2019,12,27), text.find_created_date
    end

    def test_update_created_date
      updated = @text.update_created_date(Time.new(2020,1,5))
      updated_footer = updated.slice(@text.footer_pos, updated.size - @text.footer_pos)
      original_footer = @text.content.slice(@text.footer_pos, @text.content.size - @text.footer_pos)
      diff = Diff::LCS.diff(updated_footer, original_footer)
      diff_ary = diff.flatten(1).map(&:to_a)
      expected = [["-", 547, "2"],
                  ["-", 548, "0"],
                  ["+", 547, "1"],
                  ["+", 548, "9"],
                  ["+", 551, "2"],
                  ["-", 552, "5"],
                  ["+", 553, "2"],
                  ["+", 554, "7"]]
      assert_equal expected, diff_ary
    end

  end
end
