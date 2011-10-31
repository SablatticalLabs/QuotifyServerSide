class Quote < ActiveRecord::Base
  belongs_to :speaker, :class_name => "User", :foreign_key => "speaker_user_id"
  belongs_to :quotifier, :class_name => "User", :foreign_key => "quotifier_user_id"
  validates_presence_of :quotifier, :speaker
  validates_associated :quotifier, :speaker
end
