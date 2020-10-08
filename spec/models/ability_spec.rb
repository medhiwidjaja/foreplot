require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  describe "User" do
    describe "abilities" do
      subject(:ability) { Ability.new(user) }
      let(:user){ nil }
      let(:users_public_article)   { build :article, user: user, private: false}
      let(:users_private_article)  { build :article, user: user, private: true}
      let(:others_public_article)  { build :article, :public }
      let(:public_article)         { build :article, :public }
      let(:private_article)        { build :article, :private }

      context "when is a guest" do
        let(:user) { build :guest_user }

        it { is_expected.not_to be_able_to(:manage, Article.new) }
        it { is_expected.to be_able_to(:read, public_article) }
        it { is_expected.not_to be_able_to(:read, private_article) }
      end

      context "when is a free membership" do
        let(:user)    { create :user, :with_free_account }
        
        it { is_expected.to be_able_to(:manage, users_public_article) }
        it { is_expected.not_to be_able_to(:create, private_article) }
        it { is_expected.not_to be_able_to(:manage, others_public_article) }
        it { is_expected.not_to be_able_to(:read, private_article) }

        it { is_expected.to be_able_to(:manage, Member.new(user: user)) }
        it { is_expected.to be_able_to(:update, user) }
      end

      context "when is a basic membership" do
        let(:user) { create :user, :with_basic_account }

        it { is_expected.to be_able_to(:manage, users_public_article) }
        it { is_expected.to be_able_to(:manage, users_private_article) }
        it { is_expected.not_to be_able_to(:manage, others_public_article) }
        it { is_expected.not_to be_able_to(:read, private_article) }

        it { is_expected.to be_able_to(:manage, Member.new(user: user)) }
        it { is_expected.not_to be_able_to(:manage, Member.new ) }

        it { is_expected.to be_able_to(:update, user) }
      end

      context "when is a academic membership" do
        let(:user){ create :user, :with_academic_account }

        it { is_expected.to be_able_to(:create_report, users_private_article) }
        it { is_expected.to be_able_to(:import_export_excel, users_private_article) }
        it { is_expected.not_to be_able_to(:create_report, public_article) }
        it { is_expected.not_to be_able_to(:import_export_excel, public_article) }
      end

      context "when is a pro membership" do
        let(:user){ create :user, :with_pro_account }

        it { is_expected.to be_able_to(:create_report, public_article) }
        it { is_expected.to be_able_to(:create_pdf_report, public_article) }
        it { is_expected.to be_able_to(:import_export_excel, public_article) }
      end

    end
  end
end