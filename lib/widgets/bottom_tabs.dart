import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget{
  final int selectedTab;
  final Function(int) tabPressed;
  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _selectedTab = widget.selectedTab ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 30.0,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            selected: _selectedTab == 0 ? true : false,
            imagePath: "assets/images/tab_home.png",
            onPressed: () {
              widget.tabPressed(0);
            },
            //imagePath: Icons.label_important
          ),
          BottomTabBtn(
            imagePath: "assets/images/noti_img.png",
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
            imagePath:  "assets/images/tab_saved.png",
            selected: _selectedTab == 2 ? true : false,
            onPressed: () {
              widget.tabPressed(2);
            },
          ),
          BottomTabBtn(
            imagePath:  "assets/images/profile_img.png",
            selected: _selectedTab == 3 ? true : false,
            onPressed: () {
              widget.tabPressed(3);
            },
          ),
          BottomTabBtn(
            imagePath:  "assets/images/tab_logout.png",
            selected: _selectedTab == 4 ? true : false,
             /* StorageUtil.clear();
              Navigator.pushNamedAndRemoveUntil(
              context, 'welcome_screen', (Route<dynamic> route) => false);*/
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final Function onPressed;
  BottomTabBtn({this.imagePath, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    // TODO: implement build
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 13.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                  color: _selected ? Theme.of(context).accentColor : Colors.transparent,
                  width: 2.0,
                )
            )
        ),
        child: Image(
          image: AssetImage(
              imagePath ?? "assets/images/tab_home.png"
          ),
          width: 22.0,
          height: 22.0,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
    );
  }
}