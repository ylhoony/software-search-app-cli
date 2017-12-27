class SoftwareSearch::Scraper

  def self.scrape_categories
    # scrape and create category objects
    html = open("https://www.capterra.com/categories")
    doc = Nokogiri::HTML(html)
    doc.css(".browse-group-list li a").each do |element|
      category = SoftwareSearch::Category.new
      category.name = element.text
      category.slug = element.attribute("href").value
    end
  end

  def self.scrape_software(category)
    # scrape and create software objects
    html = open("https://www.capterra.com/#{category.slug}")
    doc = Nokogiri::HTML(html)

    doc.css(".listing").each do |element|
      if SoftwareSearch::Software.find_by_name(element.css(".listing-name a").text.strip)
        software = SoftwareSearch::Software.find_by_name(element.css(".listing-name a").text.strip)
        software.add_category(category)
      else
        software = SoftwareSearch::Software.new(category)
        software.name = element.css(".listing-name a").text.strip
        software.overall_rating = element.css(".reviews").attribute("data-rating").value.split("/")[0] if element.css(".reviews").attribute("data-rating")
        software.reviews = element.css(".reviews").attribute("data-rating").value.split(" - ")[1] if element.css(".reviews").attribute("data-rating")
        software.description = element.css(".listing-description").text.strip
        software.page_slug = element.css(".listing-description a").attribute("href").value if element.css(".listing-description a").attribute("href")
        binding.pry
      end
    end
  end
end
