# encoding: utf-8

require 'spec_helper'

describe 'User visits landing page and', js: true do

  before :each do
    visit root_path
  end

  it 'submits the form' do
    within '#start_panel' do
      select 'h1:nth-child(1)', from: 'Selector'
      fill_in 'start-nodeindex', with: '0'
      fill_in 'start-textoffset', with: '5'
    end
    within '#end_panel' do
      select 'p:nth-child(2) > strong:nth-child(2)', from: 'Selector'
      fill_in 'end-nodeindex', with: '0'
      fill_in 'end-textoffset', with: '12'
    end
    click_button 'Select'
    expect(page.find '#alertbox').to have_content expected_content
  end

end

# Why have this return a Regexp? Capybara and/or selenium_webdriver make
# 'interesting' changes to the markup; for example, putting various spurious
# attributes in the `<strong>` tag, and one or more spaces after the `</h1>`
# and the opening `<p>`.
def expected_content
  text = '<h1>is the most important headline</h1>\s*?' +
    '<p>\s*?' +
    'This is ordinary paragraph text within the body of the document,' +
    ' where certain words and phrases may be ' +
    '<em>emphasized</em> to mark them as ' +
    '<strong.*>particularly</strong>'
  Regexp.new text
end
