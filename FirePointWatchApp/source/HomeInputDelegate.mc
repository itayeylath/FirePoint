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
        if (idx == 0) {
            var compass = new CompassView();
            WatchUi.pushView(compass, new CompassInputDelegate(compass), WatchUi.SLIDE_LEFT);
            return true;
        }
        if (idx == 1) {
            var pos = new PositionView();
            WatchUi.pushView(pos, new PositionInputDelegate(pos), WatchUi.SLIDE_LEFT);
            return true;
        }
        var sub = _home.getSubtitleForIndex(idx);
        var detail = new FeatureDetailView(sub);
        WatchUi.pushView(detail, new FeatureDetailInputDelegate(detail), WatchUi.SLIDE_LEFT);
        return true;
    }
}
