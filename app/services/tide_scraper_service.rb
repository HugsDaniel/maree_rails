require "nokogiri"
require "open-uri"

class TideScraperService
  def initialize(port)
    @port = port
    @url = "http://www.horaire-maree.fr/maree/#{@port}/"
    @regex = /(?<hour>\d{2}h\d{2})\s+(?<height>\d{1,2},\d{1,2})/
    @data = []
  end

  def call
    doc = Nokogiri::HTML.parse(URI.open(@url).read)

    date  = doc.search("h3.orange").first.text.gsub("Marée aujourd'hui", "").strip.gsub("  ", " ")
    metas = doc.search("#i_donnesJour .bluesoftoffice").first.search("th").map do |td|
      td.text.strip
    end.first(3)
    tides = doc.search("#i_donnesJour .bluesoftoffice").last.search("td").map do |td|
      td.text.strip
    end
    doc.search('tr:contains("Demain") td').each_with_index do |td, i|
      tides << td.text.strip unless i.zero?
    end

    sliced_data  = []
    tides.each_slice(3) { |slice| sliced_data << [metas, slice] }

    sliced_data.each do |slice|
      extract(slice)
    end

    return @data
  end

  private

  def extract(period)
    period.first.each_with_index do |element, index|
      if period.last[index].match?(@regex)
        match_data = period.last[index].match(@regex)
        @data << Tide.new(coef: period.last[0].to_i, tide: element, hour: match_data[:hour], height: match_data[:height].gsub(",", ".").to_f)
      end
    end
  end
end
