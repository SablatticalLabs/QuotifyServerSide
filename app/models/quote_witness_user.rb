class QuoteWitnessUser < ActiveRecord::Base
  belongs_to :quote
  belongs_to :witness, :class_name => "User", :foreign_key => "user_id"
end