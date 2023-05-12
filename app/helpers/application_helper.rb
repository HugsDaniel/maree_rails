module ApplicationHelper
  def info_for(tide)
    case tide
    when "Pleine mer"
      "PM"
    when "Basse mer"
      "BM"
    when "Départ / Arrivée"
      "D/A"
    end
  end
end
