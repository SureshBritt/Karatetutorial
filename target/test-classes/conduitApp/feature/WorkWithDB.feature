Feature: DB Connection
Background: connect to DB
    * def dbhandler = Java.type('helpers.Dbhandler')
Scenario: seed a data to db
    * eval dbhandler.addNewJobWithName("QA3")

Scenario: Get a data from DB
    * def level = dbhandler.getMinAndMaxLevelsForJob("publisher")
    * print level.minLvl 
    * print level.maxLvl 
     

