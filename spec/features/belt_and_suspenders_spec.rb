# encoding: utf-8

require 'spec_helper'

describe 'User visits landing page and', js: true do

  before :each do
    visit root_path
  end

  xit 'submits the form' do
    within '#start_panel' do
      select 'p:nth-child(2)', from: 'Selector'
      fill_in 'start-nodeindex', with: '0'
      fill_in 'start-textoffset', with: '2'
    end
    within '#end_panel' do
      select 'p:nth-child(2)', from: 'Selector'
      fill_in 'end-nodeindex', with: '2'
      fill_in 'end-textoffset', with: '4'
    end
    click_button 'Select'
    expected = 'Selection has the base selector .boilerplate.' +
        ' The starting endpoint has the selector p:nth-child(2),' +
        ' the node index 0, ' +
        ' and the text offset 2.' +
        'The ending endpoint has the selector p:nth-child(2),' +
        ' the node index 2,' +
        ' and the text offset 4.'
    expect(page).to have_content expected
  end

end
