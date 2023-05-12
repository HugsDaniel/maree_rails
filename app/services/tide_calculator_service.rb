class TideCalculatorService
  def initialize(tide_data, height, user)
    @tide_data        = tide_data
    @tirant_eau_min   = user.draught
    @pied_pilote      = user.security_margin
    @hauteur_eau_port = height
    @min_eau          = @tirant_eau_min + @pied_pilote + @hauteur_eau_port
  end

  def call
    @tides = []
    @tide_data.each_with_index do |tide, index|
      closer_tide         = tide
      closer_tide_is_high = closer_tide.tide == "Pleine mer"
      next_tide           = @tide_data[index + 1]

      next unless next_tide

      hauteur_mh          = closer_tide.height
      marnage_douzieme    = ((hauteur_mh - next_tide.height) / 12)

      diff = next_tide.hour - closer_tide.hour

      heure_maree_sec     = Time.at(diff.fdiv(6)).utc.to_i
      hauteurs            = [Tide.new(height: hauteur_mh, degree: 1, hour: closer_tide.hour)]

      [1, 2, 3, 3, 2, 1].each_with_index do |n, index|
        hauteur_mh -= marnage_douzieme * n
        hauteurs << Tide.new(height: hauteur_mh, degree: n, hour: closer_tide.hour + heure_maree_sec * (index + 1))
      end

      if closer_tide_is_high
        closer = hauteurs.find { |tide| tide.height < @min_eau }
        next unless closer

        degree = closer.degree
      else
        closer = hauteurs.reverse.find { |tide| tide.height < @min_eau }

        next unless closer
        next if closer.height > @min_eau

        degree = closer.degree - 1
      end

      degree = 1 if degree.zero?

      @tides << Tide.new(tide: "Départ / Arrivée", height: @min_eau.round(2), hour: (closer.hour - ((heure_maree_sec / 60) * (@min_eau - closer.height) / ((degree) * marnage_douzieme)) * 60))
    end

    return @tides
  end
end
