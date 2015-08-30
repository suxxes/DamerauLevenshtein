require "./damerau-levenshtein/*"

module DamerauLevenshtein
  def self.distance(s1 : String, s2 : String)
    return 0 if s1 == s2

    s1_length = s1.length
    s2_length = s2.length

    return s1_length if s2_length == 0
    return s2_length if s1_length == 0

    diff = {} of Tuple(Int32, Int32) => Int32

    (-1..(s1_length + 1)).each do |i|
      diff[{i, -1}] = i + 1
    end

    (-1..(s2_length + 1)).each do |i|
      diff[{-1, i}] = i + 1
    end

    s1_length.times do |i|
      s2_length.times do |j|
        if s1[i] == s2[j]
          c = 0
        else
          c = 1
        end

        diff[{i, j}] = [
          diff[{i - 1, j}] + 1,
          diff[{i, j - 1}] + 1,
          diff[{i-1, j-1}] + c
        ].min

        if i > 0 && j > 0 && s1[i] == s2[j - 1] && s1[i - 1] == s2[j]
          diff[{i, j}] = [
            diff[{i, j}],
            diff[{i - 2, j - 2}] + c
          ].min
        end
      end
    end

    diff[{s1_length - 1, s2_length - 1}]
  end
end

puts DamerauLevenshtein.distance("12345", "13245")
