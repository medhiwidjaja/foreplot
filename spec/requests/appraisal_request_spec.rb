require 'rails_helper'

RSpec.describe "Appraisal", type: :request do

  include_context "comparisons context for value tree" 

  before(:each) {
    sign_in bingley
  }
  
  subject { appraisal1 }

  describe "DELETE #destroy" do
    it "destroys the requested appraisal" do
      expect {
        delete appraisal_path(subject.to_param), xhr: true
      }.to change(Appraisal, :count).by(-1)
      .and change(DirectComparison, :count).by(-2)
    end

    it "update the display of criterion and a message" do
      delete appraisal_path(subject.to_param), xhr: true
      expect(response.body).to include("All Direct Comparisons related to this criterion have been deleted.")
    end
  end

end