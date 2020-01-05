module AozoraZip
  class Text
    CREATED_DATE_PATTERN = Regexp.new("^([0-9A-Za-z]+)年([0-9A-Za-z]+)月([0-9A-Za-z]+)日作成\r\n".encode("cp932"))
    FOOTER_SEPARATOR_PATTERN = Regexp.new("\r\n\r\n底本：".encode("cp932"))

    def initialize(text_file, core)
      @text_file = text_file
      @core = core
    end

    def absolute_path
      File.join(@core.dirname, @text_file)
    end

    def content
      IO.binread(absolute_path).force_encoding("cp932")
    end

    def update(text)
      IO.binwrite(absolute_path, text)
    end

    def footer_pos
      m = FOOTER_SEPARATOR_PATTERN.match(content)
      if m
        m.pre_match.size + "\r\n\r\n".size
      else
        nil
      end
    end

    def create_date_string(time)
      "#{time.year}年#{time.month}月#{time.day}日作成"
    end

    def find_created_date
      m = CREATED_DATE_PATTERN.match(content, footer_pos)
      if m
        Time.new(m[1],m[2],m[3])
      end
    end

    def update_created_date(time)
      m = CREATED_DATE_PATTERN.match(content, footer_pos)
      if m
        new_date = create_date_string(time).encode("cp932")
        m.pre_match + new_date + "\r\n" + m.post_match
      else
        nil
      end
    end
  end
end
