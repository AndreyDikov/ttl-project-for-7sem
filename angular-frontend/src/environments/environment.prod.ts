export const environment = {
  production: true,
  frontendURL: 'https://production-domain:4200', // ссылка на корневой URL фронтэнда
  kcClientID: 'todoapp-client', // из настроек KeyCloak
  kcBaseURL: 'https://production-domain:8443/realms/todoapp-realm/protocol/openid-connect',
  bffURL: 'https://production-domain:8902' // Сервер BFF - сюда angular приложение отправляет запросы, чтобы получить данные пользователя
};
