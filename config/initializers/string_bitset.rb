class String
  def &(str)
    result = ''
    result.force_encoding("BINARY")
    min = [self.length, str.length].min
    (0...min).each do |i|
      result << (self[i].ord & str[i].ord)
    end
    
    result
  end
  
  def |(str)
    result = ''
    result.force_encoding("BINARY")
    min = [self.length, str.length].min
    (0...min).each do |i|
      result << (self[i].ord | str[i].ord)
    end

    if self.length > str.length
      result << self[min ... self.length]
    elsif self.length < str.length
      result << str[min ... str.length]
    end
    
    result
  end
  
  def population_count
    count = 0
    (0 ... self.length).each do |i|
      count += _population_count_byte(self[i].ord)
    end
    
    count
  end
  
  private
    ONE_BITS = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
    
    def _population_count_byte(x)
      count = 0
      count =  ONE_BITS[x&0x0f]
      count += ONE_BITS[x>>4]
      count
    end
end
