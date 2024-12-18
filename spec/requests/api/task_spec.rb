# spec/requests/api/v1/users_spec.rb
require 'rails_helper'
require_relative 'shared/authorized_shared'

RSpec.describe 'Tasks API', type: :request do
  let(:project) { FactoryBot.create(:project, user_id: user.id) }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    it_behaves_like 'Unauthorization'
    include_context 'authorization'

    let(:endpoint) { "/api/v1/projects/1/tasks" }
    let(:http_method) { :get }
    subject { send(http_method, endpoint, params:, headers: headers) }
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

  describe 'POST /api/v1/projects/:project_id/tasks' do
    it_behaves_like 'Unauthorization'
    include_context 'authorization'

    let(:endpoint) { '/api/v1/projects/1/tasks' }
    let(:http_method) { :post }
    let(:params) {}
    subject { send(http_method, endpoint, params:, headers: headers) }

    context 'Create failed' do
      context 'No project ID found' do
        let(:endpoint) { '/api/v1/projects/1/tasks' }

        it 'raise unprocessable entity error' do
          subject

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'Project is existing' do
        let(:endpoint) { "/api/v1/projects/#{project.id}/tasks" }
        let(:project) { FactoryBot.create(:project, user_id: user.id) }

        context 'when create project with existing name' do
          let(:due_date) { Time.current + 3.days }
          let!(:task) { FactoryBot.create(:task, title: params[:task][:title], project: project) }
          let(:params) { { task: { title: 'title', description: 'description',  due_date: } } }
          it 'raise unprocessable entity error' do
            subject
            json_body = JSON.parse(response.body)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_body['details']['title']).to include('has already been taken')
          end
        end

        context 'when params name is empty' do
          let(:params) {{ task: { name: '' } }}
          it 'raise unprocessable entity error' do
            subject
            json_body = JSON.parse(response.body)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_body['details']['title']).to include("can't be blank")
          end
        end
      end
    end

    context 'Create project successfully' do
      let(:endpoint) { "/api/v1/projects/#{project.id}/tasks" }
      let(:due_date) { Time.current + 3.days }
      let(:project) { FactoryBot.create(:project, user_id: user.id) }
      let(:params) { { task: { title: 'Title Tai Nguyen', description: 'Description', due_date:  }} }

      it 'should return project' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_body.keys).to contain_exactly('id', 'title', 'description', 'project_id', 'due_date', 'status')
        expect(json_body['title']).to eq(params[:task][:title])
        expect(json_body['description']).to eq(params[:task][:description])
        expect(json_body['due_date']).to eq(due_date.to_i)
        expect(Task.statuses[json_body['status']]).to eq(Task.statuses[:open])
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    it_behaves_like 'Unauthorization'
    include_context 'authorization'

    let(:http_method) { :get }
    let(:endpoint) { '/api/v1/projects/1' }
    subject { send(http_method, endpoint, headers: headers) }

    context 'There is no project with the given ID' do
      let(:endpoint) { '/api/v1/projects/1' }
      it 'raise not found error' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to eq('Not found')
      end
    end

    context 'Get project successfully' do
      let(:project) { FactoryBot.create(:project, user: user) }
      let(:endpoint) { "/api/v1/projects/#{project.id}" }

      it 'should return project' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH/PUT /api/v1/projects/:id' do
    it_behaves_like 'Unauthorization'
    include_context 'authorization'

    let(:http_method) { :patch }
    let(:endpoint) { '/api/v1/projects/1' }
    let(:params) { }
    subject { send(http_method, endpoint, params:, headers: headers) }

    context 'There is no project with the given ID' do
      let(:endpoint) { '/api/v1/projects/1' }
      it 'raise not found error' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json_body['message']).to eq('Not found')
      end
    end

    context 'Update project successfully' do
      let(:project) { FactoryBot.create(:project, user: user) }
      let(:endpoint) { "/api/v1/projects/#{project.id}" }
      let(:params) { { project: { name: 'New name' , description: 'New description' }} }
      it 'should return project' do
        subject

        expect(response).to have_http_status(:ok)
        expect(project.reload.name).to eq(params[:project][:name])
        expect(project.reload.description).to eq(params[:project][:description])
      end
    end
  end
end
