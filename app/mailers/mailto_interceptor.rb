class MailtoInterceptor
	def self.delivering_email(mail)
		r = Regexp.new(/.+@music.yamaha.com$/)
		filtered_mail_to = mail.to.find_all do |emaddr|
			r =~ emaddr
		end
		mail.to = filtered_mail_to.dup
	end
end