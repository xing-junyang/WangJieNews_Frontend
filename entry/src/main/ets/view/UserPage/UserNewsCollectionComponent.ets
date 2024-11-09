import { common } from '@kit.AbilityKit';
import { UserNewsCollectionComponentStyle } from '../../common/constants/UserPageConstants';
import DataBaseHelper from '../../entryability/DataBaseHelper';
import { NewsItem } from '../../entryability/EntryAbility';
import { HistoryPage } from '../../pages/HistoryPage';
import { MyCollectionPage } from '../../pages/MyCollectionPage';
import { MyLikesPage } from '../../pages/MyLikesPage';

@Component
struct UserNewsCollectionComponent{
    private context = getContext(this) as common.UIAbilityContext;

    ResourceToString(resource:Resource):string{
        return getContext(this).resourceManager.getStringSync(resource)
    }


    build() {
        Row() {
            Column({ space: UserNewsCollectionComponentStyle.COLUMN_SPACE }) {
                NavRouter() {
                    Row() {
                        Text($r("app.string.my_collection"))
                            .fontWeight(FontWeight.Bold)
                        Image($r('app.media.chevron_right'))
                            .height(UserNewsCollectionComponentStyle.ICON_HEIGHT)
                    }.width(UserNewsCollectionComponentStyle.EACH_ROW_WIDTH)
                    .justifyContent(FlexAlign.SpaceBetween)

                    NavDestination() {
                        Column() {
                            MyCollectionPage()
                        }
                        .height(UserNewsCollectionComponentStyle.NAV_DEST_HEIGHT)
                        .width(UserNewsCollectionComponentStyle.NAV_DEST_WIDTH)
                    }
                    .title(this.ResourceToString($r("app.string.my_collection")))
                }
                .mode(NavRouteMode.PUSH)

                NavRouter() {
                    Row() {
                        Text($r("app.string.my_history"))
                            .fontWeight(FontWeight.Bold)
                        Image($r('app.media.chevron_right'))
                            .height(UserNewsCollectionComponentStyle.ICON_HEIGHT)
                    }.width(UserNewsCollectionComponentStyle.EACH_ROW_WIDTH)
                    .justifyContent(FlexAlign.SpaceBetween)

                    NavDestination() {
                        Column() {
                            HistoryPage()
                        }
                        .height(UserNewsCollectionComponentStyle.NAV_DEST_HEIGHT)
                        .width(UserNewsCollectionComponentStyle.NAV_DEST_WIDTH)
                    }
                    .title(this.ResourceToString($r("app.string.my_history")))
                }
                .mode(NavRouteMode.PUSH)

                NavRouter() {
                    Row() {
                        Text($r("app.string.my_likes"))
                            .fontWeight(FontWeight.Bold)
                        Image($r('app.media.chevron_right'))
                            .height(UserNewsCollectionComponentStyle.ICON_HEIGHT)
                    }
                    .width(UserNewsCollectionComponentStyle.EACH_ROW_WIDTH)
                    .justifyContent(FlexAlign.SpaceBetween)

                    NavDestination() {
                        Column() {
                            MyLikesPage()
                        }
                        .height(UserNewsCollectionComponentStyle.NAV_DEST_HEIGHT)
                        .width(UserNewsCollectionComponentStyle.NAV_DEST_WIDTH)
                    }
                    .title(this.ResourceToString($r("app.string.my_likes")))
                }
                .mode(NavRouteMode.PUSH)


            }
            .width(UserNewsCollectionComponentStyle.COLUMN_WIDTH)
        }
        .width('100%')
        .height(UserNewsCollectionComponentStyle.COMPONENT_HEIGHT)
        .borderRadius(UserNewsCollectionComponentStyle.COMPONENT_BORDER_RADIUS)
        .padding(UserNewsCollectionComponentStyle.COMPONENT_PADDING)
        .backgroundColor($r("app.color.grey_background_color"))
        .justifyContent(FlexAlign.Center)
    }

}

export {UserNewsCollectionComponent}