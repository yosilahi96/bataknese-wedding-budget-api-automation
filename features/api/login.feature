@api @login
Feature: Login API
  Scenario Outline: Login with valid credentials
    Given the API base url is configured
    And the request body is loaded from "<request_body>"
    When I send a POST request to "/api/auth/login"
    Then the response status should be <status_code>
    Examples:
      | request_body                | status_code |
      | login/valid_login.json      | 200         |
      | login/invalid_login.json    | 401         |   
