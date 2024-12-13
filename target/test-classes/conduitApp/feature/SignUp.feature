
Feature: Sign up New User
Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail() 
    * def jsFunction = 
    """
        function () {
            var DataGenerator = Java.type('helpers.DataGenerator')
            var generator = new DataGenerator()
            return generator.getRandomUsername()
        }
    """
    * def randomUserName = call jsFunction
    Given url apiUrl

Scenario: New User Signup
    Given path 'users'
    And request
    """
        {
         "user": 
                {
                "email": #(randomEmail),
                 "password": "sureshbritto132",
                 "username": #(randomUserName)
                }
        }
    """    
    When method Post
    Then status 201
    And match response ==
    """
    {
        "user":{
            "id":'#number',
            "email":#(randomEmail),
            "username":#(randomUserName),
            "bio":null,
            "image":'#string',
            "token":'#string'
              }
    }

    """
    
    


Scenario Outline: New User SignUp Error Scenarios
  
    Given path 'users'
    And request
    """
        {
         "user": 
                {
                "email": <email>,
                 "password": "sureshbritto132",
                 "username": <username>
                }
        }
    """    
    When method Post
    Then status 422
    And match response == <errorResponse>
    
    Examples:
        |email                   |password       |username            |errorResponse                                     |
        |#(randomEmail)          |sureshbritto132|sureshconduitacadmy2|{"errors":{"username":["has already been taken"]}}|
        |SureshConduit19@test.com|sureshbritto132|#(randomUserName)   |{"errors":{"email":["has already been taken"]}}   |
    