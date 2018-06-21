# frozen_string_literal: true

module ApiHelper
  include Rack::Test::Methods

  def app
    RestApiTemplate::Application
  end
end
