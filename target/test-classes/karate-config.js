function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {   
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'karateSuresh1234@test.com';
    config.userPassword = 'britto@1234';

  } else if (env == 'qa') {
    config.userEmail = 'karateSuresh1234@test.com';
    config.userPassword = 'britto@1234';
  }
  var acessToken = karate.callSingle('classpath:helpers/CreateToken.feature',config).authToken;
  karate.configure('headers',{Authorization: 'Token '+acessToken});
  return config;
}