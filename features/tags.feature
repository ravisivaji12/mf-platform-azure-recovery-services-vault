Feature: Enforce required tags on all resources

  Scenario: All resources must have "env" tag with value "Prod"
    Given I have resource that supports tags
    Then it must contain tags
    And its value must contain env
    And its value must be Prod

  Scenario: All resources must have "owner" tag with value "ABREG0"
    Given I have resource that supports tags
    Then it must contain tags
    And its value must contain owner
    And its value must be ABREG0

  Scenario: All resources must have "dept" tag with value "IT"
    Given I have resource that supports tags
    Then it must contain tags
    And its value must contain dept
    And its value must be IT
