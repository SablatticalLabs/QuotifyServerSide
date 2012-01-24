class QuoteImage < ActiveRecord::Base
  belongs_to :quote
  attr_accessor :image_data
  after_save :save_image_data
  
  def save_image_data
    directory = "c:/"
    name =  self.id.to_s + "." + self.image_data.original_filename.split(".").last 
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(self.image_data.read) }
  end
  
end
