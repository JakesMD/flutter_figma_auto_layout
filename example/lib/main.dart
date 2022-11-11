import 'package:figma_auto_layout/figma_auto_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FigmaAutoLayout Demo',
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),

            // "Card"
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff1D2570),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),

                // Content
                child: FigmaAutoLayout(
                  direction: Axis.vertical,
                  children: [
                    // Image
                    FigmaAutoLayoutChild(
                      height: 200,
                      child: Container(
                        color: Color(0xffEAECFF),
                      ),
                    ),

                    // Title, subtitle and avatars
                    FigmaAutoLayoutChild(
                      child: FigmaAutoLayout(
                        padding: EdgeInsets.all(16),
                        spacing: 12,
                        children: [
                          // Title and avatars
                          FigmaAutoLayoutChild(
                            child: FigmaAutoLayout(
                              direction: Axis.horizontal,
                              spacingMode: FigmaSpacingMode.spaceBetween,
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                // Title
                                FigmaAutoLayoutChild(
                                  child: Text(
                                    "Lorem Ipsum",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1D2570),
                                    ),
                                  ),
                                ),

                                // Avatars
                                FigmaAutoLayoutChild(
                                  child: FigmaAutoLayout(
                                    direction: Axis.horizontal,
                                    spacing: -8,
                                    canvasStacking: StackingOrder.lastOnTop,
                                    children: List.generate(
                                      4,
                                      (index) => FigmaAutoLayoutChild(
                                        width: 24,
                                        height: 24,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffEAECFF),
                                            border: Border.all(
                                              color: Color(0xff1D2570),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Subtitle
                          FigmaAutoLayoutChild(
                            child: Text(
                              "Lorem ipsum dolor sit amet consectetur.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff1D2570),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Favorite icon
                    FigmaAutoLayoutChild.absolutePosition(
                      top: 16,
                      end: 16,
                      child: Icon(
                        Icons.favorite,
                        color: Color(0xff1D2570),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
