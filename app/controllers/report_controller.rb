class ReportController < ApplicationController
  def show
    @esugam_count = Micropost.where("esugam IS NOT NULL").count
    @no_of_cash_application = Micropost.where("esugam IS NULL").count
    @no_of_users = User.count

  end
end
