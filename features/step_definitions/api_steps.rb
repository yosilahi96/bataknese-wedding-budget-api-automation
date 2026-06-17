Given("the API base url is configured") do
  self.api_client = ApiAutomation::ApiClient.new(base_url: configured_base_url)
end

POST_REQUEST_BODIES = {
  create_post: {
    title: "automation base",
    body: "created from cucumber",
    userId: 1
  }
}.freeze

When("I send a GET request to {string}") do |path|
  self.last_response = api_client.get(path)
end

When("I create a post") do
  self.last_response = api_client.post("/posts", body: POST_REQUEST_BODIES.fetch(:create_post))
end

When("I send a DELETE request to {string}") do |path|
  self.last_response = api_client.delete(path)
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
