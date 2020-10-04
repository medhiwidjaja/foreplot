require 'rails_helper'

RSpec.feature "MagiqComparison", type: :feature do

  context "Logged in user" do
    let!(:bingley) { create :bingley, :with_articles }
    let!(:article) { bingley.articles.first }
    let(:member_id) { article.members.first.id }
    let(:root)      { article.criteria.first }
    before(:each) { 
      2.times { create :criterion, article: article, parent: root }
      login_as bingley, scope: :user 
    }

    scenario "User creates a new criterion" do
      visit criterion_new_magiq_comparisons_path(root)

      within '#sortable' do
        expect(page).to have_css("strong", text: root.children.first.title)
        expect(page).to have_css("strong", text: root.children.second.title)
      end
      expect(page).to have_css("input[disabled='disabled']")
    end

    scenario "rank the options using drag and drop", js: true do
      visit criterion_new_magiq_comparisons_path(root)
      
      # Need this to trick capybara to drag the mouse way inside the droppable element.
      # http://heywill.com/blog/2012/12/15/using-capybara-to-drag-a-jquery-ui-sortable-onto-a-jquery-ui-droppable
      page.execute_script("$('ul.droppable:first').prepend($('<div id=\"test_drop_helper\" style=\"position:absolute; top:165px; left:750px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
      target = page.first('#test_drop_helper')
  
      source1 = find('#sortable').find('li', match: :first)
      source1.drag_to target
      source2 = find('#sortable').find('li', match: :first)
      source2.drag_to target

      expect(page).to_not have_css("input[disabled='disabled']")

      click_button 'Save'
      expect(page).to have_content 'Comparison done using Magiq Comparison method'
    end

    scenario "invalid ranking, when there is empty interior rank", js: true do
      visit criterion_new_magiq_comparisons_path(root)
      
      page.execute_script("$('ul.droppable:first').prepend($('<div id=\"test_drop_helper\" style=\"position:absolute; top:220px; left:750px; z-index:-1000; width:10px; height:10px;\" ></div>'))")
      target = page.first('#test_drop_helper')    # this target is actually the second rank slot
  
      source1 = find('#sortable').find('li', match: :first)
      source1.drag_to target
      source2 = find('#sortable').find('li', match: :first)
      source2.drag_to target

      expect(page).to_not have_css("input[disabled='disabled']")

      click_button 'Save'
      expect(page).to have_content 'Interior ranks are empty'
    end
  end
end