package vector;

/**
 * Frame item
 */
enum FrameItem {
    Circle;
    Rect;
    Ellipse;
    Path;
}

/**
 * Frame node
 */
typedef FrameNode = {
    var items: Array<FrameItem>;
}