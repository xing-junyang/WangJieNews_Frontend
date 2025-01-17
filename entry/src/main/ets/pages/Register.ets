import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import AuthService from '../entryability/AuthService';

@Entry
@Component
struct Register {

  @State activities: object[] = [];
  @State username: string = '';
  @State password: string = '';

  S_register() {
    let authService = new AuthService();
    if (this.username !== '' && this.password !== '') {
      authService.register(this.username, this.password)
        .then((success) => {
          if (success) {
            console.info('注册成功666');
            router.replaceUrl({
              url: "pages/Login",
              params: {
                activities: this.activities
              }
            });
            promptAction.showToast({
              message: "注册成功，跳转至登录页面",
            });//不起作用？
          } else {
            console.error('注册失败');
            promptAction.showToast({
              message: "注册失败",
            });//不起作用？
          }
        });
    }else {
      promptAction.showToast({
        message: "用户名或密码不能为空"
      });
    }
    // if (this.username !== '' && this.password !== '') {
    //   promptAction.showToast({
    //     message: "注册成功，跳转至登录页面",
    //   });
    //   router.replaceUrl({
    //     url: "pages/Login",
    //     params: {
    //       activities: this.activities
    //     }
    //   });
    // } else {
    //   promptAction.showToast({
    //     message: "用户名或密码不能为空"
    //   });
    // }
  }

  build() {
    Column({
      space: 30,
    }) {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Column({
          space: 20
        }) {
          Text("望界新闻注册")
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

          Button('注册')
            .width(300)
            .height(50)
            .fontSize(18)
            .backgroundColor('#0F40F5')
            .borderRadius(8)
            .onClick(() => {
              this.S_register();
            });

          // 空组件，调整布局
          Text("")
            .fontWeight(FontWeight.Bold)
            .margin({ top: '20%', bottom: '20%'});
        }
      }.backgroundColor('#EAF2FF')
      .width('100%')
      .height('100%')
      .padding({ top: 50, bottom: 50 })
      .borderRadius(16);
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
