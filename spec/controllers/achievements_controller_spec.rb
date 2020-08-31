# frozen_string_literal: true

require 'rails_helper'

describe AchievementsController, type: :controller do
  describe 'GET show' do
    let(:achievement) { FactoryBot.create(:public_achievement) }

    it 'renders :show template' do
      get :show, params: { id: achievement }
      expect(response).to render_template(:show)
    end

    it 'assigns requested achievement to @achievement' do
      get :show, params: { id: achievement }
      expect(assigns(:achievement)).to eq(achievement)
    end
  end

  describe 'GET new' do
    it 'renders :new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns new Achievement to @achievement' do
      get :new
      expect(assigns(:achievement)).to be_a_new(Achievement)
    end
  end

  describe 'POST create' do
    context 'with valid achievement' do
      let(:valid_achievement) { FactoryBot.attributes_for(:public_achievement) }
      it 'redirects to achievements#show' do
        post :create, params: { achievement: valid_achievement }
        expect(response).to redirect_to(achievement_path(assigns[:achievement]))
      end

      it 'creates new achievement in database' do
        expect do
          post :create, params: { achievement: valid_achievement }
        end.to change(Achievement, :count).by(1)
      end
    end
    context 'with invalid achievement' do
      let(:invalid_achievement) { FactoryBot.attributes_for(:public_achievement, title: '') }

      it 'renders :new template' do
        post :create, params: { achievement: invalid_achievement }
        expect(response).to render_template(:new)
      end

      it "doesn't create new achievement in the database" do
        expect do
          post :create, params: { achievement: invalid_achievement }
        end.to_not change(Achievement, :count)
      end
    end
  end
end
