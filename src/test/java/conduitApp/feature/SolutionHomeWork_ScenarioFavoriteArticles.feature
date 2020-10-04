@homework
Feature: Development Home Work One

  Background: Preconditions
    * url apiURL
    * def timeValidator = read('classpath:helpers/timeValidator.js')

  Scenario: Favorite articles

    # Step 1: Get atricles of the global feed
    Given params {limit:10,offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And print response.articles[0]

    # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
    And def v_slug = response.articles[0].slug
    And print v_slug
    And def v_favoritesCount = response.articles[0].favoritesCount
    And print v_favoritesCount

    # Step 3: Make POST request to increse favorites count for the first article
    Given path 'articles',v_slug,'favorite'
    And request "{}"
    When method Post
    Then status 200
    And print response

    # Step 4: Verify response schema
    And match response ==
      """
       {
        "article": {
          "tagList": [],
          "createdAt": "#? timeValidator(_)",
          "author": {
            "image": "#string",
            "following": "#boolean",
            "bio": "##string",
            "username": "#string"
          },
          "description": "#string",
          "title": "#string",
          "body": "#string",
          "favoritesCount": "#number",
          "slug": "#string",
          "updatedAt": "#? timeValidator(_)",
          "favorited": "#boolean"
        }
      }
      """

    # Step 5: Verify that favorites article incremented by 1
    Given path 'articles',v_slug
    When method Get
    Then status 200
    And print response
    And print response.article.favoritesCount
    #And def v_username = response.article.author.username
    * match response.article.favoritesCount == v_favoritesCount + 1


    # Step 6: Get all favorite articles
    Given param favorited = "karate One"
    Given params {limit:10,offset:0}
    And path 'articles'
    When method Get
    Then status 200
    And print response

    # Step 7: Verify response schema
    And match each response.articles ==
    """
      {
        "tagList": [
        ],
        "createdAt": "#? timeValidator(_)",
        "author": {
          "image": "#string",
          "following": '#boolean',
          "bio": "##string",
          "username": "#string"
        },
        "description": "#string",
        "title": "#string",
        "body": "#string",
        "favoritesCount": '#number',
        "slug": "#string",
        "updatedAt": "#? timeValidator(_)",
        "favorited": '#boolean'
      }
    """

    # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
    And match response.articles[*].slug contains v_slug


    # Step 5.1: Verify that favorites article decrement  by 1
    Given path 'articles',v_slug
    When method Get
    Then status 200
    And def v_favoritesCount = response.article.favoritesCount
    And print v_favoritesCount

    Given path 'articles',v_slug,'favorite'
    And request "{}"
    When method Delete
    Then status 200
    And print response
    And print response.article.favoritesCount
    And def v_username = response.article.author.username
    And print v_username
    * match response.article.favoritesCount == v_favoritesCount - 1

