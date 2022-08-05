require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST comments#create' do
    context 'with valid attrs' do
      before do
        # devise stuff
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(create(:user))
      end

      it 'saves new comment to db' do
        expect { post :create, params: { comment: attributes_for(:comment) } }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attrs' do
      it 'not saved new comment to db' do
        expect { post :create, params: { comment: attributes_for(:comment) } }.to_not change(Comment, :count)
      end
    end
  end
end
