require 'rails_helper'

RSpec.feature "Viz", type: :feature do
  include_context "comparisons context for value tree"

  context "Logged in user" do
    before(:each) { 
      login_as bingley, scope: :user 
    }

    scenario "User views the sankey chart", js: true do
      visit article_viz_path(article)
      within 'svg' do
        expect(page).to have_css('text', text: root.title)
        expect(page).to have_css('text', text: c1.title)
        expect(page).to have_css('text', text: c2.title)
        expect(page).to have_css('text', text: alt1.title)
        expect(page).to have_css('text', text: alt2.title)
      end
    end

    scenario "User clicks a criterion link from the sidepanel", js: true do
      visit article_viz_path(article)

      page.find('#viz-tree').find('div.jqtree-element', text: c1.title).click
      within 'svg' do
        expect(page).to have_css('text', text: c1.title)
        expect(page).to have_css('text', text: alt1.title)
        expect(page).to have_css('text', text: alt2.title)
        expect(page).to_not have_css('text', text: root.title)
        expect(page).to_not have_css('text', text: c2.title)
      end

      page.find('#viz-tree').find('div.jqtree-element', text: c2.title).click
      within 'svg' do
        expect(page).to have_css('text', text: c2.title)
        expect(page).to have_css('text', text: alt1.title)
        expect(page).to have_css('text', text: alt2.title)
        expect(page).to_not have_css('text', text: root.title)
        expect(page).to_not have_css('text', text: c1.title)
      end
    end
  end

end
