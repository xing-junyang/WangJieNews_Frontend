import { ListStyle } from '../common/constants/IndexConstants';
import { NewsItem } from '../entryability/EntryAbility'
import { NewsItemComponent } from '../view/NewsItemComponent';
import { common } from '@kit.AbilityKit';
import DataBaseHelper from '../entryability/DataBaseHelper';
import { NoResource } from '../view/NoResourceComponent';

@Component
struct MyLikesPage {
    @State newsData: NewsItem[] = []
    private context = getContext(this) as common.UIAbilityContext;
    dbh = new DataBaseHelper(this.context)

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
        .onAppear(()=>{
            this.aboutToAppear()
        })
    }

    aboutToAppear() {
        this.dbh.createDataBase().then(() => {
            this.dbh.getCollectionFromDB("LIKES").then((res)=>{
                this.newsData = res;
            })
        })
    }

}


export { MyLikesPage }
