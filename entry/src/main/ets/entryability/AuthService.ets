import http from '@ohos.net.http';

// 定义服务器返回的数据结构
interface HttpResponseData {
  code: number;         // 响应状态码 (如: 200)
  message: string;      // 响应消息 (如: "登录成功")
}

interface BusinessError {
  code: number;         // 错误码
  message: string;      // 错误消息
}

export default class AuthService {
  private ipAddress: string = '192.168.3.20:8080'; // 替换为实际的服务器地址
  
  /**
   * 注册函数
   * @param username 用户名
   * @param password 密码
   * @returns Promise<boolean> 成功返回 true，失败返回 false
   */
  async register(account: string, password: string): Promise<boolean> {
    return new Promise((resolve) => {
      const httpRequest = http.createHttp();
      const url = `http://${this.ipAddress}/register`;
      const body = JSON.stringify({ account, password });
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: {
            account:account,
            password:password
          },
          connectTimeout: 5000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            const response: HttpResponseData = JSON.parse(data.result.toString());
            console.log(`${data.result}`);
            console.log(`${response}`);
            if (data.result === "true") {
              console.info('注册成功');
              resolve(true);
            } else {
              console.error(`注册失败: ${response.message}`);
              console.error(`${response.code}`);
              resolve(false);
            }
          } else {
            console.error(`HTTP 错误: ${JSON.stringify(err)}`);
            resolve(false);
          }
          httpRequest.off('headersReceive');
          httpRequest.destroy();
        }
      );
    });
  }

  /**
   * 登录函数
   * @param username 用户名
   * @param password 密码
   * @returns Promise<boolean> 成功返回 true，失败返回 false
   */
  async login(account: string, password: string): Promise<boolean> {
    return new Promise((resolve) => {
      const httpRequest = http.createHttp();
      const url = `http://${this.ipAddress}/login`;
      const body = JSON.stringify({ account, password });

      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: body,
          connectTimeout: 5000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            const response: HttpResponseData = JSON.parse(data.result.toString());
            if (data.result === "true") {
              console.info('登录成功');
              resolve(true);
            } else {
              console.error(`登录失败: ${response.message}`);
              resolve(false);
            }
          } else {
            console.error(`HTTP 错误: ${JSON.stringify(err)}`);
            resolve(false);
          }
          httpRequest.off('headersReceive');
          httpRequest.destroy();
        }
      );
    });
  }
}
