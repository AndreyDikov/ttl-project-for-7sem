import {Observable} from 'rxjs';
import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';

import {CommonService} from './CommonService';
import {TaskDAO} from '../interface/TaskDAO';
import {TaskSearchValues} from '../../model/SearchObjects';
import {environment} from '../../../../../environments/environment';
import {Task} from '../../model/Model';
import {HttpMethod, Operation} from '../../../../oauth2/model/RequestBFF';

@Injectable({
    providedIn: 'root'
})

export class TaskService extends CommonService<Task> implements TaskDAO {

    constructor(
        private http: HttpClient // для выполнения HTTP запросов
    ) {
        super(http, "/task");
    }


    // поиск задач по любым параметрам
    findTasks(searchObj: TaskSearchValues): Observable<any> { // из backend получаем тип Page, поэтому указываем any
        const operation = new Operation();
        operation.action = '/search'; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
        operation.uri = "/task";
        operation.body = searchObj;
        operation.httpMethod = HttpMethod.POST;
        return this.http.post(environment.bffURL + '/planner-operation', operation);
    }


}
