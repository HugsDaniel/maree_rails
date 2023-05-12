require "nokogiri"
require "open-uri"

class PortScraperService
  def initialize
    # @url = "http://www.horaire-maree.fr"
    @url = "https://maree.info/"
  end

  def call
    doc = Nokogiri::HTML.parse(URI.open(@url).read)

    doc.search("a.Port").each do |link|
      port = Port.find_or_initialize_by(
        name: link.text.strip,
        slug: link.attribute("href").value.gsub("/", "")
      )
      port.save!
    end
  end
end
