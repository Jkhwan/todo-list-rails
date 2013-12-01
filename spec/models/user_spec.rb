require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.build :user }
  describe "Validation" do
    it "is valid with username, firstname, lastname, password, and password confirmation" do
      expect(user).to be_valid
    end
    it "is invalid without username" do
      user.username = nil
      expect(user).to_not be_valid
      expect(user).to have(1).errors_on(:username)
    end
    it "is invalid without email" do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email].first).to eq("can't be blank")
    end
    it "is invalid without firstname" do
      user.firstname = nil
      expect(user).to_not be_valid
      expect(user).to have(1).errors_on(:firstname)
    end
    it "is invalid without lastname" do
      user.lastname = nil
      expect(user).to_not be_valid
      expect(user).to have(1).errors_on(:lastname)
    end
    it "is invalid without password" do
      user = FactoryGirl.build :user, password: nil
      expect(user).to_not be_valid
      expect(user.errors[:password].first).to eq("can't be blank")
    end
    it "is invalid without password_confirmation" do
      user = FactoryGirl.build :user, password_confirmation: nil
      expect(user).to_not be_valid
      expect(user).to have(1).errors_on(:password_confirmation)
    end
    it "is invalid if password and password_confirmation does not match" do
      user = FactoryGirl.build :user, password_confirmation: "password"
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation].first).to eq("doesn't match Password")
    end
    it "is invalid if password is shorter than 6 characters" do
      user = FactoryGirl.build :user, password: "123"
      expect(user).to_not be_valid
      expect(user.errors[:password].first).to eq("is too short (minimum is 6 characters)")
    end
    it "is invalid if password is longer than 20 characters" do
      user = FactoryGirl.build :user, password: "123456789012345678901"
      expect(user).to_not be_valid
      expect(user.errors[:password].first).to eq("is too long (maximum is 20 characters)")
    end
    it "is invalid to have duplicate username" do
      user.save
      duplicate_username = FactoryGirl.build :user, username: user.username
      expect(duplicate_username).to_not be_valid
      expect(duplicate_username.errors[:username].first).to eq("has already been taken")
    end
    it "is invalid to have duplicate email" do
      user.save
      duplicate_email = FactoryGirl.build :user, email: user.email
      expect(duplicate_email).to_not be_valid
      expect(duplicate_email.errors[:email].first).to eq("has already been taken")
    end
    it "is invalid to have an invalid email" do
      user.email = "email"
      expect(user).to_not be_valid
      expect(user.errors[:email].first).to eq("is invalid")
    end
    it "is valid to have multiple todos" do
      user.save
      first_todo = FactoryGirl.create :todo, user: user
      second_todo = FactoryGirl.create :todo, user: user
      expect(user).to be_valid
      expect(user.todos).to eq([first_todo, second_todo])
    end
    it "is valid to have no todo" do
      user.todos = []
      expect(user.save).to eq(true)
      expect(user.todos).to eq([])
    end
  end
end
