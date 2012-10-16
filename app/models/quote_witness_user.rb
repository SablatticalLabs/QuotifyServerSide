class QuoteWitnessUser < ActiveRecord::Base
  belongs_to :quote
  belongs_to :witness, :class_name => "User", :foreign_key => "user_id"
  before_create :set_witness_quote_ids

  def set_witness_quote_ids
    self.witness_quote_id = Quote.get_unique_quote_id
  end
end