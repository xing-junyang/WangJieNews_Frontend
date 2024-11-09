import { ListStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility'
import { NewsItemComponent } from '../view/NewsItemComponent';
import { common } from '@kit.AbilityKit';
import DataBaseHelper from '../entryability/DataBaseHelper';
import { NoResource } from '../view/NoResourceComponent';

@Component
struct HistoryPage {
    @State newsData: NewsItem[] = []
    private context = getContext(this) as common.UIAbilityContext;

    build() {
        List() {
            if (this.newsData.length>0){
                ForEach(this.newsData, (item: NewsItem) => {
                    NewsItemComponent({ item: item })
                        .margin({ top: ListStyle.LIST_ITEM_MARGIN_TOP })
                });
            }else{
                NoResource()
            }
        }
        .width(ListStyle.LIST_WIDTH)
        .height(ListStyle.LIST_HEIGHT)
        .alignSelf(ItemAlign.Center)
        .alignListItem(ListItemAlign.Center)
    }

    aboutToAppear() {
        let dbh = new DataBaseHelper(this.context)
        dbh.createDataBase().then(() => {
            dbh.getCollectionFromDB("HISTORY").then((res)=>{
                this.newsData = res;
            })
        })
    }
}


export { HistoryPage }
