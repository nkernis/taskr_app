class TasksController < ApplicationController
  before_action :signed_in, except: [:index]
  before_action :find_task, only: [:show, :edit, :update, :destroy, :add_task, :complete_task, :remove_task]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @event = Event.find(params[:event_id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "you done created it~"
      redirect_to task_path(@task)
    else
      flash[:error] = "nerp!"
      # render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "you done did it~"
      redirect_to task_path(@task)
    else
      flash[:error] = "no no no..."
      render :update
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "gewd jerb!"
    redirect_to root_path
  end

  def add_task
    @task.update(user: current_user, status: "in progress")
    redirect_to event_path(@task.event)
  end
#only an option if task.user_id == current_user.id && only an option if the task status is pending
  def complete_task
    @task.update(status: "complete")
    redirect_to event_path(@task.event)
  end
#only an option if task.user_id == current_user.id && if the task status is pending
  def remove_task
    @task.update(user: nil, status: "open")
    redirect_to event_path(@task.event)
  end

  private

  def task_params
    params.require(:task).permit(:title, :task_location, :description, :priority, :event_id, :location_id, :status)
  end

  def find_task
    @task = Task.find(params[:id])
  end

end
