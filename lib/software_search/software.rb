class SoftwareSearch::Software
  attr_accessor :name, :overall_rating, :reviews, :description, :page_slug, :url
  attr_reader :categories

  @@all = []

  def initialize(category)
    @categories = []
    @categories << category
    self.save
  end

  def self.find_by_name(name)
    self.all.detect do |software|
      software.name == name
    end
  end

  def add_category(category)
    @categories << category
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

end
