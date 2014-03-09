window.onload = function () {

    var centerColumns = document.getElementsByClassName("centerColumn");
    if (centerColumns.length == 0)
        return

    for (var i = 0; i < centerColumns.length; i++) {
        var centerColumn = centerColumns[i];
        var parent = centerColumn.parentNode;
        var leftColumn = parent.getElementsByClassName("leftColumn")[0];
        var rightColumn = parent.getElementsByClassName("rightColumn")[0];

        var maxHeight = Math.max(
            centerColumn.scrollHeight,
            leftColumn == null ? 0 : leftColumn.scrollHeight,
            rightColumn == null ? 0 : rightColumn.scrollHeight
            );

        centerColumn.style.minHeight = maxHeight + "px";
        if (leftColumn != null) {
            leftColumn.style.minHeight = maxHeight + "px";
        }
        if (rightColumn != null) {
            rightColumn.style.minHeight = maxHeight + "px";
        }

    }
}