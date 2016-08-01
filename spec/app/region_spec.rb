require_relative "../../app/region"

RSpec.describe Region do
  context "constants" do
    it "TIMOR_LESTE returns human-readable form" do
      expect(Region::TIMOR_LESTE).to eq "Timor-Leste"
    end

    it "TIMOR_LESTE_DOWNCASED returns normalized form" do
      expect(Region::TIMOR_LESTE_DOWNCASED).to eq "timor-leste"
    end

    it "AVAILABLE_REGIONS returns human-readable array of regions" do
      expect(Region::AVAILABLE_REGIONS).to match_array(
        ["Afghanistan", "Armenia", "Azerbaijan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Cambodia", "China", "Cyprus", "East Timor", "Georgia", "Hong Kong", "India", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Macau", "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal", "North Korea", "Oman", "Pakistan", "Palestine", "Philippines", "Qatar", "Saudi Arabia", "Singapore", "South Korea", "Sri Lanka", "Syria", "Taiwan", "Tajikistan", "Thailand", "Timor-Leste", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam", "Yemen"]
      )
    end

    it "NORMALIZED_REGIONS returns normalized array of regions" do
      expect(Region::NORMALIZED_REGIONS).to match_array(
        ["afghanistan", "armenia", "azerbaijan", "bahrain", "bangladesh", "bhutan", "brunei", "cambodia", "china", "cyprus", "east-timor", "georgia", "hong-kong", "india", "indonesia", "iran", "iraq", "israel", "japan", "jordan", "kazakhstan", "kuwait", "kyrgyzstan", "laos", "lebanon", "macau", "malaysia", "maldives", "mongolia", "myanmar", "nepal", "north-korea", "oman", "pakistan", "palestine", "philippines", "qatar", "saudi-arabia", "singapore", "south-korea", "sri-lanka", "syria", "taiwan", "tajikistan", "thailand", "timor-leste", "turkey", "turkmenistan", "united-arab-emirates", "uzbekistan", "vietnam", "yemen"]
      )
    end
  end

  describe ".normalize" do
    it "normalizes to downcase joined by dash" do
      result = Region.normalize("South Korea")

      expect(result).to eq "south-korea"
    end
  end

  describe ".denormalize" do
    it "denormalizes backs to human-readable form" do
      result = Region.denormalize("south-korea")

      expect(result).to eq "South Korea"
    end
  end
end
