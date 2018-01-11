# Block for handling an expired task from Simple Scheduler
# @param exception [SimpleScheduler::FutureJob::Expired]
# @see http://www.rubydoc.info/github/simplymadeapps/simple_scheduler/master/SimpleScheduler/FutureJob/Expired
SimpleScheduler.expired_task do |exception|
  ExceptionNotifier.notify_exception(
    exception,
    data: {
      task: exception.task.name,
      scheduled: exception.scheduled_time,
      actual: exception.run_time
    }
  )
end
