require 'rails_helper'

RSpec.describe ValueTreePresenter do
  
  include_context "comparisons context for value tree" 

  let(:value_tree) { 
    ValueTree.new article.id, member.id 
  }
  let(:presenter) {
    ValueTreePresenter.new value_tree, root.id
  }

  subject { presenter }

  describe ".score_table" do
    it "creates score table for all alternatives" do
      expect(presenter.score_table).to have_key(alt1.id) 
      expect(presenter.score_table).to have_key(alt2.id) 
    end

    it "calculates global scores for each alternatives" do
      expect(presenter.score_table[alt1.id]).to match(hash_including(score: 0.4*0.4 + 0.6*0.4))
      expect(presenter.score_table[alt2.id]).to match(hash_including(score: 0.4*0.6 + 0.6*0.6))
    end

    it "calculates normalized ratios for each alternatives" do
      expect(presenter.score_table[alt1.id]).to match(hash_including(ratio: 0.6666666666666667))
      expect(presenter.score_table[alt2.id]).to match(hash_including(ratio: 1.0))
    end

    it "contains titles of each alternatives" do
      expect(presenter.score_table[alt1.id]).to match(hash_including(title: alt1.title))
      expect(presenter.score_table[alt2.id]).to match(hash_including(title: alt2.title))
    end

    it "sorts and ranks the alternatives" do
      expect(presenter.score_table.keys).to eq [alt2.id, alt1.id]
      expect(presenter.score_table.values.first).to match(hash_including(rank: 1))
      expect(presenter.score_table.values.last).to match(hash_including(rank: 2))
    end

    it "know the detail breakdown of the score by criteria" do
      expect(presenter.score_table.values.first).to match(hash_including(detail: {c1.id => 0.4*0.6, c2.id => 0.6*0.6}))
      expect(presenter.score_table.values.second).to match(hash_including(detail: {c1.id => 0.4*0.4, c2.id => 0.6*0.4}))
    end
  end
end