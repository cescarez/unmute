
module Helper

  def titleize(string)
    string.split(' ').each { |word| word.capitalize! }.join(' ')
  end
end