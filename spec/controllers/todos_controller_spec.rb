require 'spec_helper'

describe TodosController do

  describe "GET 'new'" do
    context "Logged in" do
      before :each do
        user = FactoryGirl.create :user
        session[:user_id] = user.id
        get 'new'
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it "assigns a new todo to @todo" do
        expect(assigns(:todo)).to be_a_new(Todo)
      end
      it "renders new template if user is logged in" do
        expect(response).to render_template(:new)
      end
    end

    it "redirects to sign in page if user is not logged in" do
      get 'new'
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET 'index'" do
    context "Logged in" do
      before :each do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
        get 'index'
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it "renders index template if user is logged in" do
        expect(response).to render_template(:index)
      end
    end

    context "Assigns todos" do
      before :each do
        @user = FactoryGirl.create :user
        @other_user = FactoryGirl.create :user
        session[:user_id] = @user.id
        @my_todo = FactoryGirl.create :todo, user: @user
        @others_todo = FactoryGirl.create :todo, user: @other_user
        get 'index'
      end
      it "assigns all todos for current user to @todos" do
        expect(assigns(:todos)).to include(@my_todo)
      end
      it "is unable to see any todos that does not belong to current user" do
        expect(assigns(:todos)).to_not include(@others_todo)
      end
    end

    context "Not logged in" do
      it "redirects to sign in page if user is not logged in" do
        get 'index'
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET 'edit'" do
    context "Logged in" do
      before :each do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
        @todo = FactoryGirl.create :todo, user: @user
        get 'edit', id: @todo.id
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it "renders edit template if user is logged in" do
        expect(response).to render_template(:edit)
      end
      it "assigns requested todo to @todo" do
        expect(assigns(:todo)).to eq(@todo)
      end
    end

    context "Authorization" do
      it "throws RecordNotFound if todos does not belong to current user" do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
        @other_todo = FactoryGirl.create :todo
        expect{get 'edit', id: @other_todo.id}.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "Not Logged in" do
      it "redirects to sign in page if user is not logged in" do
        @todo = FactoryGirl.create :todo
        get 'edit', id: @todo.id
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "GET 'show'" do
    context "Logged in" do
      before :each do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
        @todo = FactoryGirl.create :todo, user: @user
        get 'show', id: @todo.id
      end
      it "returns http success" do
        expect(response).to be_success
      end
      it "renders show template if user is logged in" do
        expect(response).to render_template(:show)
      end
      it "assigns requested todo to @todo" do
        expect(assigns(:todo)).to eq(@todo)
      end
    end

    context "Authorization" do
      it "throws RecordNotFound if todos does not belong to current user" do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
        @other_todo = FactoryGirl.create :todo
        expect{get 'show', id: @other_todo.id}.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "Not Logged in" do
      it "redirects to sign in page if user is not logged in" do
        @todo = FactoryGirl.create :todo
        get 'show', id: @todo.id
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    context "Logged in" do
      before :each do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
      end
      it "redirects to todo index page" do
        @todo = FactoryGirl.create :todo, user: @user
        delete 'destroy', id: @todo.id
        expect(response).to redirect_to(todos_path)
      end
      it "displays 'todo was deleted' flash message" do
        @todo = FactoryGirl.create :todo, user: @user
        delete 'destroy', id: @todo.id
        expect(flash[:notice]).to match(/deleted successfully/)
      end
      it "throws error if todo does not belong to current user" do
        @todo = FactoryGirl.create :todo
        expect{ delete 'destroy', id: @todo.id }.to raise_error ActiveRecord::RecordNotFound
      end
      it "deletes todo from database" do
        @todo = FactoryGirl.create :todo, user: @user
        delete 'destroy', id: @todo.id
        expect(assigns(:todo)).to be_frozen
      end
    end
  end

  describe "POST 'create'" do
    context "Logged in" do
      before :each do
        @user = FactoryGirl.create :user
        session[:user_id] = @user.id
      end
      it "redirects to todo#index if saved successfully" do
        post 'create', todo: FactoryGirl.attributes_for(:todo)
        expect(response).to redirect_to(todos_path)
      end
      it "renders todo#new if failed to save" do
        post 'create', todo: FactoryGirl.attributes_for(:todo, name: nil)
        expect(response).to render_template(:new)
      end
      it "saves successfully in database" do
        post 'create', todo: FactoryGirl.attributes_for(:todo)
        expect(assigns[:todo]).to_not be_a_new(Todo)  
      end
      it "assigns updated todo to @todo" do
        post 'create', todo: FactoryGirl.attributes_for(:todo, name: "todo1")
        expect(assigns[:todo].name).to eq("todo1")     
      end
      it "displays flash message on success" do
        post 'create', todo: FactoryGirl.attributes_for(:todo)
        expect(flash[:notice]).to eq("Todo was created successfully")  
      end
    end
    context "Not logged in" do
      it "redirects to login page if user is not logged in" do
        post 'create', todo: FactoryGirl.attributes_for(:todo)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

end
