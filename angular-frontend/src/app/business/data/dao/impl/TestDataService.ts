import {CommonService} from "./CommonService";
import {Task} from "../../model/Model";
import {TaskDAO} from "../interface/TaskDAO";
import {HttpClient} from "@angular/common/http";
import {HttpMethod, Operation} from "../../../../oauth2/model/RequestBFF";
import {TaskSearchValues} from "../../model/SearchObjects";
import {Observable} from "rxjs";
import {environment} from "../../../../../environments/environment";
import {Injectable} from "@angular/core";



@Injectable({
    providedIn: 'root'
})

export class TestDataService  {

    constructor(
        private http: HttpClient // для выполнения HTTP запросов
    ) {
    }


    // поиск задач по любым параметрам
    createTestData(email: string): Observable<any> { // из backend получаем тип Page, поэтому указываем any
        const operation = new Operation();
        operation.action = '/init'; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
        operation.uri = "/data";
        operation.body = email;
        operation.httpMethod = HttpMethod.POST;
        return this.http.post(environment.bffURL + '/planner-operation', operation);
    }


}
