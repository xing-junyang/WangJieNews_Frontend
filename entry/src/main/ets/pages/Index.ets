import { UserPageComponent } from '../view/UserPageComponent';
import { NewsComponent } from '../view/NewsComponent';


@Entry
@Component
struct Index {

    build() {
        RelativeContainer() {
            Tabs({ barPosition: BarPosition.End }) {
                TabContent() {
                    NewsComponent()
                }
                .tabBar({text: $r("app.string.main_page"), icon: $r("app.media.doc_plaintext")})

                TabContent() {
                    UserPageComponent()
                }
                .tabBar({text: $r("app.string.my_page"), icon: $r("app.media.person")})
            }.scrollable(false)
            .animationDuration(300)
        }
        .height('100%')
        .width('100%')
    }

}

