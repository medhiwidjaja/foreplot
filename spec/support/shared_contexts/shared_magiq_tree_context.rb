RSpec.shared_context "shared magiq tree context", :shared_context => :metadata do
  let(:bingley)   { create :bingley, :with_articles }
  let(:article)   { bingley.articles.first }
  let(:member)    { article.members.first }
  let(:root)      { article.criteria.first }
  let(:criterion) { root }

  let(:c1)   { create :criterion, title: 'Performance', article: article, parent: criterion, position: 1 }
  let(:c2)   { create :criterion, title: 'Accurary', article: article, parent: criterion, position: 2 }
  let(:c11)  { create :criterion, title: 'Startup', article: article, parent: c1, position: 1 }
  let(:c12)  { create :criterion, title: 'Search', article: article, parent: c1, position: 2 }
  let(:c13)  { create :criterion, title: 'Save', article: article, parent: c1, position: 3 }
  let(:c21)  { create :criterion, title: 'Top results', article: article, parent: c2, position: 1 }
  let(:c22)  { create :criterion, title: 'First screen', article: article, parent: c2, position: 2 }

  let(:alt1) { create :alternative, title: 'A', article: article, position: 1 }
  let(:alt2) { create :alternative, title: 'W', article: article, position: 2 }
  let(:alt3) { create :alternative, title: 'X', article: article, position: 3 }
  let(:alt4) { create :alternative, title: 'Y', article: article, position: 4 }
  let(:alt5) { create :alternative, title: 'Z', article: article, position: 5 }

  let(:appraisal1) { create :appraisal, member_id: member.id, criterion: root, appraisal_method:'MagiqComparison', comparable_type: 'Criterion', rank_method: 'rank_order_centroid' }
  let(:appraisal2) { create :appraisal, member_id: member.id, criterion: c1, appraisal_method:'MagiqComparison', comparable_type: 'Criterion', rank_method: 'rank_order_centroid' }
  let(:appraisal3) { create :appraisal, member_id: member.id, criterion: c2, appraisal_method:'MagiqComparison', comparable_type: 'Criterion', rank_method: 'rank_order_centroid' }
  let(:appraisal4) { create :appraisal, member_id: member.id, criterion: c11, appraisal_method:'MagiqComparison', comparable_type: 'Alternative', rank_method: 'rank_order_centroid' }
  let(:appraisal5) { create :appraisal, member_id: member.id, criterion: c12, appraisal_method:'MagiqComparison', comparable_type: 'Alternative', rank_method: 'rank_order_centroid' }
  let(:appraisal6) { create :appraisal, member_id: member.id, criterion: c13, appraisal_method:'MagiqComparison', comparable_type: 'Alternative', rank_method: 'rank_order_centroid' }
  let(:appraisal7) { create :appraisal, member_id: member.id, criterion: c21, appraisal_method:'MagiqComparison', comparable_type: 'Alternative', rank_method: 'rank_order_centroid' }
  let(:appraisal8) { create :appraisal, member_id: member.id, criterion: c22, appraisal_method:'MagiqComparison', comparable_type: 'Alternative', rank_method: 'rank_order_centroid' }

  let(:roc2) { Foreplot::Magiq::OrdinalScore.rank_order_centroid_table 2 }
  let(:roc3) { Foreplot::Magiq::OrdinalScore.rank_order_centroid_table 3 }
  let(:roc5) { Foreplot::Magiq::OrdinalScore.rank_order_centroid_table 5 }

  let(:value_tree) { 
    ValueTree.new article.id, member.id 
  }

  let(:expected_magiq_score_table) {
    {
      alt3.id=>{:id=>alt3.id, :title=>alt3.title, :score=>0.3479, :rank=>1}, 
      alt1.id=>{:id=>alt1.id, :title=>alt1.title, :score=>0.2449, :rank=>2}, 
      alt5.id=>{:id=>alt5.id, :title=>alt5.title, :score=>0.1946, :rank=>3}, 
      alt4.id=>{:id=>alt4.id, :title=>alt4.title, :score=>0.1459, :rank=>4}, 
      alt2.id=>{:id=>alt2.id, :title=>alt2.title, :score=>0.0667, :rank=>5}
    }
  }

  before do
    appraisal1.magiq_comparisons << magiq(c1, rank: 2, n: 2)
    appraisal1.magiq_comparisons << magiq(c2, rank: 1, n: 2)
    
    appraisal2.magiq_comparisons << magiq(c11, rank: 2, n: 3)
    appraisal2.magiq_comparisons << magiq(c12, rank: 1, n: 3)
    appraisal2.magiq_comparisons << magiq(c13, rank: 3, n: 3)

    appraisal3.magiq_comparisons << magiq(c21, rank: 1, n: 2)
    appraisal3.magiq_comparisons << magiq(c22, rank: 2, n: 2)

    appraisal4.magiq_comparisons << magiq(alt1, rank: 1, n: 5)
    appraisal4.magiq_comparisons << magiq(alt2, rank: 4, n: 5)
    appraisal4.magiq_comparisons << magiq(alt3, rank: 2, n: 5)
    appraisal4.magiq_comparisons << magiq(alt4, rank: 3, n: 5)
    appraisal4.magiq_comparisons << magiq(alt5, rank: 5, n: 5)

    appraisal5.magiq_comparisons << magiq(alt1, rank: 2, n: 5)
    appraisal5.magiq_comparisons << magiq(alt2, rank: 5, n: 5)
    appraisal5.magiq_comparisons << magiq(alt3, rank: 3, n: 5)
    appraisal5.magiq_comparisons << magiq(alt4, rank: 1, n: 5)
    appraisal5.magiq_comparisons << magiq(alt5, rank: 4, n: 5)

    appraisal6.magiq_comparisons << magiq(alt1, rank: 1, n: 5)
    appraisal6.magiq_comparisons << magiq(alt2, rank: 4, n: 5)
    appraisal6.magiq_comparisons << magiq(alt3, rank: 5, n: 5)
    appraisal6.magiq_comparisons << magiq(alt4, rank: 2, n: 5)
    appraisal6.magiq_comparisons << magiq(alt5, rank: 3, n: 5)

    appraisal7.magiq_comparisons << magiq(alt1, rank: 2, n: 5)
    appraisal7.magiq_comparisons << magiq(alt2, rank: 5, n: 5)
    appraisal7.magiq_comparisons << magiq(alt3, rank: 1, n: 5)
    appraisal7.magiq_comparisons << magiq(alt4, rank: 4, n: 5)
    appraisal7.magiq_comparisons << magiq(alt5, rank: 3, n: 5)

    appraisal8.magiq_comparisons << magiq(alt1, rank: 4, n: 5)
    appraisal8.magiq_comparisons << magiq(alt2, rank: 3, n: 5)
    appraisal8.magiq_comparisons << magiq(alt3, rank: 2, n: 5)
    appraisal8.magiq_comparisons << magiq(alt4, rank: 5, n: 5)
    appraisal8.magiq_comparisons << magiq(alt5, rank: 1, n: 5)
  end

end


def magiq(comparable, rank:, n:)
  roc = n == 2 ? roc2 : n == 3 ? roc3 : roc5
  build(:magiq_comparison, score: roc[rank-1], score_n: roc[rank-1], rank: rank, position: comparable.position, title: comparable.title, comparable: comparable)
end
