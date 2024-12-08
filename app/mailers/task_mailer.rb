class TaskMailer < ApplicationMailer
  def send_email_with_list_tasks(title_tasks:, email:)
    @title_tasks = title_tasks
    mail(to: email, subject: "Task's due date is near")
  end
end
