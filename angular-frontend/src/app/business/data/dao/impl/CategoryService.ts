import {Injectable, InjectionToken} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {CommonService} from './CommonService';
import {CategoryDAO} from '../interface/CategoryDAO';
import {CategorySearchValues} from '../../model/SearchObjects';
import {Observable} from 'rxjs';
import {environment} from '../../../../../environments/environment';
import {Category} from '../../model/Model';
import {HttpMethod, Operation} from '../../../../oauth2/model/RequestBFF';


@Injectable({
  providedIn: 'root'
})

export class CategoryService extends CommonService<Category> implements CategoryDAO {

  constructor(private http: HttpClient // для выполнения HTTP запросов

  ) {
    super(http, "/category");
  }

  // поиск по любым параметрам
  findCategories(categorySearchValues: CategorySearchValues): Observable<any> {
    const operation = new Operation();
    operation.action = "/search"; // это адрес, который BFF будет вызывать у Resource Server, добавляя к запросу access token
    operation.uri = "/category";
    operation.body = categorySearchValues;
    operation.httpMethod = HttpMethod.POST;
    return this.http.post(environment.bffURL + '/planner-operation', operation);
  }
}
