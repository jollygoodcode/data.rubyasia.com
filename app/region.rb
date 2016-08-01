require_relative "constant"

class Region
  TIMOR_LESTE = "Timor-Leste".freeze
  TIMOR_LESTE_DOWNCASED = "timor-leste".freeze

  def self.normalize(str)
    if str == TIMOR_LESTE
      TIMOR_LESTE_DOWNCASED
    else
      str.split(Constant::SPACE).join(Constant::DASH).downcase
    end
  end

  def self.denormalize(str)
    if str == TIMOR_LESTE_DOWNCASED
      TIMOR_LESTE
    else
      str.split(Constant::DASH).map(&:capitalize).join(Constant::SPACE)
    end
  end

  AVAILABLE_REGIONS = IO.readlines(Constant::ROOT.join("regions")).map(&:chomp)
  NORMALIZED_REGIONS = AVAILABLE_REGIONS.map { |region| Region.normalize(region) }
end
