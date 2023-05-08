class TideCalculatorService
  def initialize(tide_data, port, user)
    @tide_data        = tide_data
    @tirant_eau_min   = user.draught
    @pied_pilote      = user.security_margin
    @hauteur_eau_port = port.height
    @min_eau          = @tirant_eau_min + @pied_pilote + @hauteur_eau_port
  end

  def call
    closer_tide         = @tide_data.first(4).min_by { |tide| (Time.parse(tide.hour) - Time.now).abs }
    closer_tide_is_high = closer_tide.tide == "Pleine mer"
    next_tide           = @tide_data[@tide_data.index(closer_tide) + 1]
    hauteur_mh          = closer_tide.height
    marnage_douzieme    = ((hauteur_mh - next_tide.height).round(2) / 12).round(3)

    if @tide_data.first(4).include?(next_tide)
      diff = Time.parse(next_tide.hour) - Time.parse(closer_tide.hour)
    else
      diff = (Time.parse(next_tide.hour) + 1.day) - Time.parse(closer_tide.hour)
    end

    heure_maree_sec     = Time.at(diff.fdiv(6)).utc.to_i
    hauteurs            = [Tide.new(height: hauteur_mh, degree: 1, hour: Time.parse(closer_tide.hour))]

    [1, 2, 3, 3, 2, 1].each_with_index do |n, index|
      hauteur_mh -= marnage_douzieme * n
      hauteurs << Tide.new(height: hauteur_mh.round(2), degree: n, hour: Time.parse(closer_tide.hour) + heure_maree_sec * (index + 1))
    end

    if closer_tide_is_high
      closer = hauteurs.find { |tide| tide.height < @min_eau }
      degree = closer.degree
    else
      closer = hauteurs.find { |tide| tide.height > @min_eau }
      degree = closer.degree - 1
    end

    return closer.hour - ((heure_maree_sec / 60) * (@min_eau - closer.height).round(2) / ((degree) * marnage_douzieme)) * 60
  end
end
