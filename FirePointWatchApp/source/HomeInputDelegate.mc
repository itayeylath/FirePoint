using Toybox.Lang;
using Toybox.WatchUi;

class HomeInputDelegate extends WatchUi.InputDelegate {

    var _home as HomeView;

    function initialize(home as HomeView) {
        InputDelegate.initialize();
        _home = home;
    }

    function onSelect() as Lang.Boolean {
        return false;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var coords = clickEvent.getCoordinates();
        if (coords == null || coords.size() < 2) {
            return false;
        }
        var x = coords[0] as Lang.Number;
        var y = coords[1] as Lang.Number;
        var idx = _home.hitButtonIndex(x, y);
        if (idx < 0) {
            return false;
        }
        var sub = _home.getSubtitleForIndex(idx);
        var detail = new FeatureDetailView(sub);
        WatchUi.pushView(detail, new FeatureDetailInputDelegate(detail), WatchUi.SLIDE_LEFT);
        return true;
    }
}
