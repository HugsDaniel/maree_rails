require "nokogiri"
require "open-uri"

class TideScraperService
  def initialize(port_id)
    @port_id = port_id
    @url = "https://maree.info/#{@port_id}"
    @regex = /(?<hour>\d{2}h\d{2})\s+(?<height>\d{1,2},\d{1,2})/
    @data = []
  end

  def call
    doc = Nokogiri::HTML.parse(HTTParty.get(@url))

    doc.search("tr.MJ").each do |tr|

      full_date = tr.search("a").attribute("onmouseover").value.match(/QSr\(this,\'\?d=(?<date>\d+)\'\)/)[:date]
      date = Time.parse(full_date[0..-2]) + full_date.last.to_i.days

      high_tides_hours   = tr.search("td").map(&:inner_html)[0].scan(/<b>\d{2}h\d{2}<\/b>/).map { |i| i.match(/\d{2}h\d{2}/)[0] }
      low_tides_hours    = tr.search("td").map(&:inner_html)[0].scan(/\d{2}h\d{2}/).reject { |i| high_tides_hours.include?(i) }

      high_tides_heights = tr.search("td").map(&:inner_html)[1].scan(/<b>\d+,\d+m<\/b>/).map { |i| i.match(/\d+,\d+m/)[0] }
      low_tides_heights  = tr.search("td").map(&:inner_html)[1].scan(/\d+,\d+m/).reject { |i| high_tides_heights.include?(i) }

      coef               = tr.search("td").map(&:inner_html)[2].scan(/\d{2}/)

      high_tides_heights.each_with_index do |height, index|
        @data << Tide.new(
          coef: coef[index].to_i,
          tide: "Pleine mer",
          hour: date.change(
            hour: high_tides_hours[index].split("h").first,
            min: high_tides_hours[index].split("h").last
          ),
          height: height.gsub(",", ".").to_f
        )
      end

      low_tides_heights.each_with_index do |height, index|
        @data << Tide.new(
          tide: "Basse mer",
          hour: date.change(
            hour: low_tides_hours[index].split("h").first,
            min: low_tides_hours[index].split("h").last
          ),
          height: height.gsub(",", ".").to_f
        )
      end
    end
    return @data.sort_by(&:hour)
  end

  private

  def extract(period)
    period.first.each_with_index do |element, index|
      if period.last[index].match?(@regex)
        match_data = period.last[index].match(@regex)
        @data << Tide.new(coef: period.last[0].to_i, tide: element, hour: Time.parse(match_data[:hour]), height: match_data[:height].gsub(",", ".").to_f)
      elsif period.last[index] == ""
        @data << Tide.new(hour: nil, height: nil)
      end
    end
  end
end
