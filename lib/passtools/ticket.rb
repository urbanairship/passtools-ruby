=begin
  * GET /{ticketId}     retrieve the status of the specified ticket.
=end

module Passtools
  class Ticket
    extend Request
    attr_accessor :raw_data

    def self.show(ticket_id)
      get("/ticket/#{ticket_id}")
    end
  end
end
