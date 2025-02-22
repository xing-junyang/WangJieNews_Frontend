import { ListStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility';
import { NewsItemComponent } from './NewsItemComponent';
import DataBaseHelper from '../entryability/DataBaseHelper'
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function getNewsFromDBTask(): Promise<Array<NewsItem>> {
    return [];
}


@Component
struct NewsComponent {
    @State FeatureNews: Array<NewsItem> = [];
    @State TechnologyNews: Array<NewsItem> = [];
    @State GamesNews: Array<NewsItem> = [];
    @State HealthNews: Array<NewsItem> = [];
    @State WorldNews: Array<NewsItem> = [];
    @State SportsNews: Array<NewsItem> = [];
    @State FinancialNews: Array<NewsItem> = [];
    private context = getContext(this) as common.UIAbilityContext;

    build() {
            Tabs({ barPosition: BarPosition.Start }) {
                TabContent() {
                    List() {
                        ForEach(this.FeatureNews, (item: NewsItem) => {
                            NewsItemComponent({ item: item })
                                .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                        });
                    }
                    .width(ListStyle.LIST_WIDTH)
                    .height(ListStyle.LIST_HEIGHT)
                    .alignSelf(ItemAlign.Center)
                    .alignListItem(ListItemAlign.Center)
                }
                .tabBar($r("app.string.feature_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.TechnologyNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.tech_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.GamesNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.games_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.HealthNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.health_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.WorldNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.world_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.SportsNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.sports_news"))

                TabContent() {
                    Column() {
                        List() {
                            ForEach(this.FinancialNews, (item: NewsItem) => {
                                NewsItemComponent({ item: item })
                                    .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                            });
                        }
                        .width(ListStyle.LIST_WIDTH)
                        .height(ListStyle.LIST_HEIGHT)
                        .alignSelf(ItemAlign.Center)
                        .alignListItem(ListItemAlign.Center)
                    }
                }
                .tabBar($r("app.string.fin_news"))
            }.barMode(BarMode.Scrollable)

    }

    aboutToAppear(): void {
        this.classifyNewsAndWriteToArray();
        setTimeout(() => {
            this.classifyNewsAndWriteToArray();
        }, 3000); //3秒后重新刷新
    }



    classifyNewsAndWriteToArray() {
            let dbh = new DataBaseHelper(this.context)
            dbh.createDataBase().then(()=>{
                dbh.getNews().catch(()=>{
                    try {
                        promptAction.showToast({
                            message: $r('app.string.server_no_response'),
                            duration: 2000
                        });
                    } catch (error) {
                        console.error(`showToast error: ${error}`);
                    };
                });
                //在创建数据库之后立即拉取新闻数据
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("Feature").then((res) => {
                        this.FeatureNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("finance").then((res) => {
                        this.FinancialNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("Games").then((res) => {
                        this.GamesNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("Technology").then((res) => {
                        this.TechnologyNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("Health").then((res) => {
                        this.HealthNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("World").then((res) => {
                        this.WorldNews = res;
                    })
                })
                taskpool.execute(getNewsFromDBTask).then((ret) => {
                    dbh.getNewsFromDB("Sports").then((res) => {
                        this.SportsNews = res;
                    })
                })
            }).catch(
                (error: Error) => {
                    console.error("createDataBase Error!", error)
                }
            );
    }
}

export { NewsComponent }

function showToast(res: undefined, Resource: undefined) {
    throw new Error('Function not implemented.');
}
