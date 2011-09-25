class UgcMailer < ActionMailer::Base
  default from: "jspooner@pushwood.com"

  def change_email(user, location)
    @user     = user
    @location = location
    mail(:to => "chris.r.gonzales@gmail.com, jspooner@pushwood.com", :subject => "[Pushwood] User Edited")
  end
  
end
