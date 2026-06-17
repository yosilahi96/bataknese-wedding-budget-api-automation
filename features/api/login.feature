@login
Feature: Login API
  Scenario: Login with valid credentials
    Given the API base url is configured
    When I login through the API
    Then the login response should be successful
