class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    User.find_each.each do |user|
      DailyDigestMailer.with(user: user).daily_digest.deliver_now
    end
  end
end
