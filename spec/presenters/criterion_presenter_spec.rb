require 'rails_helper'

RSpec.describe CriterionPresenter do
  
  include_context "comparisons context for value tree" 

  let(:presenter) {
    CriterionPresenter.new root, bingley, {article_id: article.id, member_id: member.id}
  }

  subject { presenter }

  describe "new" do
    it "initializes article and member" do
      expect(presenter.article).to eq(article)
      expect(presenter.member).to eq(member)
      expect(presenter.member_id).to eq(member.id)
    end
  end

  it "knows the criteria of the article" do
    expect(presenter.criteria).to eq(article.criteria)
  end

  it "knows the appraisal of the current node" do
    expect(presenter.appraisal).to eq(appraisal1)
  end

  let(:dc1) { appraisal1.direct_comparisons.first }
  let(:dc2) { appraisal1.direct_comparisons.second }
  let(:expected_table) {
    [ {no: 1, rank: 2, title: dc1.title, score:0.4, score_n:0.4, value: 8},
      {no: 2, rank: 1, title: dc2.title, score:0.6, score_n:0.6, value: 12 } ]
  }
  describe ".table" do
    it "knows how to build the result table" do
      expect(presenter.table).to eq(expected_table) 
    end
  end

  describe ".comparison_name" do
    it "response with the comparison name for display" do
      expect(presenter.comparison_name).to eq('Direct Comparison')
    end
  end
end