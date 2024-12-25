package ru.javabegin.micro.planner.todo.service;

import org.springframework.stereotype.Service;
import ru.javabegin.micro.planner.entity.Priority;
import ru.javabegin.micro.planner.entity.Stat;
import ru.javabegin.micro.planner.todo.repo.StatRepository;

import javax.transaction.Transactional;

// всегда нужно создавать отдельный класс Service для доступа к данным, даже если кажется,
// что мало методов или это все можно реализовать сразу в контроллере
// Такой подход полезен для будущих доработок и правильной архитектуры (особенно, если работаете с транзакциями)
@Service

// все методы класса должны выполниться без ошибки, чтобы транзакция завершилась
// если в методе возникнет исключение - все выполненные операции откатятся (Rollback)
@Transactional
public class StatService {

    private final StatRepository repository; // сервис имеет право обращаться к репозиторию (БД)

    public StatService(StatRepository repository) {
        this.repository = repository;
    }

    public Stat findStat(String email) {
        return repository.findByEmail(email);
    }

    public Stat add(Stat stat) {
        return repository.save(stat); // метод save обновляет или создает новый объект, если его не было
    }

}