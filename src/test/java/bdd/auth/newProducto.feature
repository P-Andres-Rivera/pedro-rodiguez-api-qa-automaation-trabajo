Feature: Registro de nuevos productos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url urlBase
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')

  Scenario Outline: CP01 - Registrar nuevo producto
    Given path 'api','v1','producto'
    And header Authorization = 'Bearer ' + tokenLogin
    And request requests.registerNewProduct
    When method post
    Then status 200
    * print response
    And match response.id == '#notnull'
    * def idProducto = response.id
    * print idProducto
    And match response == schemas.registerNewProductSchema
    And match response.codigo == requests.registerNewProduct.codigo
    * match requests.registerNewProduct.nombre == nombre
    And assert response.stock >= 0
    And assert response.precio > 0
    And assert response.id > 0
    And match response.created_at == '#regex ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{6}Z$'
    And match response.updated_at == '#regex ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{6}Z$'

    Examples:
      | read('classpath:resources/csv/auth/dataNewProduct.csv').slice(1,2) |