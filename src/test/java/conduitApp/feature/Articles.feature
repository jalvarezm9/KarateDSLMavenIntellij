@debug
Feature: Articulos

    Background: Definicion de URL
      * url apiURL
      * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
      * def dataGenerator = Java.type('helpers.DataGenerator')

      * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
      * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
      * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

      #Given path 'users/login'
      #And request {"user": {"email": "karateone@outlook.com","password": "karate123"}}
      #When method Post
      #Then status 200
      #* def token = response.user.token

      #PONER_TODO_EL_LOGIN_COMO_UNA_VARIABLE_GLOBAL___estoParaAccderyTenerElTockenPregargadoAntesDeEjecutarLosEscenarios
      #* def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
      #* def token = tokenResponse.authToken
   @crearArticulo
   Scenario: Crear nuevo articulo
#      Given header Authorization = 'Token '+ token
      And path 'articles'
      #And request {"article": {"tagList": [],"title": "new article","description": "new article","body": "the article is very beautiful"}}
      And request articleRequestBody
      When method Post
      Then status 200
      #And match response.article.title == 'new article'
      And match response.article.title == articleRequestBody.article.title


    Scenario: Crear y eliminar articulo
  #    Given header Authorization = 'Token '+ token
      And path 'articles'
      #And request {"article": {"tagList": [],"title": "new article","description": "new article","body": "the article is very beautiful"}}
      And request articleRequestBody
      When method Post
      Then status 200
      * def elementDelete = response.article.slug

      Given params { limit:10,offset:0}
      And path 'articles'
      When method Get
      Then status 200
      #Then match response.articles[0].title == 'new article'
      Then match response.articles[0].title == articleRequestBody.article.title

#      Given header Authorization = 'Token '+ token
      And path 'articles',elementDelete
      When method Delete
      Then status 200

      Given params { limit:10,offset:0}
      And path 'articles'
      When method Get
      Then status 200
      #Then response.articles[0].title != 'new article'
      Then match response.articles[0].title != articleRequestBody.article.title

