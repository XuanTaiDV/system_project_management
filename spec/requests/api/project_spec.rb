# spec/requests/api/v1/users_spec.rb
require 'rails_helper'
require_relative 'shared/authorized_shared'

RSpec.describe 'Projects API', type: :request do
  include_context 'authorization'

  describe 'GET /api/v1/projects' do
    let(:endpoint) { '/api/v1/projects' }
    let(:create_projects) { FactoryBot.create_list(:project, 100, user: user) }
    let(:page) { 1 }
    let(:per_page) { 100 }
    subject { get endpoint, params: { page: page, per_page: per_page }, headers: headers }

    context 'There is no project in DB' do
      it 'should return list projects' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_body.count).to eq(0)
      end
    end

    context 'Get projects successfully' do
      let(:page) { 2 }
      let(:per_page) { 20 }
      before do
        create_projects
      end

      it 'should return list projects' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_body.count).to eq(per_page)
      end
    end
  end

  describe 'POST /api/v1/projects' do
    subject { post endpoint, params:, headers: headers }

    context 'The given payload is invalid' do
      let(:endpoint) { '/api/v1/projects' }

      context 'when create project with existing name' do
        let(:project) { FactoryBot.create(:project, user_id: user.id) }
        let(:params) { { project: { name: project.name } } }
        it 'raise unprocessable entity error' do
          subject
          json_body = JSON.parse(response.body)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body['details']['name']).to include('has already been taken')
        end
      end

      context 'when params name is empty' do
        let(:params) {{ project: { name: '' } }}
        it 'raise unprocessable entity error' do
          subject
          json_body = JSON.parse(response.body)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body['details']['name']).to include("can't be blank")
        end
      end
    end

    context 'Create project successfully' do
      let(:endpoint) { '/api/v1/projects' }
      let(:params) { { project: { name: 'Project Tai Nguyen' }} }

      it 'should return project' do
        subject
        json_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_body.keys).to contain_exactly('id', 'name', 'description', 'user_id')
      end
    end
  end

  describe 'GET /api/v1/projects/:id' do
    subject { get endpoint, headers: headers }

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
    subject { patch endpoint, params:, headers: headers }
    let(:params) { }

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
      let(:params) { { project: { name: "New name" , description: 'New description' }} }
      it 'should return project' do
        subject

        expect(response).to have_http_status(:ok)
        expect(project.reload.name).to eq(params[:project][:name])
        expect(project.reload.description).to eq(params[:project][:description])
      end
    end
  end
end
