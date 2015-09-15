require 'rails_helper'

RSpec.describe "layout/application", type: :view do
  describe '/' do
    before { render template: 'about/landing', layout: 'layouts/application' }

    describe 'head' do
      it 'has meta tags' do
        expect(rendered).to have_tag 'title' do
          with_text /^Автозапчасти Mercedes/
        end
        expect(rendered).to have_tag 'meta', with: {name: 'description'}
      end
    end

    describe 'header' do
      describe 'navigation' do
        it 'has "catalogue"' do
          expect_header_link 'Каталог', '/catalog'
        end
        it 'has "contacts"' do
          expect_header_link 'Контакты', '/about/contacts'
        end
        it 'has "info"' do
          expect_header_link 'Инфо', '/about/info'
        end
      end

        it 'has "cart"' do
          expect_header_link /Корзина/, '/cart'
        end
    end

    describe 'footer' do
      describe 'fast links section' do
        it 'has "catalogue"' do
          expect_footer_link 'Каталог', '/catalog'
        end
        it 'has "contacts"' do
          expect_footer_link 'Контакты', '/about/contacts'
        end
        it 'has "info"' do
          expect_footer_link 'Инфо', '/about/info'
        end
      end

      describe 'other' do
        it 'has creator' do
          expect_footer_selector do
            with_text /.*CDD.*/
          end
        end
        it 'has legal' do
          expect_footer_link 'Политика конфиденциальности', '/policy'
        end
      end
    end
  end
end

def expect_footer_selector(&block)
  expect(rendered).to have_tag "footer#footer" do
    yield
  end
end

def expect_header_link(title, href)
  expect(rendered).to have_tag "header#header" do
    with_tag 'a', with: { title: title, href:href }
  end
end

def expect_footer_link(title, href)
  expect(rendered).to have_tag "footer#footer" do
    with_tag 'a', with: { title: title, href: href }
  end
end
