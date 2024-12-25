package ru.javabegin.oauth2.backend.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import ru.javabegin.oauth2.backend.dto.Operation;

@RestController
public class PlannerController {

  private static final RestTemplate restTemplate = new RestTemplate(); // для выполнения веб запросов на KeyCloak

  @Value("${resourceserver.url}")
  private String resourceServer;


  // перенаправляет любой запрос из frontend на Resource Server и добавляет в него токен из кука
  @PostMapping("/planner-operation")
  public ResponseEntity<Object> data(@RequestBody Operation operation, @CookieValue("AT") String accessToken) {


    // заголовок авторизации с access token
    HttpHeaders headers = new HttpHeaders();
    headers.setBearerAuth(accessToken); // слово Bearer будет добавлено автоматически
    headers.setContentType(MediaType.APPLICATION_JSON); // чтобы передать searchValues в формате JSON

    // специальный контейнер для передачи объекта внутри запроса
    HttpEntity<Object> request = new HttpEntity<>(operation.getBody(), headers);

    String url = resourceServer + operation.getUri() + operation.getAction();

    // получение бизнес-данных пользователя (ответ обернется в DataResult)
    ResponseEntity<Object> response = restTemplate.exchange(url, operation.getHttpMethod(), request, Object.class);

    return response;
  }



}
