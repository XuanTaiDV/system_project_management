# db/seeds.rb

# Clear existing data (optional, if you want to reset)
Task.destroy_all
Project.destroy_all
User.destroy_all

# Create default user
user = User.create!(email: 'tainx@gmail.com', password: '123456', password_confirmation: '123456')

5.times do |i|
  # Create project
  project = Project.create!(
    name: "Project #{i + 1}",
    description: "Description for project #{i + 1}",
    user_id: user.id
  )

  # Create task for project
  5.times do |j|
    Task.create!(
      title: "Task #{j + 1}",
      description: "Description for project #{j + 1}",
      project_id: project.id,
      status: Task.statuses.keys.sample,
      due_date: [Time.current, nil].sample
    )
  end
end

