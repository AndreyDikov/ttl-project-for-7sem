import {Observable} from 'rxjs';
import {HttpClient} from '@angular/common/http';
import {CommonDAO} from '../interface/CommonDAO';
import {environment} from '../../../../../environments/environment';
import {HttpMethod, Operation} from '../../../../oauth2/model/RequestBFF';


// базовые методы доступа к данным, одинаковые для всех классов,
// чтобы не нужно было дублировать весь этот код в каждом классе-сервисе

// JSON формируется автоматически для параметров и результатов

// благодаря DAO и единому интерфейсу - мы можем вынести общую реализацию в класс выше и избежать дублирования кода
// классу остается только реализовать свои специфичные методы доступа к данным

export class CommonService<T> implements CommonDAO<T> {

    private bffURL = environment.bffURL + '/planner-operation';

    constructor(
        private httpClient: HttpClient, // для выполнения HTTP запросов
        private uri: string // для выполнения HTTP запросов
    ) {
    }

    // основной смысл всех методов - просто вызвать BBF и передать туда параметры

    add(t: T): Observable<T> {
        const operation = new Operation();
        operation.action = '/add'; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
        operation.uri = this.uri;
        operation.body = t; // вложенный объект (конвертируется в JSON автоматически)
        operation.httpMethod = HttpMethod.POST; // у Resource Server должен быть именно такой тип метода
        return this.httpClient.post<T>(this.bffURL, operation); // единый адрес вызова BFF
    }

    delete(id: number): Observable<any> {
        const operation = new Operation();
        operation.action = '/delete/' + id;
        operation.uri = this.uri;
        operation.body = id;
        operation.httpMethod = HttpMethod.DELETE;
        return this.httpClient.post<T>(this.bffURL, operation);
    }

    findById(id: number): Observable<T> {
        const operation = new Operation();
        operation.action = '/id';
        operation.uri = this.uri;
        operation.body = id;
        operation.httpMethod = HttpMethod.POST;
        return this.httpClient.post<T>(this.bffURL, operation);
    }

    findAll(email: string): Observable<T[]> {
        const operation = new Operation();
        operation.action = '/all';
        operation.uri = this.uri;
        operation.body = email;
        operation.httpMethod = HttpMethod.POST;
        return this.httpClient.post<T[]>(this.bffURL, operation);
    }

    update(obj: T): Observable<any> {
        const operation = new Operation();
        operation.action = '/update';
        operation.uri = this.uri;
        operation.body = obj;
        operation.httpMethod = HttpMethod.PUT;
        return this.httpClient.post(this.bffURL, operation);
    }


}





