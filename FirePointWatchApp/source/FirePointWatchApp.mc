using Toybox.Application;
using Toybox.WatchUi;

class FirePointWatchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var homeView = new HomeView();
        return [ homeView, new HomeInputDelegate(homeView) ];
    }
}
