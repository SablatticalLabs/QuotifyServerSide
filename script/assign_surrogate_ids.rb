Quote.where("quotifier_quote_id is NULL").each{|q| q.update_attributes(quotifier_quote_id: Quote.get_unique_quote_id)}
Quote.where("speaker_quote_id is NULL").each{|q| q.update_attributes(speaker_quote_id: Quote.get_unique_quote_id)}
QuoteWitnessUser.where("witness_quote_id is NULL").each{|qwu| qwu.update_attributes(witness_quote_id: Quote.get_unique_quote_id)}
