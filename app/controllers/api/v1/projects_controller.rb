module Api
  module V1
    class ProjectsController < AuthenticationController
      def index
        render json: Project.all, each_serializer: ProjectSerializer
      end

      def show
        render json: Project.find(params[:id])
      end

      def create
        project = Project.create!(permitted_params.merge(user_id: current_user.id))

        render json: project
      end

      def update
        project = Project.find(params[:id])
        project.update!(permitted_params)

        render json: project
      end

      def destroy
        Project.find(params[:id]).destroy!

        render :head
      end

      private

      def permitted_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
