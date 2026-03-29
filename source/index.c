#include <switch.h>

int main(int argc, char *argv[]) {
    WebCommonConfig config;
    WebCommonReply reply;

    Result rc = webOfflineCreate(&config, WebDocumentKind_OfflineHtmlPage, 0, ".htdocs/index.html");

    if (R_SUCCEEDED(rc)) {
        webConfigSetBootAsMediaPlayer(&config, true);
        webConfigSetMediaPlayerAutoClose(&config, true);
        webConfigSetMediaPlayerUi(&config, true);
        webConfigShow(&config, &reply);
    }

    return 0;
}