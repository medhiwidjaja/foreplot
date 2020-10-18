require 'rails_helper'

RSpec.describe ValueTreePresenter do
  
  context "simple tree" do
    include_context "comparisons context for value tree" 

    let(:value_tree) { 
      ValueTree.new article.id, member.id 
    }
    let(:presenter) {
      ValueTreePresenter.new(value_tree, root.id) {|n| 
        {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} 
      } 
    }
    let(:expected_score_table) {
      {
        alt2.id=>{:id=>alt2.id, :title=>alt2.title, :score=>0.6, :detail=>{c2.id=>{score:0.36, label:c2.title}, c1.id=>{score:0.24, label:c1.title}}, :rank=>1, :ratio=>1.0}, 
        alt1.id=>{:id=>alt1.id, :title=>alt1.title, :score=>0.4, :detail=>{c2.id=>{score:0.24, label:c2.title}, c1.id=>{score:0.16000000000000003, label:c1.title}}, :rank=>2, :ratio=>0.6666666666666667}
       }
    }

    subject { presenter }

    describe ".score_table" do
      it "creates score table for all alternatives" do
        expect(presenter.score_table).to have_key(alt1.id) 
        expect(presenter.score_table).to have_key(alt2.id) 
      end

      it "calculates score table for each alternatives" do
        expect(presenter.score_table).to eq(expected_score_table)
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

    end
  end

  context "complex tree" do
    include_context "shared magiq tree context" 
    
    let(:presenter) {
      ValueTreePresenter.new(value_tree, root.id) {|n| 
        {:id => n.comparable_id, :title => n.title, :score => n.score, :criterion => n.cid} 
      } 
    }

    subject { presenter }
    
    describe "the inputs" do
      it "has valid inputs" do
        (1..8).each do |i|
          expect(send "appraisal#{i}").to be_valid
        end
      end

      it "has valid value_tree" do
        expect(value_tree.invalid).to eq false
      end
    end

    describe ".score_table" do
      it "ranks the alternatives" do
        expect(presenter.score_table.keys).to eq([alt3.id, alt1.id, alt5.id, alt4.id, alt2.id])
      end

      it "calculates score table for each alternatives" do
        [alt1, alt2, alt3, alt4, alt5].each do |alt|
          hash = presenter.score_table[alt.id]
          hash.update(score: hash[:score].round(4))
          expect(hash).to match(hash_including(expected_magiq_score_table[alt.id]))
        end
      end
    end

    describe ".score_table_from_tree with 0.0" do
      before {
        vt = presenter.value_tree
        @new_tree = vt.tree.dup
        node = @new_tree.search_node("#{c1.id}-Criterion").content.update(score: 0.0)
        @score_table = presenter.score_table_from_tree @new_tree, ranked: false
      }
      let(:expected_scores) { [[alt1.id, 0.215], [alt2.id, 0.0692], [alt3.id, 0.4067], [alt4.id, 0.0775], [alt5.id, 0.2317]] }

      it "calculates score table for each alternatives" do
        scores =  @score_table.map {|_,s| [s[:id], s[:score].round(4)] }
        expect(scores).to eq expected_scores
      end
    end

    describe ".score_table_from_tree with max score" do
      before {
        vt = presenter.value_tree
        @new_tree = vt.tree.dup
        node = @new_tree.search_node("#{c1.id}-Criterion")
        siblings_max_scores = node.parent.children.collect{|c| c.content[:score]}.max 
        node.content.update(score: siblings_max_scores)
        node.siblings.each {|sibling| sibling.content.update score: 0.0 }
        @score_table = presenter.score_table_from_tree @new_tree, ranked: false
      }
      let(:expected_scores) { [[alt1.id, 0.3344], [alt2.id, 0.0594], [alt3.id, 0.1715], [alt4.id, 0.3511], [alt5.id, 0.0835]] }

      it "calculates score table for each alternatives" do
        scores =  @score_table.map {|_,s| [s[:id], s[:score].round(4)] }
        expect(scores).to eq expected_scores
      end
    end
  end

end