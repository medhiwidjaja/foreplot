require 'rails_helper'

RSpec.describe SensitivityPresenter do

  context "for first criterion" do
      
    include_context "comparisons context for value tree" 

    let(:value_tree) { 
      ValueTree.new article.id, member.id 
    }
    let(:presenter) {
      SensitivityPresenter.new value_tree, root.id, c1.id
    }

    subject { presenter }

    it "has valid inputs" do
      expect(appraisal1).to be_valid
      expect(appraisal2).to be_valid
      expect(appraisal3).to be_valid
    end

    it "gives data for sensitivity chart" do
      expect(presenter.sensitivity_data).to eq( [
        [[0.0, 0.4], [1.0, 0.4]], [[0.0, 0.6], [1.0, 0.6]]
      ] )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title] )
    end

    it "gives rank chart data" do
      expect(presenter.chart_data).to eq( [0.4, 0.6] )
    end

    it "gives weight value for sensitivity chart" do
      expect(presenter.weight).to eq( 0.4 )
    end

    it "gives the criterion_id" do
      expect(presenter.criterion_id).to eq( c1.id )
    end
  end

  context "for second criterion" do 
    include_context "comparisons context for value tree" 

    let(:value_tree) { 
      ValueTree.new article.id, member.id 
    }
    let(:presenter) {
      SensitivityPresenter.new value_tree, root.id, c2.id
    }

    subject { presenter }

    it "has valid inputs" do
      (1..3).each do |i|
        expect(send "appraisal#{i}").to be_valid
      end
    end

    it { expect(presenter.title).to eq c2.title }

    it "gives data for sensitivity chart" do
      expect(presenter.sensitivity_data).to eq( [
        [[0.0, 0.4], [1.0, 0.4]], [[0.0, 0.6], [1.0, 0.6]]
      ] )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title] )
    end

    it "gives rank chart data" do
      expect(presenter.chart_data).to eq( [0.4, 0.6] )
    end

    it "gives weight value for sensitivity chart" do
      expect(presenter.weight).to eq( 0.6 )
    end
  end

  context "Single subcriterion" do 
    include_context "comparisons context for value tree" 

    let(:value_tree) { 
      ValueTree.new article.id, member.id 
    }
    let(:presenter) {
      SensitivityPresenter.new value_tree, root.id, c1.id
    }
    before {
      c2.destroy
    }

    it "raises an error" do
      expect{ presenter }.to raise_error(StandardError, /Cannot do sensitivity analysis on single subcriterion/)
    end
  end

  context "complex tree for criterion c1" do
    include_context "shared magiq tree context" 

    let(:presenter) {
      SensitivityPresenter.new(value_tree, root.id, c1.id)
    }

    let(:expected_sensitivity_data) {
      [
        [[0.0, 0.2150], [1.0, 0.3344]], 
        [[0.0, 0.0692], [1.0, 0.0594]], 
        [[0.0, 0.4067], [1.0, 0.1715]], 
        [[0.0, 0.0775], [1.0, 0.3511]], 
        [[0.0, 0.2317], [1.0, 0.0835]]
      ]
    }

    subject { presenter }

    it "has valid inputs" do
      (1..8).each do |i|
        expect(send "appraisal#{i}").to be_valid
      end
    end

    it "has valid value_tree" do
      expect(value_tree.invalid).to eq false
    end

    it { expect(subject.title).to eq c1.title }

    it "gives data for sensitivity chart" do
      rounded_figures = presenter.sensitivity_data.map {|row| row.map{|coord| coord.map{|p| p.round(4)}}}
      expect(rounded_figures).to eq( expected_sensitivity_data )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title, alt3.title, alt4.title, alt5.title] )
    end

    it "gives rank chart data" do
      rounded_figures = presenter.chart_data.map {|p| p.round(4)}
      expect(rounded_figures).to eq( [0.2449, 0.0667, 0.3479, 0.1459, 0.1946] )
    end

    it "gives weight value for sensitivity chart" do
      expect(presenter.weight).to eq( 0.25 )
    end
  end

  context "complex tree for criterion c2" do
    include_context "shared magiq tree context" 

    let(:presenter) {
      SensitivityPresenter.new(value_tree, root.id, c2.id)
    }

    let(:expected_sensitivity_data_for_c2) {
      [
        [[0.0, 0.3344], [1.0, 0.2150]], 
        [[0.0, 0.0594], [1.0, 0.0692]], 
        [[0.0, 0.1715], [1.0, 0.4067]], 
        [[0.0, 0.3511], [1.0, 0.0775]], 
        [[0.0, 0.0835], [1.0, 0.2317]]
      ]
    }

    subject { presenter }

    it "gives data for sensitivity chart" do
      rounded_figures = presenter.sensitivity_data.map {|row| row.map{|coord| coord.map{|p| p.round(4)}}}
      expect(rounded_figures).to eq( expected_sensitivity_data_for_c2 )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title, alt3.title, alt4.title, alt5.title] )
    end
  end
end