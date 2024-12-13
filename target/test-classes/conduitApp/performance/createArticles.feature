Feature: articles

Background: Define url
 * url apiUrl
 * def articlesRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
 * def dataGenerator = Java.type('helpers.DataGenerator')
 * set articlesRequestBody.article.title = __gatling.Title
 * set articlesRequestBody.article.description = __gatling.Description
 * set articlesRequestBody.article.body = dataGenerator.getRandomArticleValues().body
 
  Scenario: Create and delete the articles
    * configure headers = {"Authorization": #('Token ' + __gatling.token)}
    Given path 'articles'
    And request articlesRequestBody
    And header karate-name = 'Create Articles'
    When method Post
    Then status 201
    And match response.article.title == articlesRequestBody.article.title
    * def articleID = response.article.slug
   
    * karate.pause(5000)

    Given path "articles",articleID
    And header karate-name = 'Delete Articles'
    When method Delete
    Then status 204

    



