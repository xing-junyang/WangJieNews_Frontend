
@Component
struct BasicUserInfoComponent{
    build() {
        Row() {
            Row({ space: 10 }) {
                Column({ space: 30 }) {
                    Image($r('app.media.person'))
                        .objectFit(ImageFit.Auto)
                        .aspectRatio(1)
                }
                .width('20%')
                .border({
                    color: Color.Black,
                    width: 2,
                    radius: "25%",
                    style: BorderStyle.Solid
                })

                Column({ space: 10 }) {
                    Text($r("app.string.user_name"))
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                    Text($r("app.string.vip_type_name"))
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                        .padding({
                            left: 8,
                            right: 8,
                            top: 4,
                            bottom: 4
                        })
                        .backgroundColor(Color.Orange)
                        .fontColor(Color.White)
                        .border({
                            style: BorderStyle.Solid,
                            color: Color.Orange,
                            radius: 10,
                            width: 2
                        })
                    Text($r("app.string.to_name"))
                        .fontSize(14)
                }
                .width('35%')
                .alignItems(HorizontalAlign.Start)

                Button($r("app.string.user_center"), { type: ButtonType.Normal, stateEffect: true })
                    .borderRadius(15)
                    .backgroundColor(Color.Black)
                    .height(30)
                    .fontWeight(FontWeight.Bold)
            }
            .width('90%')
        }
        .width('100%')
        .height('20%')
        .borderRadius('5%')
        .backgroundColor($r("app.color.grey_background_color"))
        .justifyContent(FlexAlign.Center)
    }
}

export {BasicUserInfoComponent}