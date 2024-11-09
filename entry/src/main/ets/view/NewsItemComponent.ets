import { ListStyle, NewsItemStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility';
import { WebComponent } from '../pages/WebComponent';
import { common } from '@kit.AbilityKit';
import DataBaseHelper from '../entryability/DataBaseHelper';
import { promptAction } from '@kit.ArkUI';

class IconModifier implements AttributeModifier<MenuAttribute>{
    activatedPath: string = "";
    inactivatedPath: string = "";
    isActivated: boolean = false;

    constructor(activatedPath: string, inactivatedPath: string) {
        this.activatedPath = activatedPath;
        this.inactivatedPath = inactivatedPath;
    }

    applyNormalAttribute(instance: MenuAttribute): void {
        if(this.isActivated){

        }else{
            instance.customProperty("icon", this.inactivatedPath);
        }
    }
}

@Component
struct NewsItemComponent {
    @Prop item: NewsItem;
    @State isStarred: boolean = false;
    @State isLiked: boolean = false;
    @State likeIcon: string = this.isLiked ? "/resources/base/media/heart_fill.svg": "/resources/base/media/heart.svg"
    @State starIcon: string =  this.isStarred ? "/resources/base/media/star_fill.svg": "/resources/base/media/star.svg"
    @State likeModifier: IconModifier = new IconModifier("/resources/base/media/heart_fill.svg", "/resources/base/media/heart.svg");
    @State starModifier: IconModifier = new IconModifier("/resources/base/media/star_fill.svg", "/resources/base/media/heart.svg")

    private context = getContext(this) as common.UIAbilityContext;
    private dbh = new DataBaseHelper(this.context)

    showToast(res: Resource){
        try {
            promptAction.showToast({
                message: res,
                duration: 2000
            });
        } catch (error) {
            console.error(`showToast error: ${error}`);
        };
    }

    likeNavigationMenuItem: NavigationMenuItem = {
        "value": "Like",
        "icon": this.likeIcon,
        "action": () => {
            this.dbh.createDataBase().then(() => {
                this.dbh.getCollectionFromDBByName("LIKES", this.item.title).then((res) => {
                    if (res === false) {
                        this.dbh.addToCollection("LIKES", this.item).then(() => {
                            // 通知用户
                            this.showToast($r('app.string.added_to_like_list'))
                        }).catch(() => {
                            // 同样通知用户
                            this.showToast($r('app.string.error_adding_to_list'))
                        })
                    } else {
                        this.dbh.deleteFromCollection("LIKES", this.item).then(() => {
                            // 通知用户
                            this.showToast($r('app.string.removed_from_like_list'))
                        }).catch(() => {
                            // 同样通知用户
                            this.showToast($r('app.string.error_removing_from_list'))
                        })
                    }
                }).catch(() => {
                    // 通知用户
                    this.showToast($r('app.string.error'))
                })
            })
        }
    }
    collectNavigationMenuItem: NavigationMenuItem = {
        "value": "Collect",
        "icon": this.starIcon,
        "action": () => {
            this.dbh.createDataBase().then(() => {
                this.dbh.getCollectionFromDBByName("STARRED", this.item.title).then((res) => {
                    if (res === false) {
                        this.dbh.addToCollection("STARRED", this.item).then(() => {
                            // 通知用户
                            this.showToast($r('app.string.added_to_collection'))
                        }).catch(() => {
                            // 同样通知用户
                            this.showToast($r('app.string.error_adding_to_list'))
                        })
                    } else {
                        this.dbh.deleteFromCollection("STARRED", this.item).then(() => {
                            // 通知用户
                            this.showToast($r('app.string.removed_from_collection'))
                        }).catch(() => {
                            // 同样通知用户
                            this.showToast($r('app.string.error_removing_from_list'))
                        })
                    }
                }).catch(() => {
                    // 通知用户
                    this.showToast($r('app.string.error'))
                })
            })
        }
    }

    // 更新历史记录。如果 HISTORY 表中含有该项，先删除，再添加，这样可以保证它在尾部。如果没有，那么在表中直接添加。
    updateHistory() {
        this.dbh.createDataBase().then(() => {
            this.dbh.getCollectionFromDBByName("HISTORY", this.item.title).then((res) => {
                if (res === false) {
                    this.dbh.addToCollection("HISTORY", this.item).then(() => {
                    }).catch(() => {
                        // 同样通知用户
                        this.showToast($r('app.string.error'))
                    })
                } else {
                    this.dbh.deleteFromCollection("HISTORY", this.item).then(() => {
                        this.dbh.addToCollection("HISTORY", this.item).then(() => {
                        }).catch(() => {
                            // 同样通知用户
                            this.showToast($r('app.string.error'))
                        })
                    }).catch(() => {
                        // 同样通知用户
                        this.showToast($r('app.string.error'))
                    })
                }
            }).catch(() => {
                // 通知用户
                this.showToast($r('app.string.error'))
            })
        })
    }

    checkCollectionState(database: string): boolean{
        this.dbh.createDataBase().then(()=>{
            this.dbh.getCollectionFromDBByName(database, this.item.title).then((res)=>{
                return res;
            }).catch(()=>{
                this.showToast($r('app.string.error'))// 产生错误
            })
        });
        return false;
    }

    build() {
        ListItem() {
            NavRouter() {
                Row(){
                    if(this.item.content!==null&&this.item.content?.length>0){
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
                        .alignItems(HorizontalAlign.Start)
                        .width(NewsItemStyle.TITLE_WIDTH)

                        Image(this.item.content)
                            .width(NewsItemStyle.PICTURE_WIDTH)
                            .borderRadius(NewsItemStyle.PICTURE_BORDER_RADIUS)
                    }else{
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
                        .alignItems(HorizontalAlign.Start)
                        .width("100%")
                    }

                }
                .width(ListStyle.LIST_ITEM_WIDTH)
                .borderRadius(ListStyle.LIST_ITEM_BORDER_RADIUS)
                .padding(ListStyle.LIST_ITEM_PADDING)
                .backgroundColor($r('app.color.grey_background_color'))
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.SpaceBetween)


                NavDestination() {
                    Column() {
                        WebComponent({ url: this.item.url })
                            .onAppear(() => {
                                //更新历史记录
                                this.updateHistory()
                            })
                    }
                    .height("100%")
                    .width("100%")
                }
                .title(this.item.title)
                .menus([this.likeNavigationMenuItem, this.collectNavigationMenuItem])
                .onWillAppear(()=>{
                    this.isStarred = this.checkCollectionState('STARRED');
                    this.isLiked = this.checkCollectionState('LIKES')
                })
            }
            .mode(NavRouteMode.PUSH)
        }.onAppear(()=>{
            this.isStarred = this.checkCollectionState('STARRED');
            this.isLiked = this.checkCollectionState('LIKES')
        })
    }


}

export { NewsItemComponent };
