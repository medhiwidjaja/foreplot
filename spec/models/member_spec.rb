require 'rails_helper'

RSpec.describe Member, type: :model do

  let!(:bingley) { create :bingley }
  let!(:another_user) { create :user } 
  let!(:article) { create :article, user: bingley }
  let(:author) { article.members.take }
  let!(:editor) { create :member, article: article, user:(create :user), role: 'editor' }

  describe "scope: author" do
    it "includes only the author" do
      expect(article.members.author.size).to eq(1)
      expect(article.members.author.take.user).to eq(bingley)
    end
  end
  
  describe "validations" do 
    it "should not allow same user as members" do
      duplicate = article.members.new(user: bingley, role: 'editor')
      expect(duplicate).to be_invalid
    end

    it "should not allow deletion of owner" do
      owner = article.members.author.take
      expect{ owner.destroy }.to change(Member, :count).by(0)
    end

    it "should allow deletion of editor, though" do
      expect{ editor.destroy }.to change(Member, :count).by(-1)
    end

    it "should not have more than 1 owner" do
      thief = build :member, article: article, user: another_user, role: 'owner'
      expect(thief).to be_invalid
    end
  end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
  end
end
