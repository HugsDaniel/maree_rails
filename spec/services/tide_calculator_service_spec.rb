require 'rails_helper'

RSpec.describe TideCalculatorService, type: :model do
  describe '#call' do
    let!(:high_tide_morning) { Tide.new(hour: "7h46", height: 9.05, coef: 93, tide: "Pleine mer") }
    let!(:low_tide_morning) { Tide.new(hour: "13h59", height: 1.55, coef: 93, tide: "Basse mer") }
    let!(:high_tide_afternoon) { Tide.new(hour: "20h06", height: 9.4, coef: 95, tide: "Pleine mer") }

    let!(:port) { Port.new(name: "Trégastel", height: 1.9)}
    let!(:user) { User.new(draught: 1.1, security_margin: 0.3) }

    it 'calculates the next latest possible departure' do
      allow(Time).to receive(:now).and_return(Time.new(2023, 5, 8, 7, 0, 0))
      heure_depart = TideCalculatorService.new([high_tide_morning, low_tide_morning, high_tide_afternoon], port, user).call

      expect(heure_depart.strftime("%Hh%M")).to eq("12h01")
    end

    it 'calculates the next soonest possible return' do
      allow(Time).to receive(:now).and_return(Time.new(2023, 5, 8, 14, 0, 0))
      heure_depart = TideCalculatorService.new([high_tide_morning, low_tide_morning, high_tide_afternoon], port, user).call

      expect(heure_depart.strftime("%Hh%M")).to eq("15h41")
    end
  end
end
