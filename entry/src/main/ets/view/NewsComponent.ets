import { ListStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility';
import { NewsItemComponent } from './NewsItemComponent';
import DataBaseHelper from '../entryability/DataBaseHelper'
import { common } from '@kit.AbilityKit';

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
        Navigation() {
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
        .mode(NavigationMode.Stack)
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
                dbh.getNews(); //在创建数据库之后立即拉取新闻数据
                dbh.getNewsFromDB("Feature").then((res) => {
                    this.FeatureNews = res;
                })
                dbh.getNewsFromDB("finance").then((res) => {
                    this.FinancialNews = res;
                })
                dbh.getNewsFromDB("Games").then((res) => {
                    this.GamesNews = res;
                })
                dbh.getNewsFromDB("Technology").then((res) => {
                    this.TechnologyNews = res;
                })
                dbh.getNewsFromDB("Health").then((res) => {
                    this.HealthNews = res;
                })
                dbh.getNewsFromDB("World").then((res) => {
                    this.WorldNews = res;
                })
                dbh.getNewsFromDB("Sports").then((res) => {
                    this.SportsNews = res;
                })
                console.log("Feature News:", this.FeatureNews.toString());
            }).catch(
                (error: Error) => {
                    console.error("createDataBase Error!", error)
                }
            );
    }
}

export { NewsComponent }