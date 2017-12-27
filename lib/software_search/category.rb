class SoftwareSearch::Category
  attr_accessor :name, :slug

  @@all = []

  def initialize
    self.save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset
    @@all.clear
  end

  def self.find_by_keyword(keyword)
    self.all.select do |category|
      category.name.downcase.include?(keyword.downcase)
    end
  end

  def self.find_by_alphabet(alphabet)
    if alphabet === "#"
      self.all.select do |category|
        category.name.chr.to_i.between?(1,9) == true
      end
    else
      self.all.select do |category|
        category.name.downcase.chr == alphabet.downcase
      end
    end
  end

end
