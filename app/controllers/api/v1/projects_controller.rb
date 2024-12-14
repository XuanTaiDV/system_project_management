module Api
  module V1
    class ProjectsController < AuthenticationController
      def index
        render json: Project.paginate(**pagination_params),
               each_serializer: ProjectSerializer
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

      def pagination_params
        @pagination_params ||= params.permit(:page, :per_page).to_hash

        { page: 1, per_page: 100 }.with_indifferent_access.merge(**@pagination_params)
      end
    end
  end
end
