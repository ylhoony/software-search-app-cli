class SoftwareSearch::CLI

  @@last_category_search = []

  def call
    puts "Welcome to Software Search!"
    reset
    list_categories
    list_software
    restart?
  end

  def reset
    SoftwareSearch::Software.reset
    SoftwareSearch::Category.reset
    SoftwareSearch::Scraper.scrape_categories # created Category objects and can access to lists with Category.all
  end

  def self.last_category_search
    @@last_category_search
  end

  def list_categories
    puts "Please enter any Keyword or Alphabet(or '#') to search software categories!"
    puts "or enter 'exit' to quit."
    input = gets.strip
    @@last_category_search.clear
    exit if input == 'exit'
    if input.length == 1
      if SoftwareSearch::Category.find_by_alphabet(input).size > 0
        SoftwareSearch::Category.find_by_alphabet(input).each.with_index(1) do |category, i|
          @@last_category_search << category
          puts "#{i}. #{category.name}"
        end
      else
        puts "There is no result for your search."
        self.list_categories
      end
    else
      if SoftwareSearch::Category.find_by_keyword(input).size > 0
        SoftwareSearch::Category.find_by_keyword(input).each.with_index(1) do |category, i|
          @@last_category_search << category
          puts "#{i}. #{category.name}"
        end
      else
        puts "There is no result for your search."
        self.list_categories
      end
    end
  end

  def list_software
    puts "Please enter Category index number to see a list of software :"
    input = gets.strip
    if !input.to_i.between?(1, self.class.last_category_search.size)
      puts "Please input valid index number"
      self.list_software
    end
    category = self.class.last_category_search[input.to_i - 1]
    SoftwareSearch::Scraper.scrape_software(category)
    SoftwareSearch::Software.all.select do |each_software|
      each_software.categories.include?(category)
    end.each.with_index(1) do |list, i|
      puts "#{i}. #{list.name}"
      puts "Review Rating: #{list.overall_rating}/5.0 from #{list.reviews} reviews"
      puts "Description: #{list.description}"
    end
  end

  def restart?
    puts "Would you like to check other software? (Y/N)"
    answer = gets.strip
    case answer.downcase
    when "y"
      self.call
    when "n"
      exit
    else
      puts "I do not understand your answer"
      puts "Please answer with Y or N"
      self.restart?
    end
  end
end
