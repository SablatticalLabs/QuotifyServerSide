class User < ActiveRecord::Base
  has_many :spoken_quotes, :class_name => "Quote", :foreign_key => :speaker_user_id
  has_many :quotified_quotes, :class_name => "Quote", :foreign_key => :quotifier_user_id
  has_many :quote_witness_users
  has_many :witnessed_quotes, :through => :quote_witness_users, :source => :quote

  validate :must_have_email_or_phone

  before_validation do
    self.phone = phone.gsub(/\D/, '') unless self.phone.blank?
  end

  
  def must_have_email_or_phone
    if email.blank? and phone.blank?
       errors[:base] << "Must have an email or phone number for each user"
    end
  end
  
  
  def self.find_or_create(user)
    cur_user = User.new   #This is just used in case no identifying attribute is present - will hit a validation error later.
    if user.nil? then return cur_user end 
    if user[:email] then
      cur_user = User.find_or_create_by_email(user[:email])
    elsif user[:phone] 
      cur_user = User.find_or_create_by_phone(user[:phone])
    end
    cur_user.update_attributes(user)
    return cur_user
  end

  def self.find_all_by_email_case_insensitive(e)
    where "lower(email)= ?", e.downcase
  end

  def same_email_or_phone_as(other)
    self.email.downcase == other.email.downcase || self.phone == other.phone
  end
  
end
