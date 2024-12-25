import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {CommonService} from './CommonService';
import {PriorityDAO} from '../interface/PriorityDAO';
import {CategorySearchValues} from '../../model/SearchObjects';
import {Observable} from 'rxjs';
import {environment} from '../../../../../environments/environment';
import {Priority} from '../../model/Model';
import {HttpMethod, Operation} from '../../../../oauth2/model/RequestBFF';

@Injectable({
    providedIn: 'root'
})

export class PriorityService extends CommonService<Priority> implements PriorityDAO {

    constructor(private http: HttpClient // для выполнения HTTP запросов
    ) {
        super(http, "/priority");
    }

  // поиск по любым параметрам
  findPriorities(categorySearchValues: CategorySearchValues): Observable<any> {
      const operation = new Operation();
      operation.action = '/search'; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
      operation.uri = "/priority";
      operation.body = categorySearchValues;
      operation.httpMethod = HttpMethod.POST;
      return this.http.post(environment.bffURL + '/planner-operation', operation);
    }

}
