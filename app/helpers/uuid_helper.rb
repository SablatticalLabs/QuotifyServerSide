#This module changes the default ID of the model from a numeric to a 6-character unique text string.
module UuidHelper
  def set_uuid
    #Generate a unique, but short, string to uniquely identify.  May need to try again if first time has a collission
    possible_id = Base64.encode64(UUIDTools::UUID.random_create)[0..6] 
    until self.class.where('id=?', possible_id).empty?
      possible_id = Base64.encode64(UUIDTools::UUID.random_create)[0..6] 
    end
    self.id = possible_id
  end

end
