import {Observable} from 'rxjs';
import {Injectable, InjectionToken} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {StatDAO} from '../interface/StatDAO';
import {Stat} from '../../model/Model';
import {HttpMethod, Operation} from "../../../../oauth2/model/RequestBFF";
import {environment} from "../../../../../environments/environment";


@Injectable({
    providedIn: 'root'
})

// класс не реализовывает и не наследует, т.к. у него только 1 метод
export class StatService implements StatDAO {

    constructor(
        private http: HttpClient // для выполнения HTTP запросов
    ) {
    }


    // общая статистика
    getOverallStat(email: string): Observable<Stat> {
        const operation = new Operation();
        operation.action = '/'; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
        operation.uri = "/stat";
        operation.body = email
        operation.httpMethod = HttpMethod.POST;
        return this.http.post<Stat>(environment.bffURL + '/planner-operation', operation);
    }


}
