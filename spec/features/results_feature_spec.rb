require 'rails_helper'

RSpec.feature "Results", type: :feature do
  include_context "comparisons context for value tree"

  context "Logged in user" do
    before(:each) { 
      login_as bingley, scope: :user 
    }

    scenario "User views the result table" do
      visit article_results_path(article)
      expect(page).to have_table(with_rows:
        [
          { 'Rank' => 1, 'Alternative' => alt2.title, 'Score' => '0.600' },
          { 'Rank' => 2, 'Alternative' => alt1.title, 'Score' => '0.400' }
        ])
    end

    scenario "User views the ranking chart", js: true do
      visit article_results_path(article)
      within '#chart' do
        expect(page).to have_css('div.jqplot-point-label', text: alt1.title)
        expect(page).to have_css('div.jqplot-point-label', text: alt2.title)
      
        canvas = find('canvas.jqplot-event-canvas')
        canvas.click(x:100, y:200)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('span', text: '0.60')
        end
        canvas.click(x:200, y:200)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('span', text: '0.40')
        end
      end
    end

    scenario "User views the detail chart", js: true do
      visit article_results_path(article)
      scroll_to("#detail-chart", align: :bottom)
      within '#detail-chart' do    
        canvas = find('canvas.jqplot-event-canvas')
        canvas.click(x:100, y:100)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('em', text: c2.title)
          expect(page).to have_css('strong', text: "0.36")
        end
        canvas.click(x:100, y:250)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('em', text: c1.title)
          expect(page).to have_css('strong', text: "0.24")
        end
        canvas.click(x:200, y:200)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('em', text: c2.title)
          expect(page).to have_css('strong', text: "0.24")
        end
        canvas.click(x:200, y:250)
        within 'div.jqplot-highlighter-tooltip' do
          expect(page).to have_css('em', text: c1.title)
          expect(page).to have_css('strong', text: "0.16")
        end
      end
    end

    scenario "User clicks a criterion link from the sidepanel", js: true do
      visit article_results_path(article)
      
      page.find('#results-tree').find('div.jqtree-element', text: c1.title).click
      within '#chart' do
        expect(page).to have_css('div.jqplot-point-label', text: alt1.title)
        expect(page).to have_css('div.jqplot-point-label', text: alt2.title)
      end
      expect(page).to_not have_css('#detail-chart')
    end

    describe "When the evaluation is not yet complete" do
      before {
        appraisal1.destroy
      }
      it "shows an error message" do
        visit article_results_path(article)
        expect(page).to have_content('Evaluations of criteria or alternatives are not complete yet')
      end
    end
  end
end