package ru.javabegin.oauth2.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpMethod;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter

public class Operation {
  private String uri;
  private String action;
  private HttpMethod httpMethod;
  private Object body;

}



