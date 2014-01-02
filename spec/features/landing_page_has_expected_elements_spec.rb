# encoding: utf-8

require 'spec_helper'

describe 'User visits landing page' do

  before :each do
    visit root_path
  end

  describe 'which has' do

    describe 'an "#all-content .page-header" grouping div' do

      before :each do
        @selector = '#all-content.container .page-header'
      end

      it 'element' do
        page.should have_selector @selector
      end

      describe 'containing' do

        before :each do
          @element = page.find @selector
        end

        it 'a headline' do
          @element.should have_selector 'h1', text: 'CSAT Demo'
        end

        it 'paragraph(s) of text' do
          @element.should have_selector 'p'
        end

      end # describe 'containing'

    end # describe 'an "#all-content .page-header" grouping div'

    describe 'an "#all-content .page-content" grouping div' do

      before :each do
        @selector = '#all-content > .page-content'
      end

      it 'element' do
        page.should have_selector @selector
      end

      describe 'containing' do

        before :each do
          @element = page.find @selector
          @all_rows = @element.all '.row'
        end

        describe 'four .row divs, where' do

          it 'the first contains an .alertbox div' do
            @all_rows[0].should have_css '#alertbox'
          end

          it 'the second contains a form' do
            @all_rows[1].should have_css 'form#form1'
          end

          describe 'the third' do

            subject { @all_rows[2] }

            it 'contains an h2 header' do
              expect(subject).to have_css 'h2'
            end

            it 'has distinctive styling (a small Bootstrap well)' do
              expect(subject['class']).to eq 'row well well-sm'
            end

          end   # describe 'the third'

          it 'the fourth should contain the .boilerplate content' do
            @all_rows[3].should have_css '.boilerplate'
          end

        end # describe 'four .row divs, where'

      end # describe 'containing'

    end # describe 'an "#all-content .page-content" grouping div'

  end # describe 'which has'

end # describe 'User visits landing page'
