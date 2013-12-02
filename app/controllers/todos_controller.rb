class TodosController < ApplicationController

  before_action :restrict_access, :require_user
  before_action :require_todo, only: [:edit, :show, :destroy, :update]

  def new
    @todo = Todo.new
  end

  def index
    @todos = @user.todos
    respond_to do |format|
      format.html
      format.json { render json: @todos }
    end
  end

  def edit
  end

  def update
    if @todo.update_attributes(todo_params)
      redirect_to todos_path, notice: "Todo was updated successfully"
    else
      flash[:alert] = "Failed to update todo"
      render :edit
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @todo }
    end
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
