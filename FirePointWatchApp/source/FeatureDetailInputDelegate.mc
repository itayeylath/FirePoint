using Toybox.Lang;
using Toybox.WatchUi;

class FeatureDetailInputDelegate extends WatchUi.InputDelegate {

    var _detail as FeatureDetailView;

    function initialize(detail as FeatureDetailView) {
        InputDelegate.initialize();
        _detail = detail;
    }

    function onSelect() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onBack() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var coords = clickEvent.getCoordinates();
        if (coords == null || coords.size() < 2) {
            return false;
        }
        var x = coords[0] as Lang.Number;
        var y = coords[1] as Lang.Number;
        if (_detail.hitBackButton(x, y)) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }
        return false;
    }
}
