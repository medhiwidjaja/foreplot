require 'foreplot/magiq/ordinal_score'

RSpec.describe Foreplot::Magiq::OrdinalScore do
  
  subject { Foreplot::Magiq::OrdinalScore }

  it "knows how to calculate rank_order_centroid" do
    expect(subject.rank_order_centroid_table 3).to eq [0.611111111111111, 0.27777777777777773, 0.1111111111111111]
  end

  it "knows how to calculate rank_sum_table" do
    expect(subject.rank_sum_table 4).to eq [0.4, 0.3, 0.2, 0.1]
  end

  it "knows how to calculate rank_reciprocal_centroid" do
    expect(subject.rank_reciprocal_table 4).to eq [0.48, 0.24, 0.15999999999999998, 0.12]
  end

  it "knows how to calculate rank_exponential" do
    expect(subject.rank_exponential_table 4).to eq [0.27991631056633925, 0.26426549301342617, 0.2436813018392995, 0.21213689458093501]
  end

  it "the score table given ranks" do
    expect(subject.score [1, 2, 3, 3]).to eq [0.5208333333333334, 0.2708333333333333, 0.10416666666666666, 0.10416666666666666]
  end

  it "also validates the input" do
    expect{ subject.score [1, 3, 3, 5, 5] }.to raise_error Foreplot::EmptyInteriorRankError, "Interior ranks are empty: 2, 4"
  end
end