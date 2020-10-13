require 'rails_helper'

RSpec.feature "Sensitivity", type: :feature do
  include_context "comparisons context for value tree"

  context "Logged in user" do
    before(:each) { 
      login_as bingley, scope: :user 
    }

    scenario "User views the sensitivity chart", js: true do
      visit article_sensitivity_path(article)

      expect(page).to have_css('h3.wrt', text: c1.title)
      expect(page).to have_content('Current weight value: 0.400')
      
      within '#rank-chart' do
        expect(page).to have_css('div.jqplot-point-label', text: alt1.title)
        expect(page).to have_css('div.jqplot-point-label', text: alt2.title)
      end

      expect(page).to have_css('div.widget-content-title', text: 'RANK AT WEIGHT OF: 0.400')

      within '#sensitivity-chart' do
        canvas = find('canvas.jqplot-event-canvas')
        canvas.click(x:100, y:200)
      end

      expect(page).to_not have_css('div.widget-content-title', text: 'RANK AT WEIGHT OF: 0.400')
    end

    scenario "User clicks a criterion link from the sidepanel", js: true do
      visit article_sensitivity_path(article)

      page.find('#sensitivity-tree').find('div.jqtree-element', text: c2.title).click

      expect(page).to have_css('h3.wrt', text: c2.title)
      expect(page).to have_content('Current weight value: 0.600')
      expect(page).to have_css('div.widget-content-title', text: 'RANK AT WEIGHT OF: 0.600')
    end

    context "When there's only 1 subcriterion", js: true do
      before {
        c1.destroy
      }
      scenario "User sees an error message" do
        visit article_sensitivity_path(article)
        expect(page).to have_content("Sensitivity Analysis on single subcriterion not supported")
      end
    end
  end

end
