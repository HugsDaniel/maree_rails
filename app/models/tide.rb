class Tide
  attr_accessor :hour, :height, :coef, :tide, :degree

  def initialize(attrs)
    @hour   = attrs[:hour]
    @height = attrs[:height]
    @coef   = attrs[:coef]
    @tide   = attrs[:tide]
    @degree = attrs[:degree]
  end
end
