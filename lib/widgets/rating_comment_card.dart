import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class RatingComment extends StatelessWidget {
  RatingComment(
      {this.username = '',
      this.comment = '',
      this.ratingPoint = 0,
      this.createAt = '',
      this.isAdmin,
      this.isCanDelete,
      this.onDelete});
  final String comment;
  final String username;
  final double ratingPoint;
  final String createAt;
  final bool isAdmin;
  final bool isCanDelete;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: isCanDelete
            ? <Widget>[
                IconSlideAction( 
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    onDelete();
                  },
                ),
              ]
            : null,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: kColorBlack.withOpacity(0.2), width: 1),
            bottom: BorderSide(color: kColorBlack.withOpacity(0.2), width: 1),
          )),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: Username + RatingBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AutoSizeText(
                          username,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isAdmin ? kColorRed : kColorBlack),
                          maxLines: 1,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        (!isAdmin) ? RatingBar.builder(
                          allowHalfRating: true,
                          initialRating: ratingPoint,
                          itemCount: 5,
                          minRating: 0,
                          itemSize: 17,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                          ),
                        ) : Container(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: AutoSizeText(
                        createAt,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                // Comment
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  child: AutoSizeText(
                    comment,
                    minFontSize: 14,
                    style: TextStyle(fontSize: 11),
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
