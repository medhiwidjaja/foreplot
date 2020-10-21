require 'rails_helper'

RSpec.feature "DirectComparison", type: :feature do
  include_context "criteria context for comparisons"

  context "Logged in user" do
    before(:each) { 
      [c1, c2, c3]
      login_as bingley, scope: :user 
    }

    scenario "User creates a new direct comparison" do
      visit criterion_path(root)
      within '.btn-group.dropup' do
        find(class:'dropdown-toggle').click
        click_link 'Direct method'
      end
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_0_value', with: 1
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_1_value', with: 4
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_2_value', with: 5
      click_button 'Save'
      
      expect(page).to have_content 'Comparison done using Direct Comparison method'
      expect(page).to have_table(with_rows:
        [
          { 'Title' => c1.title, 'Rank' => 3, 'Priority' => '10.0%' },
          { 'Title' => c2.title, 'Rank' => 2, 'Priority' => '40.0%' },
          { 'Title' => c3.title, 'Rank' => 1, 'Priority' => '50.0%' },
        ])

      find_link('Direct method', class:'btn-primary').click
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_0_value', with: 2
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_1_value', with: 4
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_2_value', with: 5
      click_button 'Save'
      expect(page).to have_table(with_rows:
        [
          { 'Title' => c1.title, 'Rank' => 3, 'Priority' => '18.2%' },
          { 'Title' => c2.title, 'Rank' => 2, 'Priority' => '36.4%' },
          { 'Title' => c3.title, 'Rank' => 1, 'Priority' => '45.5%' },
        ])
    end

    scenario "User chooses to use some optional settings" do
      visit criterion_new_direct_comparisons_path(root)
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_0_value', with: 1
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_1_value', with: 4
      fill_in 'direct_comparisons_form_direct_comparisons_attributes_2_value', with: 5
      choose(option: 'true')
      fill_in 'direct_comparisons_form_range_min', with: 1
      fill_in 'direct_comparisons_form_range_max', with: 5
      click_button 'Save'
      expect(page).to have_content 'Comparison done using Direct Comparison method'
      expect(page).to have_table(with_rows:
        [
          { 'Title' => c1.title, 'Rank' => 1, 'Priority' => '80.0%' },
          { 'Title' => c2.title, 'Rank' => 2, 'Priority' => '20.0%' },
          { 'Title' => c3.title, 'Rank' => 3, 'Priority' => '0.0%' },
        ])
    end
  end
end