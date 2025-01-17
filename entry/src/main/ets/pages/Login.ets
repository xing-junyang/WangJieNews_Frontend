import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import DataBaseHelper from '../entryability/DataBaseHelper';
import AuthService from '../entryability/AuthService';
import { GlobalVar } from '../entryability/GlobalVar';

@Entry
@Component
struct Index {

  @State activities: object[] = [];
  @State username: string = '';
  @State password: string = '';

  S_login() {
    const authService = new AuthService();
    authService.login(this.username, this.password)
      .then((success) => {
        if (success) {
          console.info('登录成功');
          GlobalVar.getInstance().setUsername("用户 " + this.username)
          router.replaceUrl({
            url: "pages/Index",
            params: {
              activities: this.activities
            }
          });
        } else {
          console.error('登录失败');
          promptAction.showToast({
            message: "密码或用户名错误，请重新输入"
          });
        }
      });
    // if (this.username == "admin" && this.password == "admin") {
    //   router.replaceUrl({
    //     url: "pages/Index",
    //     params: {
    //       activities: this.activities
    //     }
    //   });
    // } else {
    //   promptAction.showToast({
    //     message: "密码或用户名错误，请重新输入"
    //   });
    // }
  }

  register(){
    router.replaceUrl({
      url: "pages/Register"
    });
  }

  build() {
    Column({
      space: 30,
    }) {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Column({
          space: 20
        }) {
          Text("望界新闻")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 20 });

          TextInput({
            placeholder: '请输入用户名',
          })
            .width(300)
            .height(50)
            .fontSize(18)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .padding(10)
            .onChange((value: string) => {
              this.username = value;
            });

          TextInput({
            placeholder: '请输入密码',
          })
            .width(300)
            .height(50)
            .fontSize(18)
            .type(InputType.Password)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .padding(10)
            .onChange((value: string) => {
              this.password = value;
            });

          Button('登录')
            .width(300)
            .height(50)
            .fontSize(18)
            .backgroundColor('#0F40F5')
            .borderRadius(8)
            .onClick(() => {
              this.S_login();
            });

          Button('注册')
            .width(300)
            .height(50)
            .fontSize(18)
            .backgroundColor('#0F40F5')
            .borderRadius(8)
            .onClick(() => {
              router.replaceUrl({
                url: "pages/Register",
              });
            });
        }
      }.backgroundColor('#EAF2FF')
      .padding({ top: 50, bottom: 50 })
      .borderRadius(16);
    }
  }
}
