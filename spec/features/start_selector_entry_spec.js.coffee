# encoding: utf-8

require 'spec_helper'

describe 'User visits landing page', js: true do

  before :each do
    visit root_path
  end

  describe 'and immediately clicks the "Select" button' do

    before :each do
      click_button 'Select'
    end

    describe 'it displays an error for the' do

      it '"Start Selector" field' do
        selector = '.col-md-5:nth-child(1) ' +
            '.panel .panel-body .form-group:nth-child(1)' +
            ' .start_selectorformError'
        page.should have_selector(selector)
      end

      it '"End Selector" field' do
        selector = '.col-md-5:nth-child(2) ' +
            '.panel .panel-body .form-group:nth-child(1)' +
            ' .end_selectorformError'
        page.should have_selector(selector)
      end

    end # describe 'it displays an error for the'

  end # describe 'and immediately clicks the "Submit" button'

end # describe 'User visits landing page'

