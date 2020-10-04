
Feature: Sign Up new user

  Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    Given url apiURL

  Scenario: New user Sign Up
    #Given def userData = {"email":"karateone2@outlook.com","username":"karate1111"}

    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUserName = dataGenerator.getRandomUserName()

    Given path 'users'
    And request
    """
        {
            "user": {
                "email": #(randomEmail),
                "password": "123Karate123",
                "username": #(randomUserName)
            }
        }
    """
    When method Post
    Then status 200
    Then match response ==
    """
       {
          "user": {
              "id": "#number",
              "email": #(randomEmail),
              "createdAt": "#? timeValidator(_)",
              "updatedAt": "#? timeValidator(_)",
              "username": #(randomUserName),
              "bio": null,
              "image": null,
              "token": "#string"
          }
      }
    """

  Scenario Outline: Validate Sign up error message
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUserName = dataGenerator.getRandomUserName()

    Given path 'users'
    And request
      """
          {
              "user": {
                  "email": "<email>",
                  "password": "<password>",
                  "username": "<username>"
              }
          }
      """
    When method Post
    Then status 422
    Then match response == <errorResponse>

    Examples:
      | email                 | password     | username               | errorResponse                                                                      |
      | #(randomEmail)        | 123Karate123 | karate.one.999         | {"errors":{"username":["has already been taken"]}}                                 |
      | karateone999@test.com | 123Karate123 | #(randomUserName)      | {"errors":{"email":["has already been taken"]}}                                    |
      | KarateUser1           | Karate123    | #(randomUsername)      | {"errors":{"email":["is invalid"]}}                                                |
      | #(randomEmail)        | Karate123    | KarateUser123123123123 | {"errors":{"username":["is too long (maximum is 20 characters)"]}}                 |
      | #(randomEmail)        | Kar          | #(randomUsername)      | {"errors":{"password":["is too short (minimum is 8 characters)"]}}                 |
      |                       | Karate123    | #(randomUsername)      | {"errors":{"email":["can't be blank"]}}                                            |
      | #(randomEmail)        |              | #(randomUsername)      | {"errors":{"password":["can't be blank"]}}                                         |
      | #(randomEmail)        | Karate123    |                        | {"errors":{"username":["can't be blank","is too short (minimum is 1 character)"]}} |

