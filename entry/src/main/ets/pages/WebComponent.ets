// xxx.ets
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
struct WebComponent {
    url: string = "";
    controller: webview.WebviewController = new webview.WebviewController();

    build() {
        Web({ src: this.url.replace("https://", ""), controller: this.controller, renderMode: RenderMode.SYNC_RENDER })
            .domStorageAccess(true)
            .mixedMode(MixedMode.All)
            .cacheMode(CacheMode.Default)
            .databaseAccess(true)
            .fileAccess(true)
            .imageAccess(true)
            .onlineImageAccess(true)
            .overviewModeAccess(false)
            .javaScriptAccess(true)
            .metaViewport(true)
    }

    aboutToAppear() {
        webview.WebviewController.setWebDebuggingAccess(true);
    }
}


export { WebComponent }
