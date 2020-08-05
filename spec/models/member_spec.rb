require 'rails_helper'

RSpec.describe Member, type: :model do

  describe "scope: author" do
    let!(:user) { create :user }
    let!(:article) { create :article, user: user }
    let!(:author) { article.members.create(user: user, role: 'owner') }
    let!(:editor) { article.members.create(user: (create :user), role: 'editor') }
    let!(:viewer) { article.members.create(user: (create :user), role: 'viewer') }

    it "includes only the author" do
      expect(Member.author).to include(author)
    end

    it "doesn't include the others" do
      expect(Member.author).not_to include([editor, viewer])
    end
   end

  describe "associations" do
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
    it { expect(described_class.reflect_on_association(:article).macro).to eq(:belongs_to) }
  end
end
