package ru.javabegin.oauth2.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter

// полные данные профиля пользователя, для отображения в frontend
public class User {

    private String id;
    private String username;
    private String email;

    // можно добавлять любые поля, которые вам необходимы (из keycloak или другого Auth Server)

}
