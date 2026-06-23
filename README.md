# API Automation Base

Ruby/Cucumber automation scaffold for API tests written in Gherkin, with Capybara/Selenium available for UI scenarios when needed.

## Setup

1. Install Ruby.
2. Install dependencies:

   ```powershell
   bundle install
   ```

3. Create your local environment file:

   ```powershell
   Copy-Item .env.example .env
   ```

4. Run all scenarios:

   ```powershell
   bundle exec cucumber
   ```

Run only API or UI tagged scenarios:

```powershell
bundle exec cucumber -p api
bundle exec cucumber -p ui
```

Run authenticated API scenarios:

```powershell
$env:RUBYLIB = "$PWD\support\ruby_overrides;$env:RUBYLIB"
bundle exec cucumber -p bearer
```

Authenticated scenarios log in automatically using `features/fixtures/request_bodies/login/valid_login.json`, so you do not need to store a bearer token in `.env`.

## Structure

- `features/*.feature`: Gherkin scenarios.
- `features/step_definitions/*_steps.rb`: Ruby step implementations.
- `features/support/env.rb`: test bootstrapping, env vars, Capybara config.
- `features/support/api_client.rb`: reusable HTTP API client.
- `features/support/world.rb`: shared scenario helper methods.

## Adding A New API Scenario

Create or update a `.feature` file:

```gherkin
@api
Scenario: Get a user by id
  Given the API base url is configured
  When I send a GET request to "/users/1"
  Then the response status should be 200
  And the response body should contain "id" with value 1
```

For scenarios that need a request body, keep the JSON in `features/fixtures/request_bodies` and load it from the features:

```gherkin
@api
Scenario: Create a post
  Given the API base url is configured
  And the request body is loaded from "posts/create_post.json"
  When I send a POST request to "/posts"
  Then the response status should be 201
```

For scenarios that need bearer authentication, log in during the scenario and use the API path directly in the feature:

```gherkin
@api @bearer_token @requires_bearer_token
Scenario: Access protected API using bearer token
  Given the API base url is configured
  And I am authenticated with valid login credentials
  When I send a "GET" request to "/api/projects"
  Then the response status should be 200
```

