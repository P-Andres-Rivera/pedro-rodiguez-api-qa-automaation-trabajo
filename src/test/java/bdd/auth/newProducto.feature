Feature: Registro de nuevos productos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAuth.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url urlBase
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    * header Authorization = 'Bearer ' + tokenLogin

  @registrarProducto @Succes
  Scenario Outline: CP01 - Registrar nuevo producto
    Given path 'api','v1','producto'
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
      | read('classpath:resources/csv/auth/dataNewProduct.csv').slice(0,1) |

    @registrarProducto @Invalid
  Scenario Outline: CP02 - Registar producto duplicado
    Given path 'api','v1','producto'
    #And header Authorization = 'Bearer ' + tokenLogin
    And request requests.registerNewProduct
    When method post
    Then status 500
    * print response
    And match response == schemas.registerNewProductDuplicateSchema
    And match response.error == '#regex .*Duplicate entry.*'
    And match response.error == '#regex .*1062.*'
    And match response.error == '#regex .*producto_codigo_unique.*'

    Examples:
      | read('classpath:resources/csv/auth/dataNewProduct.csv').slice(0,1) |

    @registrarProducto @InvalidToken
  Scenario Outline: CP03 - Registrar producto sin token
    Given path 'api','v1','producto'
    And header Authorization = 'Bearer 9999|tokeninvalidoperovieneconformato'
    And request requests.registerNewProduct
    When method post
    Then status 500
    * print 'BUG DETECTADO: Se esperaba 401 Unauthenticated pero se obtuvo 500 Server Error'
    And assert responseTime < 1000

    Examples:
      | read('classpath:resources/csv/auth/dataNewProduct.csv').slice(0,1) |

  Scenario Outline: CP04 - Registrar producto con payload incompleto
    * set requests.registerNewProduct.codigo = null
    Given path 'api','v1','producto'
    And request requests.registerNewProduct
    When method post
    Then status 500
    * print response
    * match response.codigo[0] == 'The codigo field is required.'


    Examples:
      | read('classpath:resources/csv/auth/dataNewProduct.csv').slice(3,4) |


