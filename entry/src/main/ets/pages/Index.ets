import { UserPageComponent } from '../view/UserPageComponent';
import { NewsComponent } from '../view/NewsComponent';


@Entry
@Component
struct Index {

    build() {
        RelativeContainer() {
            Navigation(){
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
            .mode(NavigationMode.Auto)
            .height('100%')
            .hideTitleBar(true)
            .navBarWidth("35%")
        }
        .height('100%')
        .width('100%')
    }

}

