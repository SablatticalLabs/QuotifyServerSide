class QuoteImage < ActiveRecord::Base
  include UuidHelper  #Use 6-character string as ID
  before_create :set_uuid
  self.primary_key = 'id'

  belongs_to :quote
  attr_accessor :image_data   #Temporary store for image binary data until it is written to disk
  after_create :save_image_data
  validates_presence_of :name, :image_data
  
  def save_image_data
    directory = "public/quote_images"
    file_name =  self.id.to_s + "_" + SecureRandom.hex(4).to_s + "." + self.image_data.original_filename.split(".").last 
    path = File.join(directory, file_name)
    File.open(path, "wb") { |f| f.write(self.image_data.read) }
    self.update_attribute(:file_name, file_name)
  end
  
end
