module Api
  module V1
    class TasksController < AuthenticationController
      def index
        search_params = { project_id: params[:project_id], status: params[:status] }.compact
        tasks = Task.where(**search_params)

        render json: tasks, each_serializer: TaskSerializer
      end

      def show
        render json: Task.find(params[:id])
      end

      def create
        task = Task.create!(permitted_params.merge(project_id: params[:project_id]))

        render json: task
      end

      def update
        task = Task.update!(update_permitted_params)

        render json: task
      end

      private

      def permitted_params
        params.require(:task).permit(:title, :description, :due_date)
      end

      def update_permitted_params
        params.require(:task).permit(:title, :description, :due_date)
      end
    end
  end
end
