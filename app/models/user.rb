class User < ActiveRecord::Base
  has_many :spoken_quotes, :class_name => "Quote", :foreign_key => :speaker_user_id
  has_many :quotified_quotes, :class_name => "Quote", :foreign_key => :quotifier_user_id

  validates_presence_of :name
end
