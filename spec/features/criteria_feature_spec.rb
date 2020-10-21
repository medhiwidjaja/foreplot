require 'rails_helper'

RSpec.feature "Criteria", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
    let(:root)      { article.criteria.root }
    let(:valid_attributes) {
      { title: 'Criterion 1', description: 'Criterion numero uno' }
    }
    before(:each) { login_as bingley, scope: :user }

    scenario "User creates a new criterion", js: true do
      visit article_criteria_path(article)
      within '.widget-header' do
        expect(page).to have_css('h3', text: "Goal:#{article.title}")
      end
      click_link "New subcriterion"
      fill_in 'title',       with: valid_attributes[:title]
      fill_in 'criterion_description', with: valid_attributes[:description]
      page.choose(option: 'MagiqComparison')
      click_button 'Save'
      expect(page).to have_css('h3', text: 'Criterion 1')
      within '#criteria-tree' do
        expect(page).to have_content 'Criterion 1'
      end
    end

    before { create :criterion, 
      title: 'Important criterion', 
      parent: article.criteria.root, 
      article: article 
    }

    scenario "User clicks a criterion link from the sidepanel", js: true do
      visit article_criteria_path(article)
      expect(page).to_not have_css('h3', text: 'Important criterion')
      page.find('#criteria-tree').find('div.jqtree-element', text: 'Important criterion').click
      expect(page).to have_css('h3', text: 'Important criterion')
    end

    scenario "User creates a new criterion and doesn't fill in the title field" do
      visit new_criterion_path(root)
      fill_in 'title',       with: ''
      click_button 'Save'
      expect(page).to have_content 'Please check the indicated field below.'
    end

    scenario "User should not see delete button on root criterion" do
      visit edit_criterion_path(root)
      expect(page).to_not have_content 'Delete'
    end

    scenario "User views index of criteria" do
      visit article_criteria_path(article)
      expect(page).to have_link('New subcriterion')
      expect(page).to have_link('Edit')
    end

    describe "viewing a single criterion with existing appraisal" do
      before {
        root.appraisals << build(:appraisal, appraisal_method: 'MagiqComparison') 
      }
      scenario "User views a single criterion" do
        visit criterion_path(root)
        expect(page).to have_link('New subcriterion')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Rank method')
      end
    end
  
  end

  context "updating tree structure with existing appraisals" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
    let (:root)    { article.criteria.first }
    let (:warning) { "This action will delete all related comparisons previously created by you and/or other participants (if any).\n\nAre you sure to proceed?" }
    
    before(:each) {
      login_as bingley, scope: :user
      @article = article
      @appraisal = create :appraisal, criterion: root, comparable_type: 'Criterion'
    }

    scenario "When a user creates a new subcriterion, it will warn that related appraisal to parent node will be deleted", js: true do
      visit criterion_path(root)
      msg = accept_confirm do
        click_link "New subcriterion"
      end
      expect(msg).to eq warning
    end

    scenario "When a user creates a new subcriterion, it will warn that related appraisal to parent node will be deleted", js: true do
      @subcriterion = create :criterion, parent: root, article: article
      visit edit_criterion_path(@subcriterion)
      msg = accept_confirm do
        click_link "Delete"
      end
      expect(msg).to eq warning
    end
  end

  context "with other user's article" do
    let!(:bingley) { create :bingley }
    let!(:article) { create :article, :public, user: bingley }
    let!(:darcy) { create :darcy }
    let(:criterion) { article.criteria.first }

    before(:each) { 
      login_as darcy, scope: :user 
    }

    scenario "User views index of criteria" do
      visit article_criteria_path(article)
      expect(page).to_not have_link('New subcriterion')
      expect(page).to_not have_link('Edit')
    end

    describe "viewing a single criterion with existing appraisal" do
      before {
        criterion.children << [build(:criterion), build(:criterion)]
        criterion.appraisals << build(:appraisal, appraisal_method: 'MagiqComparison') 
      }
      scenario "User views a single criterion" do
        visit criterion_path(criterion)
        expect(page).to_not have_link('New subcriterion')
        expect(page).to_not have_link('Edit')
        expect(page).to_not have_link('Rank method')
      end
    end
  end
end