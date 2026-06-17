LOGIN_REQUEST_BODIES = {
  valid_login: {
    email: "user@gmail.com",
    password: "user123456"
  }
}.freeze

When("I login through the API") do
  login_path = ENV.fetch("LOGIN_PATH", "/login")
  self.last_response = api_client.post(login_path, body: LOGIN_REQUEST_BODIES.fetch(:valid_login))
end

Then("the login response should be successful") do
  expected_status = ENV.fetch("LOGIN_SUCCESS_STATUS", "200").to_i
  expect(last_response.code).to eq(expected_status)
end
