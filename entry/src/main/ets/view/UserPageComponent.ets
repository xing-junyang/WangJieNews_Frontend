import { UserPageComponentStyle } from '../common/constants/UserPageConstants'
import {BasicUserInfoComponent} from './UserPage/BasicUserInfoComponent'
import {UserNewsCollectionComponent} from './UserPage/UserNewsCollectionComponent'
import { promptAction, router } from '@kit.ArkUI';

@Component
struct UserPageComponent{
    logout() {
        promptAction.showToast({
            message: "退出成功，跳转至登录页面",
        });
        router.replaceUrl({
            url: "pages/Login",
        });
    }

    build() {
        Column({ space: 40 }) {
            BasicUserInfoComponent()

            UserNewsCollectionComponent()

            Row() {
                Column({ space: 20 }) {
                    Row() {
                        Text($r("app.string.log_out"))
                            .fontWeight(FontWeight.Bold)
                    }
                }
                .width('90%')
                .margin(14)
                .onClick(() => {
                    this.logout();
                });
            }
            .width('100%')
            .borderRadius('5%')
            .backgroundColor($r("app.color.grey_background_color"))
        }
        .justifyContent(FlexAlign.Start)
        .width(UserPageComponentStyle.PAGE_WIDTH)
        .height(UserPageComponentStyle.PAGE_HEIGHT)
    }
}

export {UserPageComponent}