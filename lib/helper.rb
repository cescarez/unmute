
module Helper

  def self.titleize(string)
    string.split(' ').each { |word| word.capitalize! }.join(' ')
  end
end