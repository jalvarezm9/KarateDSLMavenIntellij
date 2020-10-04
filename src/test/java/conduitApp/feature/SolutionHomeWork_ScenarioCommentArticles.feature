@homework
Feature: Development Home Work Two

  Background: Preconditions
    * url apiURL
    * def timeValidator = read('classpath:helpers/timeValidator.js')

  Scenario: Comment articles

    # Step 1: Get atricles of the global feed
    Given params {limit:10,offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And print response.articles[0]

    # Step 2: Get the slug ID for the first arice, save it to variable
    And def v_slug = response.articles[0].slug
    And print v_slug

    # Step 3: Make a GET call to 'comments' end-point to get all comments
    Given path 'articles',v_slug,'comments'
    When method Get
    Then status 200
    Then print response

    # Step 4: Verify response schema
    And match each response.comments ==
    """
      {
        "createdAt": "#? timeValidator(_)",
        "author": {
          "image": "#string",
          "following": '#boolean',
          "bio": "##string",
          "username": "#string"
        },
        "id": '#number',
        "body": "#string",
        "updatedAt": "#? timeValidator(_)"
      }
    """

    # Step 5: Get the count of the comments array lentgh and save to variable
    And def v_articlesCount = response.comments.length
    And print v_articlesCount

    # Step 6: Make a POST request to publish a new comment.
    Given path 'articles',v_slug,'comments'
    And request {"comment":{"body":"school"}}
    When method Post
    Then status 200
    Then print response
    And def v_idComment = response.comment.id

    # Step 7: Verify response schema that should contain posted comment text
    And match response.comment.body == "school"

    # Step 8: Get the list of all comments for this article one more time
    Given path 'articles',v_slug,'comments'
    When method Get
    Then status 200
    Then print response

    # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
    And def v_articlesCount2 = response.comments.length
    And print v_articlesCount2
    * match v_articlesCount2 == v_articlesCount + 1

    # Step 10: Make a DELETE request to delete comment
    Given path 'articles',v_slug,'comments',v_idComment
    When method Delete
    Then status 200

    # Step 11: Get all comments again and verify number of comments decreased by 1
    Given path 'articles',v_slug,'comments'
    When method Get
    Then status 200
    Then print response

    And def v_articlesCount3 = response.comments.length
    And print v_articlesCount3
    * match v_articlesCount3 == v_articlesCount2 -1