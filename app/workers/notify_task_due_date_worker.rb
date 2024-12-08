class NotifyTaskDueDateWorker
  def self.send_mail_notification
    grouped_tasks = Task.includes(:project)
                        .on_track.where('due_date > ?', Time.current - 1.day)
                        .group_by { |task| task.project.user_id }
    return if grouped_tasks.empty?

    grouped_tasks.each do |user_id, tasks|
      email = User.find(user_id).email
      title_tasks = tasks.pluck(:title)

      TaskMailer.send_email_with_list_tasks(title_tasks:, email:)
    rescue ActiveRecord::RecordNotFound
        puts "Failed to send mail to user with ID = #{user_id}"
    end
  end
end
