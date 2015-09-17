require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  valid_params = {category: { name: 'some name' }}
  invalid_params1 = { category: { other: 'some' }}
  invalid_params2 = { some_val: { name: 'some' }}

  context 'authorized admin' do
    before :each do
      controller.stub(:admin?) { true }
      CatGroup.new(name: 'valid name').save 
    end

    describe 'POST' do
      context 'with valid params' do
        it 'performs action' do
          post :create, valid_params
          expect(response.status).to eq 200
        end
      end
      context 'with invalid params' do
        it 'returns "unprocessable entity"' do
          post :create, invalid_params1
          expect(response.status).to eq 422
          post :create, invalid_params2
          expect(response.status).to eq 422
        end
      end
    end
    describe 'PUT' do
      let(:record) { CatGroup.first }
      it 'performs action' do
        expect(record.id).not_to be_nil
        put :update, valid_params.deep_merge(cg_id: record.id )
        expect(response.status).to eq 200
      end
    end
    describe 'DELETE' do
      let(:record) { CatGroup.first }
      it 'performs action' do
        delete :destroy, cg_id: record.id
        expect(response.status).to eq 200
      end
    end
    describe 'GET new' do
      it 'performs action' do
        get :new
        expect(response.status).to eq 200
      end
    end
    describe 'GET edit' do
      let(:record) { CatGroup.first }
      it 'performs action' do
        get :edit, cg_id: record.id
        expect(response.status).to eq 200
      end
    end
  end

  context 'unauthorized user' do
    before :each do
      CatGroup.new(name: 'valid name').save 
    end

    describe 'POST' do
      it 'forbids action' do
        post :create, valid_params
        expect(response.status).to eq 403
      end
    end
    describe 'PUT' do
      let(:record) { CatGroup.first }
      it 'forbids action' do
        put :update, valid_params.deep_merge(cg_id: record.id)
        expect(response.status).to eq 403
      end
    end
    describe 'DELETE' do
      let(:record) { CatGroup.first }
      it 'forbids action' do
        delete :destroy, cg_id: record.id
        expect(response.status).to eq 403
      end
    end
    describe 'GET new' do
      it 'forbids action' do
        get :new
        expect(response.status).to eq 403
      end
    end
    describe 'GET edit' do
      let(:record) { CatGroup.first }
      it 'forbids action' do
        get :edit, cg_id: record.id
        expect(response.status).to eq 403
      end
    end
  end

  context 'indifferent of auth' do
    describe 'GET index' do
      before { get :index }
      it 'assigns @cgs' do
        expect(assigns(:cgs)).not_to be_nil
      end
    end

    describe 'GET index JSON' do
      before { get :index, format: :json }
      it 'returns valid JSON' do
        expect(response.status).to eq(200)
        parsed = JSON.parse response.body
        expect(parsed['cat_groups']).to be_an Array
      end
    end
  end
end
