@ui
Feature: Sample UI smoke test
  Scenario: Open a website with Capybara and Selenium
    When I visit "https://example.com"
    Then the page should contain "Example Domain"
