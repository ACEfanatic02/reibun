
class Matcher

  include Enumerable

  def initialize word, search_root
    @word = Regexp.new word
    @search_root = search_root
  end

  def each 
    Dir.glob("#{@search_root}/**/*.txt").each do |file|
      next unless File.file?(file)
      File.open(file) do |f|
        f.each_line do |line|
          line = clean(line)

          if match = line.match(@word)
            yield file, line, match
          end
        end
      end
    end
  end

  private

  # Try to convert line to utf-8, using Shift-JIS, utf-8, and utf-16 as
  # base encodings. Returns an empty string if it cannot convert the line.
  def clean line
    ['sjis', 'utf-8', 'utf-16'].each do |encoding|
      begin
        cleaned = line.encode('utf-8', encoding)
      rescue Exception => e
        next
      end
      return cleaned if cleaned.valid_encoding?
    end
    ""
  end
end