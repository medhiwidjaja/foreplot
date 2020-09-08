require 'rails_helper'

RSpec.feature "Criteria", type: :feature do
  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
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
      page.find('#criteria-tree').find('div.jqtree-element', text: 'Important criterion').click
      expect(page).to have_css('h3', text: 'Important criterion')
    end
  
  end
end