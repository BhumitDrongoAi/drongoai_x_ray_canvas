/// Represents the active shape on the canvas.
///
/// An [ActiveShape] is used to determine which shape is currently being drawn
/// or manipulated on the canvas. It is used by the [CanvasController] to
/// determine which shape to draw or manipulate.
///
/// The available shapes are:
///
///  * [line]: A straight line.
///  * [rectangle]: A rectangle.
///  * [circle]: A circle.
///  * [ellipse]: An ellipse.
///  * [angle]: An angle.
enum ActiveShape {
  /// The default shape.
  none,

  /// A straight line.
  line,

  /// A rectangle.
  rectangle,

  /// A circle.
  circle,

  /// An ellipse.
  ellipse,

  /// An angle.
  angle,
}
