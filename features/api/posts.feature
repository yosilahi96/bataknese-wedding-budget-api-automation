@api
Feature: Posts API
  As an automation engineer
  I want to validate API behavior using Gherkin scenarios
  So that each scenario is readable and mapped to Ruby steps

  Scenario: Get an existing post
    Given the API base url is configured
    When I send a GET request to "/posts/1"
    Then the response status should be 200
    And the response body should contain "id" with value 1
    And the response body should contain "title"

  Scenario: Create a post
    Given the API base url is configured
    When I create a post
    Then the response status should be 201
    And the response body should contain "title" with value
