import { UserPageComponentStyle } from '../common/constants/UserPageConstants'
import {BasicUserInfoComponent} from './UserPage/BasicUserInfoComponent'
import {UserNewsCollectionComponent} from './UserPage/UserNewsCollectionComponent'

@Component
struct UserPageComponent{
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