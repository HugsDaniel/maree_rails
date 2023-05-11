require "nokogiri"
require "open-uri"

class PortScraperService
  def initialize
    @url = "http://www.horaire-maree.fr"
  end

  def call
    doc = Nokogiri::HTML.parse(URI.open(@url).read)

    doc.search(".select_port option").each do |option|
      port = Port.find_or_initialize_by(
        name: option.text.strip,
        slug: option.attribute("value").value
      )
      port.save!
    end
  end
end
