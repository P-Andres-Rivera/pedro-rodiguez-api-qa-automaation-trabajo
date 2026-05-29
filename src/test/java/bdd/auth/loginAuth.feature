Feature: Login de usuario

  Background:
    * url urlBase

    @loginSuccess @token @exitoso
    Scenario Outline: CP001 - Login de usuario con datos válidos con da
        * def requests = read('classpath:resources/json/requests.json')
        * def schemas = read('classpath:resources/json/schemas.json')
        Given path 'api','login'
        And form field email = requests.loginUser.email
        And form field password = requests.loginUser.password
        When method post
        Then status 200
        * print response
        And match response == schemas.loginUserSchema
        * def token = response.access_token
        * assert token != null
        * assert response.user.email == requests.loginUser.email
        * match response.token_type == 'Bearer'
        * match response.message contains 'HiAndres'
        * def msg = 'Response time fue: ' + responseTime + 'ms - debe ser < 1000ms'
        * assert responseTime < 3000
        * karate.log(msg)

      Examples:
        | read('classpath:resources/csv/auth/dataRegister.csv') |

    @loginFail @exitoso
    Scenario Outline: CP002 - Login de usuario con datos inválidos
        * def requests = read('classpath:resources/json/requests.json')
        * def schemas = read('classpath:resources/json/schemas.json')
        * set requests.loginUser.email = ''
        * set requests.loginUser.password = ''
        Given path 'api','login'
        And form field email = requests.loginUser.email
        And form field password = requests.loginUser.password
        When method post
        Then status 401
        * print response
        * match response.message == 'Datos incorrectos'

      Examples:
        | read('classpath:resources/csv/auth/dataRegister.csv') |


