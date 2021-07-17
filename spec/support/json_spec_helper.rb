# spec/support/request_spec_helper
module JsonSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end
end