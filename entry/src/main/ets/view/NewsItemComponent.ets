import { ListStyle, NewsItemStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility';
import { WebComponent } from './WebComponent';

@Component
struct NewsItemComponent {
    @Prop item: NewsItem;

    likeNavigationMenuItem:NavigationMenuItem = {
        "value": "Like",
        "icon": "/resources/base/media/heart.svg",
        "action": () => {

        }
    }
    collectNavigationMenuItem:NavigationMenuItem = {
        "value": "Collect",
        "icon": "/resources/base/media/star.svg",
        "action": () => {

        }
    }

    build() {
        ListItem() {
                NavRouter() {
                    Column({ space: NewsItemStyle.SPACE_BETWEEN_TITLE_AND_DATE }) {
                        Text(this.item.title)
                            .fontSize(NewsItemStyle.TITLE_FONT_SIZE)
                            .fontWeight(FontWeight.Bold)
                            .textAlign(TextAlign.Start)
                        Row({ space: NewsItemStyle.SPACE_BETWEEN_DATE_AND_AUTHOR }) {
                            if (this.item.author !== "") {
                                Text(this.item.author)
                                    .fontSize(NewsItemStyle.DATE_AND_AUTHOR_FONT_SIZE)
                                    .fontColor($r('app.color.date_and_author_font_color'))
                            }
                            Text(this.item.date)
                                .fontSize(NewsItemStyle.DATE_AND_AUTHOR_FONT_SIZE)
                                .fontColor($r('app.color.date_and_author_font_color'))
                        }
                    }
                    .width(ListStyle.LIST_ITEM_WIDTH)
                    .borderRadius(ListStyle.LIST_ITEM_BORDER_RADIUS)
                    .padding(ListStyle.LIST_ITEM_PADDING)
                    .backgroundColor($r('app.color.grey_background_color'))
                    .alignItems(HorizontalAlign.Start)

                    NavDestination() {
                        Column() {
                            WebComponent({url: this.item.url})
                        }
                        .height("100%")
                        .width("100%")
                    }
                    .title(this.item.title)
                    .menus([this.likeNavigationMenuItem, this.collectNavigationMenuItem])
                }
                .mode(NavRouteMode.PUSH)
        }
    }
}

export { NewsItemComponent };
