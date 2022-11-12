library figma_auto_layout;

import 'package:flutter/material.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

export 'package:signed_spacing_flex/signed_spacing_flex.dart'
    show StackingOrder;

enum FigmaSpacingMode {
  packed,
  spaceBetween,
}

enum FigmaSizingMode {
  fill,
  hug,
}

/// A replicate of Figma's auto layout feature that aligns its children vertically or horizontally
/// with positive or negative spacing.
class FigmaAutoLayout extends FigmaAutoLayoutChild {
  final List<FigmaAutoLayoutChild> children;

  final Axis direction;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final AlignmentDirectional alignment;
  final bool textBaselineAlignment;

  /// This overrides [spacing] when set to [FigmaSpacingMode.spaceBetween].
  final FigmaSpacingMode spacingMode;

  final StackingOrder canvasStacking;
  final bool clipContent;
  final TextDirection? textDirection;
  final TextBaseline textBaseline;

  const FigmaAutoLayout({
    super.key,
    this.children = const [],
    required this.direction,
    super.width,
    super.height,
    super.widthMode = FigmaSizingMode.hug,
    super.heightMode = FigmaSizingMode.hug,
    this.spacing = 0,
    this.padding = const EdgeInsets.all(0),
    this.alignment = AlignmentDirectional.topStart,
    this.textBaselineAlignment = false,
    this.spacingMode = FigmaSpacingMode.packed,
    this.canvasStacking = StackingOrder.lastOnTop,
    this.clipContent = false,
    this.textDirection,
    this.textBaseline = TextBaseline.alphabetic,
  }) : super(child: const SizedBox());

  TextDirection _getTextDirection(BuildContext context) {
    return textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;
  }

  MainAxisAlignment _calculateMainAxisAlignment() {
    MainAxisAlignment mainAxisAlignment;

    if (direction == Axis.horizontal) {
      if (alignment == AlignmentDirectional.bottomStart ||
          alignment == AlignmentDirectional.centerStart ||
          alignment == AlignmentDirectional.topStart) {
        mainAxisAlignment = MainAxisAlignment.start;
      } else if (alignment == AlignmentDirectional.bottomEnd ||
          alignment == AlignmentDirectional.centerEnd ||
          alignment == AlignmentDirectional.topEnd) {
        mainAxisAlignment = MainAxisAlignment.end;
      } else {
        mainAxisAlignment = MainAxisAlignment.center;
      }
      if (textDirection == TextDirection.rtl) {
        if (mainAxisAlignment == MainAxisAlignment.start) {
          mainAxisAlignment = MainAxisAlignment.end;
        } else if (mainAxisAlignment == MainAxisAlignment.end) {
          mainAxisAlignment = MainAxisAlignment.start;
        }
      }
    } else {
      if (alignment == AlignmentDirectional.topStart ||
          alignment == AlignmentDirectional.topCenter ||
          alignment == AlignmentDirectional.topEnd) {
        mainAxisAlignment = MainAxisAlignment.start;
      } else if (alignment == AlignmentDirectional.bottomStart ||
          alignment == AlignmentDirectional.bottomCenter ||
          alignment == AlignmentDirectional.bottomEnd) {
        mainAxisAlignment = MainAxisAlignment.end;
      } else {
        mainAxisAlignment = MainAxisAlignment.center;
      }
    }

    return mainAxisAlignment;
  }

  CrossAxisAlignment _calculateCrossAxisAlignment() {
    CrossAxisAlignment crossAxisAlignment;

    if (direction == Axis.horizontal) {
      if (textBaselineAlignment) {
        crossAxisAlignment = CrossAxisAlignment.baseline;
      } else {
        if (alignment == AlignmentDirectional.topStart ||
            alignment == AlignmentDirectional.topCenter ||
            alignment == AlignmentDirectional.topEnd) {
          crossAxisAlignment = CrossAxisAlignment.start;
        } else if (alignment == AlignmentDirectional.bottomStart ||
            alignment == AlignmentDirectional.bottomCenter ||
            alignment == AlignmentDirectional.bottomEnd) {
          crossAxisAlignment = CrossAxisAlignment.end;
        } else {
          crossAxisAlignment = CrossAxisAlignment.center;
        }
      }
    } else {
      if (alignment == AlignmentDirectional.bottomStart ||
          alignment == AlignmentDirectional.centerStart ||
          alignment == AlignmentDirectional.topStart) {
        crossAxisAlignment = CrossAxisAlignment.start;
      } else if (alignment == AlignmentDirectional.bottomEnd ||
          alignment == AlignmentDirectional.centerEnd ||
          alignment == AlignmentDirectional.topEnd) {
        crossAxisAlignment = CrossAxisAlignment.end;
      } else {
        crossAxisAlignment = CrossAxisAlignment.center;
      }
      if (textDirection == TextDirection.rtl) {
        if (crossAxisAlignment == CrossAxisAlignment.start) {
          crossAxisAlignment = CrossAxisAlignment.end;
        } else if (crossAxisAlignment == CrossAxisAlignment.end) {
          crossAxisAlignment = CrossAxisAlignment.start;
        }
      }
    }

    return crossAxisAlignment;
  }

