@api @login
Feature: Login API
  Scenario: Login with valid credentials
    Given the API base url is configured
    And the request body is loaded from "login/valid_login.json"
    When I send a "POST" request to "/api/auth/login"
    Then the response status should be 200
    And the response body should contain "user.name" with value "Yosua"
    And the response body should contain "user.isAdmin" with value false
    And the response body should match the schema:
      | field        | type    |
      | token        | string  |
      | user.id      | string  |
      | user.email   | string  |
      | user.name    | string  |
      | user.isAdmin | boolean |

  Scenario: Login with invalid credentials
    Given the API base url is configured
    And the request body is loaded from "login/invalid_login.json"
    When I send a "POST" request to "/api/auth/login"
    Then the response status should be 401

  Scenario Outline: Login with invalid HTTP method
    Given the API base url is configured
    And the request body is loaded from "login/valid_login.json"
    When I send a "<http_method>" request to "/api/auth/login"
    Then the response status should be 404
    Examples:
      | http_method | 
      | GET         | 
      | PUT         | 
      | DELETE      | 
      | PATCH       | 
