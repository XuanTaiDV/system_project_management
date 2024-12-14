# spec/requests/api/v1/users_spec.rb
require 'rails_helper'
require_relative 'shared/authorized_shared'

RSpec.describe 'Tasks API', type: :request do
  include_context 'authorization'

  let(:project) { FactoryBot.create(:project, user_id: user.id) }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    let(:endpoint) { "/api/v1/projects/1/tasks" }
    subject { get endpoint, params:, headers: headers }
    let(:params) {}

    context 'There is no project in DB' do
      it 'should return list projects' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'There is no tasks' do
      let(:endpoint) { "/api/v1/projects/#{project.id}/tasks" }

      it 'should return an empty list' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_body.count).to eq(0)
      end
    end

    context 'Filtering status with status' do
      let(:endpoint) { "/api/v1/projects/#{project.id}/tasks" }
      let!(:create_in_progress_tasks) { FactoryBot.create_list(:task, 50, project: project, status: :in_progress ) }
      let!(:create_open_tasks) { FactoryBot.create_list(:task, 50, project: project, status: :open ) }
      let!(:create_done_tasks) { FactoryBot.create_list(:task, 50, project: project, status: :done ) }
      let(:params) { { q: { status_in: [Task.statuses[:open], Task.statuses[:done]] }, page: 1, per_page: 50 } }
      it 'should return an empty list' do
        subject
        json_body = JSON.parse(response.body)
        in_progress_count = json_body.select { Task.statuses[_1['status']] == Task.statuses[:in_progress] }.count
        expect(response).to have_http_status(:ok)
        expect(json_body.count).to eq(50)
        expect(in_progress_count).to eq(0)

      end
    end
  end
end