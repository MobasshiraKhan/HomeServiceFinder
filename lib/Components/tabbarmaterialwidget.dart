import 'package:flutter/material.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  TabBarMaterialWidget({
    Key? key,
    required this.index,
    required this.onChangedTab,
  }) : super(key: key);

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null),
    );

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: Icon(Icons.home),
          ),
          buildTabItem(
            index: 1,
            icon: Icon(Icons.mail_outline),
          ),
          placeholder,
          buildTabItem(
            index: 2,
            icon: Icon(Icons.calendar_month),
          ),
          buildTabItem(
            index: 3,
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? Colors.blue : Colors.black,
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => widget.onChangedTab(index),
      ),
    );
  }
}