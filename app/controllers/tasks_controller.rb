class TasksController < ApplicationController
	before_action :authenticate_user
	before_action :find_task, only: [:show, :update, :destroy]


	def create
		@task = @current_user.tasks.new(task_params)
		if @task.save
			render json: {task: TaskSerializer.new(@task).serializable_hash  , message: "Task has successfully created"}, status: :created
		else
			render json: {errors: @task.errors.full_messages}, status: :unprocessable_entity
		end
	end

	def index
		@tasks = @current_user.tasks.paginate(page: params[:page],per_page: 3)
		if @tasks.present?
			render json: { tasks: @tasks.map { |task| TaskSerializer.new(task).as_json },
            pagination: pagination_details(@tasks) }, status: :ok
        else
        	render json: { message: "No tasks found here", tasks: [], pagination: {} }, status: :ok
        end
	end

	def show
		render json: @task, each_serializer: TaskSerializer, status: :ok
	end

	def update
		if @task.update(task_params)
			render json: @task, each_serializer: TaskSerializer, status: :ok
		else
			render json: {errors: @task.errors.full_messages},status: :unprocessable_entity
		end
	end

	def destroy
		@task.destroy
		render json: {message: "Task deleted successfully"}, status: :ok
	end

	private

	def find_task
		@task = @current_user.tasks.find_by(id: params[:id])
		render json: {error: "Task not found"}, status: :not_found unless @task
	end

	def task_params
		params.permit(:title, :description, :status, :due_date)
	end

	def pagination_details(task)
		{
			current_page: task.current_page,
		    next_page: task.next_page,
		    previous_page: task.previous_page,
		    total_pages: task.total_pages,
		    total_entries: task.total_entries
		}
	end
end
