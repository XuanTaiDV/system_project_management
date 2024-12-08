every 1.hours do # 1.minute 1.day 1.week 1.month 1.year is also supported
  # the following tasks are run in parallel (not in sequence)
  runner "NotifyTaskDueDateWorker.send_mail_notification"
end
