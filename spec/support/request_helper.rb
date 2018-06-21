# frozen_string_literal: true
module Rack
  # Define helper module for parsing response body
  class MockResponse
    def parsed_body
      JSON.parse(body)
    end
  end
end
