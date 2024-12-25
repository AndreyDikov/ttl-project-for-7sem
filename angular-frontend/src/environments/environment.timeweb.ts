export const environment = {
  production: true,
  frontendURL: 'https://2381209-gp84849.twc1.net:4200', // ссылка на корневой URL фронтэнда
  kcClientID: 'todoapp-client', // из настроек KeyCloak
  kcBaseURL: 'https://2381209-gp84849.twc1.net:8443/realms/todoapp-realm/protocol/openid-connect',
  bffURL: 'https://2381209-gp84849.twc1.net:8902' // Сервер BFF - сюда angular приложение отправляет запросы, чтобы получить данные пользователя
};
