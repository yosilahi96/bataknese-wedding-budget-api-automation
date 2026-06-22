Given("the API base url is configured") do
  self.api_client = ApiAutomation::ApiClient.new(base_url: configured_base_url)
end

Given("the request body is:") do |body|
  self.request_body = JSON.parse(body)
end

Given("the request body is loaded from {string}") do |file_name|
  self.request_body = request_body_from_file(file_name)
end

When("I send a {string} request to {string}") do |method, path|
  self.last_response = api_client.request(method, path, body: request_body)
end

Then("the response status should be {int}") do |expected_status|
  expect(last_response.code).to eq(expected_status)
end

Then("the response body should contain {string}") do |field_path|
  expect(value_at_path(parsed_response_body, field_path)).not_to be_nil
end

Then("the response body should contain {string} with value {string}") do |field_path, expected_value|
  expect(value_at_path(parsed_response_body, field_path)).to eq(expected_value)
end

Then("the response body should contain {string} with value {int}") do |field_path, expected_value|
  expect(value_at_path(parsed_response_body, field_path)).to eq(expected_value)
end

Then("the response body should match the schema:") do |table|
  table.hashes.each do |field|
    field_path = field.fetch("field")
    expected_type = field.fetch("type").downcase
    actual_value = value_at_path(parsed_response_body, field_path)

    valid_type = case expected_type
                 when "string" then actual_value.is_a?(String)
                 when "integer" then actual_value.is_a?(Integer)
                 when "number" then actual_value.is_a?(Numeric)
                 when "boolean" then [true, false].include?(actual_value)
                 when "object" then actual_value.is_a?(Hash)
                 when "array" then actual_value.is_a?(Array)
                 when "null" then actual_value.nil?
                 else
                   raise ArgumentError, "Unsupported schema type: #{expected_type}"
                 end

    expect(valid_type).to be(true),
      "Expected '#{field_path}' to be #{expected_type}, but got #{actual_value.class}"
  end
end
