require 'rails_helper'

RSpec.feature "AHPComparison", type: :feature do
  include_context "criteria context for comparisons"

  context "Logged in user" do
    before(:each) { 
      [c1, c2, c3]
      login_as bingley, scope: :user 
    }

    scenario "User creates a new AHP comparison", js: true do
      visit criterion_path(root)
      within '.btn-group.dropup' do
        find(class:'dropdown-toggle').click
        click_link 'Pairwise method', class:'btn-primary'
      end

      find("#slider-0").find("span").send_keys([:left, :left, :left, :left])
      find("#slider-1").find("span").send_keys([:left, :left])
      find("#slider-2").find("span").send_keys([:right])
      click_button 'Save'
      
      expect(page).to have_content 'Comparison done using AHP Comparison method'
      expect(page).to have_content 'Consistency'
      expect(page).to have_content 'Excellent'
      expect(page).to have_table(with_rows:
        [
          { 'Title' => c1.title, 'Rank' => 1, 'Priority' => '64.8%' },
          { 'Title' => c2.title, 'Rank' => 3, 'Priority' => '12.2%' },
          { 'Title' => c3.title, 'Rank' => 2, 'Priority' => '23.0%' },
        ])
    end

    scenario "User chooses to use verbal scale", js: true do
      visit criterion_new_ahp_comparisons_path(root)

      within '.btn-toolbar' do
        find(class:'dropdown-toggle').click
        click_link 'Verbal scale'
      end

      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content 'somewhat more important'
      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content 'more important'
      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content 'much more important'
      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content 'extremely more important'
    end

    scenario "User chooses to use verbal 9-level scale", js: true do
      visit criterion_new_ahp_comparisons_path(root)

      within '.btn-toolbar' do
        find(class:'dropdown-toggle').click
        click_link 'Verbal scale (9 levels)'
      end

      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content 'equal to somewhat more important'
      find("#slider-0").find("span").send_keys([:left, :left])
      expect(page).to have_content 'somewhat more to more important'
      find("#slider-0").find("span").send_keys([:left, :left])
      expect(page).to have_content 'more to much more important'
      find("#slider-0").find("span").send_keys([:left, :left])
      expect(page).to have_content 'much to extremely more important'
    end

    scenario "User chooses to use free scale", js: true do
      visit criterion_new_ahp_comparisons_path(root)

      within '.btn-toolbar' do
        find(class:'dropdown-toggle').click
        click_link 'Free scale (1.0-9.0)'
      end

      find("#slider-0").find("span").send_keys(:left)
      expect(page).to have_content '1.1 x'
      find("#slider-0").find("span").send_keys([:left, :left])
      expect(page).to have_content '1.3 x'
    end
  end
end