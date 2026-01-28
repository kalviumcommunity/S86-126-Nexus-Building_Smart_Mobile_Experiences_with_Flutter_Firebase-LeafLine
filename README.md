## LeafLine – Scrollable Views with ListView and GridView
# Project Overview

This task focuses on building smooth and efficient scrollable user interfaces in Flutter using ListView and GridView. The implementation demonstrates how Flutter handles large and dynamic data sets while maintaining performance and responsiveness across different screen sizes.

The screen combines a horizontal scrolling ListView and a grid-based layout using GridView, organized within a single scrollable page.

Scrollable Layout Design
ListView Implementation

A horizontal ListView.builder is used to display a scrollable list of cards.
The builder constructor ensures that only visible items are rendered, improving memory usage and performance.

ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: 5,
  itemBuilder: (context, index) {
    return Container(
      width: 140,
      margin: EdgeInsets.all(8),
      child: Center(child: Text('Card ${index + 1}')),
    );
  },
);

GridView Implementation

A GridView.builder is used to display items in a two-column grid layout.
The grid is embedded inside a SingleChildScrollView using shrinkWrap and disabled internal scrolling to avoid layout conflicts.

GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 6,
  itemBuilder: (context, index) {
    return Container(
      child: Center(child: Text('Tile ${index + 1}')),
    );
  },
);

Screenshots

![alt text](image-1.png)

![alt text](image-2.png)

Reflection
How do ListView and GridView improve UI efficiency?

ListView and GridView efficiently manage scrolling content by rendering only the widgets that are visible on screen. This reduces memory usage and improves scrolling performance, especially when dealing with large or dynamic data sets.

Why are builder constructors recommended for large data sets?

Builder constructors such as ListView.builder and GridView.builder create widgets lazily. This means widgets are built only when needed, which significantly improves performance and prevents unnecessary widget creation.

What are common performance pitfalls to avoid with scrolling views?

Common pitfalls include nesting multiple scrollable widgets without controlling physics, rendering large lists without builders, and failing to constrain scrollable widgets inside fixed-height containers. Proper use of builders, constraints, and scroll physics helps avoid these issues.

Running the Application
flutter pub get
flutter run

Submission Details

Commit message:

feat: implemented scrollable layouts using ListView and GridView


Pull request title:

[Sprint-2] Scrollable Views with ListView & GridView – TeamName


Pull request includes:

Summary of scrollable layout implementation

Screenshots from the README

Reflection on ListView and GridView usage