Feature: To test Inventory API

  Background: Setup the base path
    Given url 'http://localhost:3100/api'

  Scenario: To fetch all item in inventory
    Given path 'inventory'
    When method get
    Then status 200
    And print response
    And match response.data[0].name != null
    And assert response.data.length >=9
    And match each response.data == { id: '#string', name: '#string', price: '#string', image: '#string' }
    And match $.data[3].name == 'Garlic Mix'

  Scenario: To filter by id in inventory
    Given path 'inventory/filter'
    And param id = '3'
    When method get
    Then status 200
    #Create variable to store the data from external json file
    * def actualResponse = read("../JsonResponseThirdItem.json")
    And print response
    And match response == actualResponse
    And print "File content ===",actualResponse

  Scenario: To add new ID in inventory
    Given path 'inventory/add'
    * def body = read("../NewIdEntry.json")
    #And request {"id": "102","name": "Hawaiian","image": "hawaiian.png","price": "$14"}
    And request body
    And headers {Accept : 'application/json', Content-Type : 'application/json'}
    When method post
    And status 200
    And print "============="
    And print response

  Scenario: To add existing ID in inventory
    Given path 'inventory/add'
    * def body = read("../ExistingIdEntry.json")
    And request body
    #And request {"id": "10","name": "Hawaiian","image": "hawaiian.png","price": "$14"}
    And headers {Accept : 'application/json', Content-Type : 'application/json'}
    When method post
    And status 400
    And print "============="
    And print response

  Scenario: To add item with missing information in inventory
    Given path 'inventory/add'
    * def body = read("../MissingInformationEntry.json")
    And request body
    #And request {"name": "Hawaiian","image": "hawaiian.png","price": "$14"}
    And headers {Accept : 'application/json', Content-Type : 'application/json'}
    When method post
    * def missing_info_message = 'Not all requirements are met'
    And status 400
    And print "============="
    And print response
    And match response == missing_info_message

  Scenario: To Validate recent added item in inventory
    Given path 'inventory'
    When method get
    Then status 200
    #Create variable to store the data from external json file
    * def actualResponse = read("../NewIdEntry.json")
    * def getAddedID = actualResponse.id
    * def getAddedName = actualResponse.name
    * def getAddedImage = actualResponse.image
    * def getAddedPrice = actualResponse.price
    And print "the value of ID is-------------", getAddedID, getAddedName, getAddedImage, getAddedPrice
    #And print response
    #* def addedIdDetails = $response.data[?(@.id == getAddedID)]
    * def addedIdDetails = $response.data[?(@.id == '103')]
    And print addedIdDetails
    Then match addedIdDetails[0].name == getAddedName
    Then match addedIdDetails[0].image == getAddedImage
    Then match addedIdDetails[0].price == getAddedPrice
