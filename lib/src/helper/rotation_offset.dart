import 'dart:math';
import 'dart:ui';

extension RotationOffset on Offset {
  /// transfor coordinate to different between coordinate  and canvas position
  ///
  /// @param [rotation]
  /// @param [offsetDif]
  /// @param [flipX]
  /// @param [flipY]
  ///
  ///
  /// @returns [Offset]
  Offset transformToDifferentCoordinateSystem(
      double rotation, double offsetDif, ({bool flipX, bool flipY}) flips) {
    return rotation == 0 || rotation == 180
        ? this
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? this +
                    Offset(
                      flips.flipX ? -offsetDif : offsetDif,
                      flips.flipY ? -offsetDif : offsetDif,
                    )
                : this -
                    Offset(
                      flips.flipX ? -offsetDif : offsetDif,
                      flips.flipY ? -offsetDif : offsetDif,
                    )
            : this;
  }
}
