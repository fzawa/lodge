class MailtoInterceptor
	def self.delivering_email(mail)
		domain = ENV["LODGE_MAIL_DOMAIN"]
		if !domain.nil?
			r = Regexp.new(/.+@#{domain}$/)
			filtered_mail_to = mail.to.find_all do |emaddr|
				r =~ emaddr
			end
			mail.to = filtered_mail_to
		end
	end
end
