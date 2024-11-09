@Component
struct NoResource {
    build() {
        Column({space: 30}) {
            Image($r('app.media.doc_text_badge_magnifyingglass'))
                .height("10%")
            Text($r("app.string.no_resource"))
                .fontWeight(600)
                .fontSize(18)
        }
        .height('100%')
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({top: '30%'})

    }
}

export { NoResource }