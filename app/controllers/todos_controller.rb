class TodosController < ApplicationController

  before_action :restrict_access, :require_user
  before_action :require_todo, only: [:edit, :show, :destroy]

  def new
    @todo = Todo.new
  end

  def index
    @todos = @user.todos
  end

  def edit
  end

  def show
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "#{@todo.name} was deleted successfully"
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user = @user
    if (@todo.save)
      redirect_to todos_path, notice: "Todo was created successfully"
    else
      render :new
    end
  end

  protected

  def require_todo 
    @todo = @user.todos.find(params[:id])
  end

  def require_user
    @user = current_user
  end

  def todo_params
    params.require(:todo).permit(:name, :completed, :due_date)
  end
end
