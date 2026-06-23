@api @bearer_token @requires_bearer_token
Feature: Project List
  Scenario: User able to access project list
    Given the API base url is configured
    And I am authenticated with valid login credentials
    When I send a "GET" request to "/api/projects"
    Then the response status should be 200
    And the response body should contain "projects.0.brideName" with value "Gaby"
    And the response body should match the schema:
      | field                   | type    |
      | projects.0.groomName    | string  |
      | projects.0.brideName    | string  |
      | projects.0.totalBudget  | string  |


