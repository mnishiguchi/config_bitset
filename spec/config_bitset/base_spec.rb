require "spec_helper"

describe ConfigBitset::Base do
  describe ".define_flag" do
    before do
      @klas = Class.new(ConfigBitset::Base)
      @klas.define_flag(:washer_dryer, 1)
    end

    it "adds a new flag to the list" do
      expect(@klas.list).to eq([{ name: "washer_dryer", value: 2, display_name: "Washer Dryer" }])
    end

    it "generates utility instance methods for the flag" do
      expect(@klas.instance_methods).to include(:washer_dryer=, :washer_dryer?)
    end
  end

  describe ".index_to_value" do
    it "converts a flag index to a flag value" do
      expect(described_class.index_to_value(4)).to eq(16)
      expect(described_class.index_to_value(9)).to eq(512)
    end
  end

  describe ".value_to_index" do
    it "converts a flag value to a flag index" do
      expect(described_class.value_to_index(16)).to eq(4)
      expect(described_class.value_to_index(512)).to eq(9)
    end
  end

  describe ".list" do
    it "returns a hash array of all the registered flags" do
      klas = Class.new(described_class)
      klas.define_flag :washer_dryer, 1, "Washer/Dryer"
      klas.define_flag :dishwasher,   2, ""
      klas.define_flag :ac,           4, "A/C"
      expect(klas.list).to eq(
        [
          { name: "washer_dryer", value: 2, display_name: "Washer/Dryer" },
          { name: "dishwasher", value: 4, display_name: "Dishwasher" },
          { name: "ac", value: 16, display_name: "A/C" }
        ]
      )
    end
  end

  describe "#to_i" do
    it "returns an interger value" do
      klas = Class.new(described_class)
      instance = klas.new(16)
      expect(instance.to_i).to eq(16)
    end
  end

  describe "#to_s" do
    it "returns a binary string" do
      klas = Class.new(described_class)
      instance = klas.new(16)
      expect(instance.to_s).to eq("10000")
    end
  end

  describe "#to_a" do
    it "returns a hash array of enabled flags" do
      klas = Class.new(described_class)
      klas.define_flag :washer_dryer, 1, "Washer/Dryer"
      klas.define_flag :dishwasher,   2, ""
      klas.define_flag :ac,           4, "A/C"
      instance = klas.new(22)
      expect(instance.to_a).to eq(
        [
          { name: "washer_dryer", value: 2, display_name: "Washer/Dryer" },
          { name: "dishwasher", value: 4, display_name: "Dishwasher" },
          { name: "ac", value: 16, display_name: "A/C" }
        ]
      )
    end
  end

  describe "#clear" do
    it "sets state to 0" do
      klas = Class.new(described_class)
      instance = klas.new(18)
      instance.clear
      expect(instance.state).to eq(0)
    end
  end
end
