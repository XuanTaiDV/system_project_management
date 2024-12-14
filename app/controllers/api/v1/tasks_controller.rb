module Api
  module V1
    class TasksController < AuthenticationController
      before_action :require_project, only: %i[index create]
      before_action :require_task, only: %i[show update]

      def index
        task_ransack = @project.tasks.ransack(search_params)
        task_ransack.sorts = 'created_at desc' if task_ransack.sorts.empty?
        result = task_ransack.result(distinct: true)
        tasks = result.limit(params[:per_page] || 10).offset(params[:page] || 1)


        render json: tasks, each_serializer: TaskSerializer
      end

      def create
        task = @project.tasks.create!(permitted_params)

        render json: task
      end

      def show
        render json: @task
      end

      def update
        @task.update!(update_permitted_params)

        render json: @task
      end

      private

      def require_project
        @project = Project.find(params[:project_id])
      end

      def require_task
        @task = Task.find(params[:id])
      end

      def permitted_params
        params.require(:task).permit(:title, :status, :description, :due_date)
      end

      def update_permitted_params
        params.require(:task).permit(:title, :status, :description, :due_date)
      end

      def search_params
        params.require(:q).permit!
      rescue
        {}
      end
    end
  end
end
