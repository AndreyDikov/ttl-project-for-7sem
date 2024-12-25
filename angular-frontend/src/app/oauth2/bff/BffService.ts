import {Observable} from 'rxjs';
import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../../environments/environment';
import {User} from "../model/User";


// напоминание: все запросы отправляются не напрямую в ResourceServer, а в BFF (backend for frontend), который является адаптеров
// это нужно для безопасного хранения куков в браузере


@Injectable({
    providedIn: 'root'
})

// не наследуется, т.к. не нужны другие методы
export class BffService {



    constructor(
        private http: HttpClient
    ) {
    }


    // выход из системы
    logout(): Observable<any> { //
        // просто вызываем адрес и ничего не возвращаем
        return this.http.get(environment.bffURL + '/logoutAction');
    }



    // получаем новые токены с помощью старого Refresh Token (из кука)
    exchangeRefreshToken(): Observable<any> {
        return this.http.get(environment.bffURL + '/exchange');
    }


    // обмен code на токены, которые будут созданы в BFF и сохранены в server-side cookie  (согласно PKCE)
    // таким образом все последующие запросы от angular клиента к bff - будут содержать токены для авторизации (подробно эту работу обсуждали в отдельном курсе oauth2 и bff)
    exchangeCodeToTokens(code: string): Observable<any> {
        return this.http.post(environment.bffURL + '/token', code, {
            headers: {
                'Content-Type': 'application/json; charset=UTF-8' // обязательно нужно указывать
            }
        });
    }

    // запрос полных данных пользователя (профайл)
    requestUserProfile(): Observable<User> {

        return this.http.get<User>(environment.bffURL + '/profile');

    }

}
