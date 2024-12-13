@parallel=false
Feature: Test for homepage API's

Background: Define url
 Given url "https://conduit-api.bondaracademy.com/api/"
   
@suresh
Scenario: Get all tags
    Given path "tags"
    When method Get
    Then status 200
    And match response.tags contains  'Test'
    And match response.tags contains  ['Test','Git']
    And match response.tags !contains  'Rest'
    And match response.tags contains any ['suresh','Enroll','Britto']
    And match response.tags contains only ['Test','GitHub','Coding','Enroll','Git','Bondar Academy','qa career','Zoom','YouTube','Exam']
    And match response.tags == '#array'
    And match each response.tags[*] == '#string'
@parallel=false  
Scenario: Get articles of limit 10
    * def timeValidator = read('classpath:helpers/timevalidator.js')
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    When method Get
    Then status 200
    And match response.articles == '#[10]'
    And match response.articlesCount != 100
    And match response == {"articles":"#array","articlesCount": 16}
    And match response.articles[0].createdAt contains '2024'
    And match response.articles[*].favoritesCount contains 13
    And match response.articles[*].author.bio contains null
    And match response..bio contains null
    And match each response..following == false
    And match each response..following == '#boolean'
    And match each response..favoritesCount == '#number'
    And match each response..bio == '##string'
    And match each response.articles ==
    """
            {
                "slug": '#string',
                "title": '#string',
                "description": '#string',
                "body": '#string',
                "tagList": '#array',
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "favorited": '#boolean',
                "favoritesCount": '#number',
                "author": {
                    "username": '#string',
                    "bio": '##string',
                    "image": '#string',
                    "following": '#boolean'
                }
            }
    """


Scenario: Conditional Logic
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    When method Get
    Then status 200
    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]
   # * if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature',article)
   * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature',article).likesCount : favoritesCount 
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    When method Get
    Then status 200
    And match response.articles[0].favoritesCount == result


Scenario: Retry call
    * configure retry = { count:10, interval: 5000 }
    Given params { limit: 10, offset: 0 }   
    Given path "articles"
    And retry until response.articles[0].favoritesCount == 1
    When method Get
    Then status 200


Scenario: Sleep call
   * def sleep = function(pause){ java.lang.Thread.sleep(pause) } 
    Given params { limit: 10, offset: 0 }   
    Given path "articles"    
    When method Get
    * eval sleep(5000)
    Then status 200

Scenario: Number to String
    * def foo = 10
    * def Json = foo+''  
    * match Json == "10" 

@wip
Scenario: String to Number
    * def foo = '10'
    * def Json = foo*1 
    * match Json == 10
    * def foo1 = '10'
    * def Json1 = {"bar":#(parseInt(foo1))} 
    * match Json1 == {"bar": 10 } 