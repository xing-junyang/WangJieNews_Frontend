@Component
struct UserNewsCollectionComponent{
    build() {
        Row() {
            Column({ space: 20 }) {
                Row() {
                    Text($r("app.string.my_collection"))
                        .fontWeight(FontWeight.Bold)
                }

                Row() {
                    Text($r("app.string.my_history"))
                        .fontWeight(FontWeight.Bold)
                }

                Row() {
                    Text($r("app.string.my_likes"))
                        .fontWeight(FontWeight.Bold)
                }
            }
            .width('90%')
        }
        .width('100%')
        .height('20%')
        .borderRadius('5%')
        .backgroundColor($r("app.color.grey_background_color"))
        .justifyContent(FlexAlign.Center)
        .onAppear(()=>{

        })
    }

}

export {UserNewsCollectionComponent}