module Normalizer
  SPACE = " ".freeze
  DASH = "-".freeze
  TIMOR_LESTE = "Timor-Leste".freeze
  TIMOR_LESTE_DOWNCASED = "timor-leste".freeze

  def normalize(str)
    if str == TIMOR_LESTE
      TIMOR_LESTE_DOWNCASED
    else
      str.split(SPACE).join(DASH).downcase
    end
  end

  def denormalize(str)
    if str == TIMOR_LESTE_DOWNCASED
      TIMOR_LESTE
    else
      str.split(DASH).map(&:capitalize).join(SPACE)
    end
  end
end
