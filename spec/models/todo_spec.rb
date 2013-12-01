require 'spec_helper'

describe Todo do

  let(:todo) { FactoryGirl.build :todo }

  describe "Validation" do

    it "is valid with user, name, due_date and completed fields" do
      expect(todo).to be_valid
    end
    it "is invalid without name" do
      todo.name = nil
      expect(todo).to_not be_valid
      expect(todo).to have(1).errors_on(:name)
      expect(todo.errors[:name].first).to eq("can't be blank")
    end
    it "is invalid if due_date is set to the past" do
      todo.due_date = 1.days.ago
      expect(todo).to_not be_valid
      expect(todo).to have(1).errors_on(:due_date)
      expect(todo.errors[:due_date].first).to eq("can't be in the past")
    end
    it "is invalid if user is not set" do
      todo.user_id = nil
      expect(todo).to_not be_valid
    end
  end

  describe "Filter todo by due date" do

    let(:overdue_todo) { FactoryGirl.build :overdue_todo }    

    it "returns all todos that have passed their due dates" do
      todo.save
      expect(Todo.overdue).to eq([])      
    end

    it "returns all todos that have not passed their due dates" do
      todo.save
      overdue_todo.save
      expect(Todo.on_time).to eq([todo])
    end
  end

  describe "Filter todo by status" do

    let(:completed_todo) { FactoryGirl.build :completed_todo }
    before :each do
      todo.save
      completed_todo.save
    end

    it "returns all todos that are completed" do
      expect(Todo.completed).to eq([completed_todo])
    end
    it "returns all todos that are still in progress" do
      expect(Todo.in_progress).to eq([todo])
    end
  end
end
