class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    if params[:query].present?
      @tasks = Task.where(status: params[:query])
    else
      @tasks = Task.all
    end
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: @task, status: 200
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private
    def set_task
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Task not found' }, status: :not_found
    end

    def task_params
      params.require(:task).permit(:title, :description, :status)
    end
end

