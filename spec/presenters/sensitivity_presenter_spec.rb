require 'rails_helper'

RSpec.describe SensitivityPresenter do
  
  include_context "comparisons context for value tree" 

  let(:value_tree) { 
    ValueTree.new article.id, member.id 
  }

  context "for first criterion" do
    let(:presenter) {
      SensitivityPresenter.new value_tree, root.id, c1.id
    }

    subject { presenter }

    it "gives data for sensitivity chart" do
      expect(presenter.sensitivity_data).to eq( [
        [[0.0, 0.76], [1.0, 0.16000000000000003]], [[0.0, 0.24], [1.0, 0.84]]
      ] )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title] )
    end

    it "gives rank chart data" do
      expect(presenter.chart_data).to eq( [0.6, 0.4] )
    end

    it "gives weight value for sensitivity chart" do
      expect(presenter.weight).to eq( 0.4 )
    end

    it "gives the criterion_id" do
      expect(presenter.criterion_id).to eq( c1.id )
    end
  end

  context "for second criterion" do
    let(:presenter) {
      SensitivityPresenter.new value_tree, root.id, c2.id
    }

    subject { presenter }

    it "gives data for sensitivity chart" do
      expect(presenter.sensitivity_data).to eq( [
        [[0.0, 0.4], [1.0, 0.4]], [[0.0, 0.6], [1.0, 0.6]]
      ] )
    end

    it "gives labels for sensitivity chart" do
      expect(presenter.chart_labels).to eq( [alt1.title, alt2.title] )
    end

    it "gives rank chart data" do
      expect(presenter.chart_data).to eq( [0.6, 0.4] )
    end

    it "gives weight value for sensitivity chart" do
      expect(presenter.weight).to eq( 0.6 )
    end
  end
end