require 'mail'

class EmailValidator < ActiveModel::EachValidator

  def validate_each(record,attribute,value)
    # reject reserved address
    if value == Settings.lodge[:guest_email] then
      record.errors[attribute] << (I18n.t("errors.format") % { :attribute => options[:message], :message => I18n.t("errors.messages.exclusion") })
      return
    end

    begin
      m = Mail::Address.new(value)
      # We must check that value contains a domain, the domain has at least
      # one '.' and that value is an email address
      r = m.domain!=nil && m.domain.match('\.') && m.address == value
      # Check domain
      if ENV["LODGE_MAIL_DOMAIN"].present? then
        r = m.domain==ENV["LODGE_MAIL_DOMAIN"]
      end 
    rescue
      r = false
    end
    record.errors[attribute] << (options[:message] || "is invalid") unless r
  end

end