  MainAxisSize _calculateMainAxisSize() {
    switch (direction) {
      case Axis.horizontal:
        if (widthMode == FigmaSizingMode.hug) {
          return MainAxisSize.min;
        }
        return MainAxisSize.max;
      case Axis.vertical:
        if (heightMode == FigmaSizingMode.hug) {
          return MainAxisSize.min;
        }
        return MainAxisSize.max;
    }
  }

  double? _calculateWidth() {
    if (width != null) {
      return width!;
    } else if (direction == Axis.vertical && widthMode != FigmaSizingMode.hug) {
      return double.infinity;
      // We only need to control one axis because the other one is controlled by the MainAxisSize.
    } else {
      return null;
    }
  }

  double? _calculateHeight() {
    if (height != null) {
      return height!;
    } else if (direction == Axis.horizontal &&
        heightMode != FigmaSizingMode.hug) {
      return double.infinity;
      // We only need to control one axis because the other one is controlled by the MainAxisSize.
    } else {
      return null;
    }
  }

  List<Widget> _buildChildren() {
    var newChildren = <Widget>[];

    FigmaAutoLayoutChild child;
    Widget newChild;

    for (int x = 0; x < children.length; x++) {
      child = children[x];
      newChild = child;

      if (!child.hasAbsolutePosition) {
        if (child.widthMode == FigmaSizingMode.fill &&
            child.heightMode == FigmaSizingMode.fill &&
            child.width == null &&
            child.height == null) {
          newChild = Expanded(child: SizedBox.expand(child: child));
        } else {
          switch (direction) {
            case Axis.horizontal:
              if (child.heightMode == FigmaSizingMode.fill &&
                  child.height == null) {
                newChild = SizedBox(height: double.infinity, child: child);
              } else if (child.widthMode == FigmaSizingMode.fill &&
                  child.width == null) {
                newChild = Expanded(child: child);
              }
              break;
            case Axis.vertical:
              if (child.widthMode == FigmaSizingMode.fill &&
                  child.width == null) {
                newChild = SizedBox(width: double.infinity, child: child);
              }
              if (child.heightMode == FigmaSizingMode.fill &&
                  child.height == null) {
                newChild = Expanded(child: child);
              }
              break;
          }
        }
        newChildren.add(newChild);
        if (spacingMode == FigmaSpacingMode.spaceBetween &&
            x != children.length - 1) {
          newChildren.add(const Spacer());
        }
      }
    }

    return newChildren;
  }

  List<Widget> _buildPositionedChildren(BuildContext context) {
    var newChildren = <Widget>[];

    for (final child in children) {
      if (child.hasAbsolutePosition) {
        newChildren.add(
          Positioned.directional(
            textDirection: _getTextDirection(context),
            start: child.start,
            top: child.top,
            end: child.end,
            bottom: child.bottom,
            child: child,
          ),
        );
      }
    }
    return newChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: clipContent ? Clip.hardEdge : Clip.none,
      children: [
        SizedBox(
          width: _calculateWidth(),
          height: _calculateHeight(),
          child: Padding(
            padding: padding,
            child: SignedSpacingFlex(
              direction: direction,
              spacing:
                  spacingMode == FigmaSpacingMode.spaceBetween ? 0.0 : spacing,
              stackingOrder: canvasStacking,
              textDirection: _getTextDirection(context),
              textBaseline: textBaseline,
              mainAxisAlignment: _calculateMainAxisAlignment(),
              mainAxisSize: _calculateMainAxisSize(),
              crossAxisAlignment: _calculateCrossAxisAlignment(),
              clipBehavior: clipContent ? Clip.hardEdge : Clip.none,
              children: _buildChildren(),
            ),
          ),
        ),
        ..._buildPositionedChildren(context),
      ],
    );
  }
}

class FigmaAutoLayoutChild extends StatelessWidget {
  final Widget child;

  /// This overrides [widthMode].
  final double? width;

  /// This overrides [heightMode].
  final double? height;

  final FigmaSizingMode widthMode;
  final FigmaSizingMode heightMode;
  final bool hasAbsolutePosition;
  final double? start;
  final double? top;
  final double? end;
  final double? bottom;

  const FigmaAutoLayoutChild({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.widthMode = FigmaSizingMode.hug,
    this.heightMode = FigmaSizingMode.hug,
  })  : hasAbsolutePosition = false,
        start = null,
        top = null,
        end = null,
        bottom = null;

  const FigmaAutoLayoutChild.absolutePosition({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.start,
    this.top,
    this.end,
    this.bottom,
  })  : hasAbsolutePosition = true,
        widthMode = FigmaSizingMode.hug,
        heightMode = FigmaSizingMode.hug;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
