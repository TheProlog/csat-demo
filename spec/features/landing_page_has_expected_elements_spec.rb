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

        it 'three .row divs' do
          expect(@all_rows.length).to eq 3
        end

        it 'no other non-blank children' do
          children = @element.native.children.to_a.delete_if(&:blank?)
          expect(children.length).to eq @all_rows.length
        end

        describe 'a first row that' do

          before :each do
            row = @element.all('.row').to_a.first
            @children = row.native.children.to_a.delete_if(&:blank?)
          end

          it 'contains a form element' do
            expect(@children.first.name).to eq 'form'
          end

          describe 'contains a form element that' do

            before :each do
              @form = @children.first
              @children = @form.children.to_a.delete_if(&:blank?)
            end

            it 'contains three child elements' do
              expect(@children.length).to eq 3
            end

            it 'contains a (wrapped) button as the last child' do
              container = @children.to_a.last
              expect(container['class']).to eq 'col-md-2'
              button = container.children[1]
              expect(button.name).to eq 'button'
              expect(button['class'].split ' ').to include 'btn-primary'
            end

            it 'contains two .col-md-5 divs and a button' do
              [0, 1].each do |index|
                expect(@children[index]['class']).to eq 'col-md-5'
              end
            end

            describe 'contains two divs that each' do

              pending 'need to be described'

            end # describe 'contains two divs that'

          end # describe 'contains a form element that'

          it 'contains no other elements' do
            expect(@children.length).to eq 1
          end

        end

        describe 'a second row that' do

          before :each do
            @row = @element.all('.row').to_a[1]
          end

          it 'is a small "well"-styled row div' do
            classes = @row['class'].split ' '
            %w(row well-sm well).each do |klass|
            # ['row', 'well-sm', 'well'].each do |klass|
              expect(classes).to include klass
            end
          end

          it 'contains an h2 element with the correct caption' do
            children = @row.native.children.to_a.delete_if(&:blank?)
            element = children.first
            expect(element.name).to eq 'h2'
            expected_text = 'Content affected by the selection is below.'
            expect(element.text).to eq expected_text
          end

        end # describe 'a second row that itself contains'

        describe 'a third row that itself contains' do

          before :each do
            @row = @element.all('.row').last
          end

          it 'a 12-column .boilerplate div' do
            @row.should have_selector '.boilerplate.col-md-12'
          end

          it 'no other children' do
          end

        end # describe 'a third row that itself contains'

      end # describe 'containing'

    end # describe 'an "#all-content .page-content" grouping div'

  end # describe 'which has'

end # describe 'User visits landing page'
