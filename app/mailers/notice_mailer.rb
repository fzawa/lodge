class NoticeMailer < ActionMailer::Base
  default from: ENV['MAIL_SENDER']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_update.subject
  #
  def sendmail_update(user, article)
    @greeting = "Hi"
    @user = user
    @article = article
    mail(
      to: User.pluck(:email),
      subject: '[Lodge] [New] ' + @article.title
    )
  end

  def sendmail_comment(user, article)
    @greeting = "Hi"
    @user = user
    @article = article
    mail(
      to: User.pluck(:email),
      subject: '[Lodge] [Comment] ' + @article.title
    )
  end

end
