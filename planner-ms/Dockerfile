# это специальный родительский образ для хранения библиотек для нужных проектов (чтобы они собиралисб быстрее и каждый раз не качали одни и те же jar файлы)
# этот образ НЕОБЯЗАТЕЛЬНО даже запускать как контейнер, он нам НЕ нужен в runtime (главное, чтобы образ находился в локальном хранилище или в docker hub - как удобней)

# Используем готовый образ с готовыми JDK и gradle на борту
# Чтобы было меньше проблем, желательно, чтобы в ваших проектах были такие же версии (иначе будут разные глюки)
# Это готовый образ сразу с JDK и Gradle на борту - не надо никаких отдельных ручных скачиваний
# Нужно не забыть выставить архитектуру процессора хостинга (где будет размещен контейнер)
FROM --platform=linux/amd64 gradle:7.6.0-jdk19

# обязательно указываем свою собсвтенную папку, т.к. Volume папка по-умолчанию /home/gradle/.gradle может удаляться автоматически
ENV GRADLE_USER_HOME /home/gradle/cache

# установка корневого сертификат в JVM (все дочерние образы будут автоматичкески иметь этот сертификат "внутри" JVM)
WORKDIR /app/certs
# установка CA сертификата в JVM в качестве доверенного
#COPY docker/mount/ssl/ca.cer ./
COPY docker/mount/ssl/R3_ISRG_Root_X1_.cer ./
COPY docker/mount/ssl/ISRG_Root_X1_DST_Root_CA_X3_.cer ./
RUN export PATH="$PATH:$JAVA_HOME/conf/security" # чтобы скрипт keytool был доступен для вызова напрямую без указания абсолютного пути
RUN #keytool -cacerts -storepass changeit -noprompt -trustcacerts -importcert -v -alias ca -file /app/certs/ca.cer
RUN keytool -cacerts -storepass changeit -noprompt -trustcacerts -importcert -v -alias timeweb-ca1 -file /app/certs/ISRG_Root_X1_DST_Root_CA_X3_.cer
RUN keytool -cacerts -storepass changeit -noprompt -trustcacerts -importcert -v -alias timeweb-ca2 -file /app/certs/R3_ISRG_Root_X1_.cer

# параметр -v означает vervose - печать всей информации об операции keytool (чтобы понимать успешно завершилась или нет)
# документация https://docs.oracle.com/javase/10/tools/keytool.htm


# ниже скачиваем все нужные зависимости для всех проектов (поэтому образ может иметь большой объем, в данном случае около 1 Гб)
# библиотеки скачиваются согласно файлам build.gradle (какие-то из них будут качаться из интернета, а какие-то - наши локальные, utils и entity)
# параметр stacktrace можете убрать, когда все заработает (не будет лишних логов и подвисаний из-за этого)


# entity классы
WORKDIR /app/planner-entity
COPY planner-entity/build.gradle ./
COPY planner-entity/settings.gradle ./
COPY planner-entity/src ./src
RUN gradle publishToMavenLocal -i --stacktrace


# утилиты
WORKDIR /app/planner-utils
COPY planner-utils/build.gradle ./
COPY planner-utils/settings.gradle ./
COPY planner-utils/src ./src
RUN gradle publishToMavenLocal -i --stacktrace


# зависимости для ВСЕХ проектов: микросервисы, config, gateway, eureka и пр. (ВСЕ jar файлы), чтобы дочерние образы не качали их заново, а брали отсюда (из кеша)
WORKDIR /app/planner-deps
# в этот файл build.gradle нужно добавить dependencies из всех проектов (т.е. собираем все зависимости "в одну кучу")
COPY docker/mount/planner-deps/build.gradle ./
COPY docker/mount/planner-deps/settings.gradle ./
COPY docker/mount/planner-deps/src ./src
RUN gradle bootJar -i --stacktrace

# Можно запускать контейнер образа, чтобы проверять наличие нужных файлов (для удобства - вкладка files в docker desktop)
# Но для работы дочерних образов runtime контейнер не нужен, он только для проверки
CMD ["tail", "-f"]
# когда все проверите и заработает - можно закомментировать строку, чтобы контейнер просто так не "висел" (подробнее - см. самый первый комментарий вверху)

