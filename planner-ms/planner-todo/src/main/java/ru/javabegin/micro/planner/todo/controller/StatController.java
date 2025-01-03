package ru.javabegin.micro.planner.todo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.javabegin.micro.planner.entity.Stat;
import ru.javabegin.micro.planner.todo.service.StatService;
import ru.javabegin.micro.planner.todo.service.TestDataService;


/*

Чтобы дать меньше шансов для взлома (например, CSRF атак): POST/PUT запросы могут изменять/фильтровать закрытые данные, а GET запросы - для получения незащищенных данных
Т.е. GET-запросы не должны использоваться для изменения/получения секретных данных

Если возникнет exception - вернется код  500 Internal Server Error, поэтому не нужно все действия оборачивать в try-catch

Используем @RestController вместо обычного @Controller, чтобы все ответы сразу оборачивались в JSON,
иначе пришлось бы добавлять лишние объекты в код, использовать @ResponseBody для ответа, указывать тип отправки JSON

Названия методов могут быть любыми, главное не дублировать их имена и URL mapping

*/

@RestController
@RequestMapping("/stat") // базовый URI
public class StatController {

    private final StatService statService; // сервис для доступа к данным (напрямую к репозиториям не обращаемся)

    private final TestDataService testDataService; // сервис для создания тестовых данных (должен вызываться только 1 раз)


    // используем автоматическое внедрение экземпляра класса через конструктор
    // не используем @Autowired ля переменной класса, т.к. "Field injection is not recommended "
    public StatController(StatService statService, TestDataService testDataService) {
        this.testDataService = testDataService;
        this.statService = statService;
    }


    // для статистика всегда получаем только одну строку (связь 1 к 1)
    @PostMapping("/")
    public ResponseEntity<Stat> findByEmail(@RequestBody String email) {

        return ResponseEntity.ok(statService.findStat(email));
    }


}
