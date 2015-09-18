require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations:' do
    before(:all) do
      CatGroup.delete_all
      CatGroup.create!(name: 'Group')
      c = Category.new(name: 'Category')
      c.cat_groups << CatGroup.first
      c.save!
    end

    after(:all) do
      Category.delete_all
      CatGroup.delete_all
    end
    let(:full_params) {{
      name: 'some name',
      serial: 'W237984792834',
      description: 'Wow. This is awesome piece of METAL!',
      notice: 'Free shipping to your planet!',
      price: 99.99,
      count: 200,
      category_id: Category.first.id
    }
    }
    context 'given no name' do
      before { full_params.delete(:name) }
      it 'fails validation' do
        expect( Item.new(full_params).valid? ).to be_falsy
      end
    end
    context 'given no serial' do
      before { full_params.delete(:serial) }
      it 'fails validation' do
        expect(Item.new(full_params).valid?).to be_falsy
      end
    end
    context 'given no description' do
      before { full_params.delete(:description) }
      it 'fails validation' do
        $stderr.puts full_params.inspect
        expect(Item.new(full_params).valid?).to be_falsy
      end
    end
    context 'given no category' do
      before { full_params.delete(:category_id) }
      it 'fails validation' do
        expect(Item.new(full_params).valid?).to be_falsy
      end
    end

    context 'given all' do
      it 'is valid' do
        expect(Item.new(full_params).valid?).to be_truthy
      end
    end
  end
end
