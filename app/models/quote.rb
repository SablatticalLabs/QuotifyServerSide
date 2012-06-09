class Quote < ActiveRecord::Base
  belongs_to :speaker, :class_name => "User", :foreign_key => "speaker_user_id"
  belongs_to :quotifier, :class_name => "User", :foreign_key => "quotifier_user_id"
  has_many :quote_witness_users
  has_many :witnesses, :through => :quote_witness_users
  has_many :quote_images
  validates_presence_of :quotifier, :speaker, :quote_text
  validates_associated :quotifier, :speaker
  before_create :set_slug

  def set_slug
    #Generate a unique, but short, string to uniquely identify.  May need to try again if first time has a collission
    possible_slug = Base64.encode64(UUIDTools::UUID.random_create)[0..6] 
    until Quote.where('slug=?', possible_slug).empty?
      possible_slug = Base64.encode64(UUIDTools::UUID.random_create)[0..6] 
    end
    self.slug = possible_slug
  end
   
end
