Feature: Registro de usuario

Background:
  * url urlBase

  @registroSucess @exitoso
Scenario Outline: CP001 - Registro de usuario con datos válidos
  * def requests = read('classpath:resources/json/requests.json')
  * def schemas = read('classpath:resources/json/schemas.json')
  When path 'api','register'
  And request requests.registerUser
  When method post
  Then status 200
  * print response
  And match response == schemas.registerUserSchema
  * def token = response.access_token
  * assert password.length() >= 8
  * assert email.contains('@')

  Examples:
    | read('classpath:resources/csv/auth/dataRegister.csv') |

  @registroFail
Scenario Outline: CP002 - Registro de usuario con datos duplicados
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    When path 'api','register'
    And request requests.registerUser
    When method post
    Then status 500
    And match response == schemas.registerUserInvalidSchema
    * def emailErrors = response.email
    * match response.email == [ 'The email has already been taken.' ]
    * assert emailErrors[0].contains('email')

    Examples:
    |email|password|nombre|tipo_usuario_id|estado|
    |andresRi_karate@gmail.com|99865432|AndresRi|1|1|