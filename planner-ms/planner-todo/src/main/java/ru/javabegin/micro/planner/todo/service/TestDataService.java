package ru.javabegin.micro.planner.todo.service;

import org.springframework.stereotype.Service;
import ru.javabegin.micro.planner.entity.Category;
import ru.javabegin.micro.planner.entity.Priority;
import ru.javabegin.micro.planner.entity.Stat;
import ru.javabegin.micro.planner.entity.Task;

import javax.transaction.Transactional;
import java.util.Calendar;
import java.util.Date;

@Service
public class TestDataService {

    private final TaskService taskService;
    private final PriorityService priorityService;
    private final CategoryService categoryService;
    private final StatService statService;

    // используем автоматическое внедрение экземпляра класса через конструктор
    // не используем @Autowired ля переменной класса, т.к. "Field injection is not recommended "
    public TestDataService(TaskService taskService, PriorityService priorityService, CategoryService categoryService, StatService statService) {
        this.taskService = taskService;
        this.priorityService = priorityService;
        this.categoryService = categoryService;
        this.statService = statService;
    }


    // добавляем любые тестовые данные для пользователя (внешний ключ по email)
    @Transactional
    public void initTestData(String email){

        // напоминание по БД: статистика (stat) создается в виде 1 строки (для каждого пользователя своя строка, связанная по email)
        // далее эта строка только обновляется, но не удаляется
        // если у пользователя нет строки stat - то считается что пользователь только был создан (еще нет тестовых данных)
        Stat stat = new Stat();
        stat.setEmail(email);
        statService.add(stat);

        // коды нужных цветов можно получить https://htmlcolorcodes.com/
        // цвет приоритета хранится в формате HEX
        Priority prior1 = new Priority();
        prior1.setColor("#607bc8");
        prior1.setTitle("Низкий");
        prior1.setEmail(email);

        Priority prior2 = new Priority();
        prior2.setColor("#5da378");
        prior2.setTitle("Средний");
        prior2.setEmail(email);


        Priority prior3 = new Priority();
        prior3.setColor("#f41b1b");
        prior3.setTitle("Высокий");
        prior3.setEmail(email);



        priorityService.add(prior1);
        priorityService.add(prior2);
        priorityService.add(prior3);


        Category cat1 = new Category();
        cat1.setTitle("Работа");
        cat1.setEmail(email);

        Category cat2 = new Category();
        cat2.setTitle("Семья");
        cat2.setEmail(email);

        Category cat3 = new Category();
        cat3.setTitle("Отдых");
        cat3.setEmail(email);

        categoryService.add(cat1);
        categoryService.add(cat2);
        categoryService.add(cat3);


        // сегодня
        Date today = new Date();

        // завтра
        Date tomorrow = new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(tomorrow);
        c.add(Calendar.DATE, 1);
        tomorrow = c.getTime();

        // неделя
        Date oneWeek = new Date();
        Calendar c2 = Calendar.getInstance();
        c2.setTime(oneWeek);
        c2.add(Calendar.DATE, 7);
        oneWeek = c2.getTime();

        Task task1 = new Task();
        task1.setTitle("Покушать");
        task1.setCategory(cat1);
        task1.setPriority(prior1);
        task1.setCompleted(1);
        task1.setTaskDate(tomorrow);
        task1.setEmail(email);

        Task task2 = new Task();
        task2.setTitle("Поспать 8 часов");
        task2.setCategory(cat2);
        task2.setCompleted(0);
        task2.setPriority(prior2);
        task2.setTaskDate(oneWeek);
        task2.setEmail(email);


        Task task3 = new Task();
        task3.setTitle("Посидеть на стуле");
        task3.setCategory(cat1);
        task3.setCompleted(0);
        task3.setPriority(prior3);
        task3.setTaskDate(today);
        task3.setEmail(email);

        Task task4 = new Task();
        task4.setTitle("Отправить отчет начальнику");
        task4.setCategory(cat1);
        task4.setCompleted(0);
        task4.setPriority(prior1);
        task4.setTaskDate(tomorrow);
        task4.setEmail(email);

        taskService.add(task1);
        taskService.add(task2);
        taskService.add(task3);
        taskService.add(task4);

    }


}
