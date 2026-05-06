import 'package:flutter/material.dart';

class BarnOwlBottomTab extends StatefulWidget {
  final double containerWidth;
  final double scaleToExpand;
  final int numOfTabs;
  final double borderRadius;
  final bool enabledDragFeature;
  final Function(int)? onSelectTab;
  final double? height;
  final Color? containerBackgroundColor;
  final Color? tabColor;
  final List<BoxShadow>? tabBoxShadow;
  final List<BoxShadow>? containerBoxShadow;
  final List<Widget>? tabWidgets;

  const BarnOwlBottomTab({
    super.key,
    required this.containerWidth,
    required this.numOfTabs,
    this.borderRadius = 100,
    this.enabledDragFeature = true,
    this.scaleToExpand = 1.2,
    this.onSelectTab,
    this.height,
    this.containerBackgroundColor = Colors.orange,
    this.tabColor = Colors.white70,
    this.containerBoxShadow,
    this.tabBoxShadow,
    this.tabWidgets,
  });

  @override
  State<BarnOwlBottomTab> createState() => _BarnBottomTabState();
}

class _BarnBottomTabState extends State<BarnOwlBottomTab> {
  int activeIndex = 0;
  double positionX = 0;
  bool isPressed = false;
  final List<double> centersOfEachTab = [];

  late final double tabBoxWidth =
      widget.containerWidth / widget.numOfTabs;

  late final double expandedBoxWidth =
      tabBoxWidth * widget.scaleToExpand;

  late final double maximumX =
      (widget.containerWidth - tabBoxWidth) / 2;

  late final double minimumX = -maximumX;

  @override
  void initState() {
    super.initState();
    _calculateCenterPoints();
  }

  void _calculateCenterPoints() {
    double start = -(widget.containerWidth / 2);

    for (int i = 0; i < widget.numOfTabs; i++) {
      final center = start + (tabBoxWidth / 2);
      centersOfEachTab.add(center);
      start += tabBoxWidth;
    }
  }

  void onDragStart(DragStartDetails _) {
    setState(() => isPressed = true);
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      positionX += details.delta.dx;
      positionX = positionX.clamp(minimumX, maximumX);
    });
  }

  void onDragEnd(DragEndDetails _) {
    final closest = centersOfEachTab.reduce(
          (a, b) =>
      (positionX - a).abs() < (positionX - b).abs() ? a : b,
    );

    final index = centersOfEachTab.indexOf(closest);

    widget.onSelectTab?.call(index);

    setState(() {
      activeIndex = index;
      positionX = closest;
      isPressed = false;
    });
  }

  double get animatedSize =>
      isPressed ? expandedBoxWidth : tabBoxWidth;

  void _onTapEachTab(int index) {
    widget.onSelectTab?.call(index);

    setState(() {
      activeIndex = index;
      positionX = centersOfEachTab[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? expandedBoxWidth,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildBackgroundTabs(),
            _buildAnimatedSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundTabs() {
    return Container(
      width: widget.containerWidth,
      decoration: BoxDecoration(
        color: widget.containerBackgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.containerBoxShadow,
      ),
      child: Row(
        children: List.generate(widget.numOfTabs, (index) {
          return GestureDetector(
            onTap: () => _onTapEachTab(index),
            child: SizedBox(
              width: tabBoxWidth,
              height: tabBoxWidth,
              child: widget.tabWidgets != null &&
                  widget.tabWidgets!.length > index
                  ? widget.tabWidgets![index]
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAnimatedSelector() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(positionX, 0, 0),
      child: GestureDetector(
        onHorizontalDragStart:
        widget.enabledDragFeature ? onDragStart : null,
        onHorizontalDragUpdate:
        widget.enabledDragFeature ? onDragUpdate : null,
        onHorizontalDragEnd:
        widget.enabledDragFeature ? onDragEnd : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: animatedSize,
          height: animatedSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.tabColor,
            borderRadius:
            BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.tabBoxShadow,
          ),
          child: widget.tabWidgets != null &&
              widget.tabWidgets!.isNotEmpty
              ? widget.tabWidgets![activeIndex]
              : null,
        ),
      ),
    );
  }
}