module Utils
  def digit?(char)
    char.is_a?(String) && char.length == 1 && char >= "0" && char <= "9"
  end

  def all_digits?(str)
    str.chars.all? {|char| digit?(char)}
  end

  def all_chars_between?(str, char_a, char_b)
    str.is_a?(String) && 
    str.chars.all? do |char| 
      char.between?(char_a, char_b) || char.between?(char_a, char_b)
    end
  end

  def char_counts(str)
    counts = Hash.new(0)
    str.chars.each{|char| counts[char] += 1}
    counts
  end

  
end