
# FROM gradle:8.4.0-jdk21 # для сравнения - можно не наследоваться от planner-deps, а использовать эту строку и увидеть, что каждый раз при сборке проекта будут скачиваться много jar файлов (занимает время)
FROM javabegin1/planner-deps

# все скачанные ранее файлы будут браться из папки кеша родительского образа
ENV GRADLE_USER_HOME /home/gradle/cache
WORKDIR /app/planner-todo
COPY src ./src
COPY build.gradle settings.gradle ./

# формируем jar файл из исходного кода
# печать логов в консоль тоже занимает время, поэтому когда убедились что все ок - убираем параметр stacktrace
RUN gradle clean bootJar -i --stacktrace

# открытие порта для внешних вызовов и запуск проекта
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/planner-todo/build/libs/planner-todo-0.0.1-SNAPSHOT.jar"]
