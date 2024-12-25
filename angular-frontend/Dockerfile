
# наследуемся от родителя со всеми библиотеками и уже установленным angular cli
FROM javabegin1/angular-deps as build

# в этой папке уже находятся все скачанные библиотеки из родительского образа
WORKDIR /app/angular-todo

# для успешной компиляцции копируем все файлы проекта (кроме package.json - его уже копировали в родительском образе)
COPY ./src ./src
COPY ./angular.json ./
COPY ./karma.conf.js ./
COPY ./tsconfig.app.json ./
COPY tsconfig.json ./
COPY tsconfig.spec.json ./

# генерация js файлов, которые уже можно запускать в nginx и обращаться из браузера
RUN npm run build -- --configuration timeweb  --verbose


# запуск html/js файлов в nginx сервере (версия подойдет любая в данный момент последняя)
FROM --platform=linux/amd64 nginx

# все сгенерированные файлы копируем в веб папку сервера
COPY --from=build /app/angular-todo/dist/frontend-angular /usr/share/nginx/html

# удаляем станданртный файл и копируем свою настройку
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/
COPY ./src/assets/ssl /etc/nginx/certs
EXPOSE 4200
