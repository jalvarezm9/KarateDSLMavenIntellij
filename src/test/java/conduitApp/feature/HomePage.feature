
Feature: Prueba de la pagina principal

    Background: Definicion de URL
      Given url apiURL

    Scenario: Obtener todos los tags
      And path 'tags'
      When method get
      Then status 200
      And match response.tags contains ['test','dragons']
      And match response.tags !contains 'jcam'
      And match response.tags contains any ['fish','dog','SIDA']
      And match response.tags == "#array"
      And match each response.tags == "#string"


   Scenario: Obtener 10 articulos en la pagina
     * def timeValidator = read('classpath:helpers/timeValidator.js')

     Given params { limit:10,offset:0}
     And path 'articles'
     When method get
     Then status 200
     Then print response
     And match response.articles == '#[10]'
     And match response.articlesCount == 500
     And match response.articlesCount != 100
     And match response == { "articles":"#array","articlesCount":500}
     And match response.articles[0].createdAt contains '2020'
     And match response.articles[*].favoritesCount contains 1
     And match response.articles[*].author.bio contains null
     And match response..bio contains null
     And match each response.articles[*].author.following == false
     #esta es la respuesta a la busqueda por descripcion
     # And match each response.articles[*].title contains 'm'
     # And match each response..title contains 'm'
     And match each response.articles[*].author.following == '#boolean'
     And match each response..favoritesCount == '#number'
     # Para validar la existencia de datos string y null al mismo tiempo
     And match each response..bio == '##string'

     And match each response.articles ==
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "#array",
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                },
                "favorited": '#boolean',
                "favoritesCount": '#number'
            }
        """
