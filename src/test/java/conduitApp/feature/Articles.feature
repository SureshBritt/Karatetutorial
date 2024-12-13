
Feature: articles

Background: Define url
 * url apiUrl
 * def articlesRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
 * def dataGenerator = Java.type('helpers.DataGenerator')
 * set articlesRequestBody.article.title = dataGenerator.getRandomArticleValues().title
 * set articlesRequestBody.article.description = dataGenerator.getRandomArticleValues().description
 * set articlesRequestBody.article.body = dataGenerator.getRandomArticleValues().body


  Scenario: Create articles
    Given path 'articles'
    * print articlesRequestBody.article.title
    And request articlesRequestBody
    When method Post
    Then status 201
    And match response.article.title == articlesRequestBody.article.title

  
  Scenario: Create and delete the articles
    Given path 'articles'
    And request articlesRequestBody
    When method Post
    Then status 201
    And match response.article.title == articlesRequestBody.article.title
    * def articleID = response.article.slug

    
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    When method Get
    Then status 200
    And match response.articles[0].title == articlesRequestBody.article.title

    
    Given path "articles",articleID
    When method Delete
    Then status 204

    
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    When method Get
    Then status 200
    And match response.articles[0].title != articlesRequestBody.article.title




