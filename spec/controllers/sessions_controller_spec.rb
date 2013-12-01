require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    before :each do
      get 'new'
    end
    it "returns http success" do
      expect(response).to be_success
    end
    it "assigns new user to @user" do
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "DELETE 'destroy" do
    before :each do
      user = FactoryGirl.create :user
      delete 'destroy', id: user.id
    end
    it "redirects to sign in page" do
      expect(response).to redirect_to(new_session_path)
    end
    it "sets session id to nil" do
      expect(session[:user_id]).to eq(nil)
    end
  end

  describe "POST 'create'" do
    it "assigns user to @user" do
      user = FactoryGirl.create :user
      post 'create', email: user.email
      expect(assigns(:user)).to eq(user)
    end
    it "sets user id to session id is login is successful" do
      user = FactoryGirl.create :user
      post 'create', email: user.email
      expect(session[:user_id]).to eq(user.id)
    end
    it "sets session id to nil is log is not successful" do
      user = FactoryGirl.build :user
      post 'create', email: user.email
      expect(session[:user_id]).to eq(nil)
    end
    it "redirects to todo index page if login is successful" do
      user = FactoryGirl.create :user
      post 'create', email: user.email
      expect(response).to redirect_to(todos_path)
    end
    it "renders new template if login is not successful" do
      user = FactoryGirl.build :user
      post 'create', email: user.email
      expect(response).to render_template(:new)
    end
    it "displays welcome back flash message if login is successful" do
      user = FactoryGirl.create :user
      post 'create', email: user.email
      expect(flash[:notice]).to match(/Welcome back/)
    end
    it "displays log in failed flash message if login is not successful" do
      user = FactoryGirl.build :user
      post 'create', email: user.email
      expect(flash[:alert]).to match(/Log in failed/)
    end
  end

end
