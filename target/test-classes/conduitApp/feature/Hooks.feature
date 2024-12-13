

Feature: Hooks demo

Background: Before Hook
    * print "Before Hook--for before feature use callOnce and for before scenario callread"

Scenario: First Scenario
    * print "This is First scenario"
    * configure afterFeature = function() {  karate.call('classpath:feature/AfterFeature.feature')}
    * configure afterScenario = function() {  karate.log("After hook scenario");}
   
    
Scenario: Second scenario
    * print "This is second scenario"
    
    

