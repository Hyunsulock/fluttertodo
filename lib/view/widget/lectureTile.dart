import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LectureTile extends StatefulWidget {
  final int color;
  final int flexLen;
  final String? title;
  final String? room;
  final String? prof;
  final bool? isNotEmpty;
  final Function? onTap;
  const LectureTile(
      {Key? key,
      required int this.color,
      required this.flexLen,
      this.title,
      this.room,
      this.prof,
      this.isNotEmpty,
      this.onTap})
      : super(key: key);

  @override
  _LectureTileState createState() => _LectureTileState();
}

class _LectureTileState extends State<LectureTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.isNotEmpty!)
      return Expanded(
        flex: widget.flexLen,
        child: GestureDetector(
          onTap: () {
            widget.onTap!();
            print(widget.title);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Color(widget.color),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.prof!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.room!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      );

    return Expanded(
        flex: widget.flexLen,
        child: Container(
          child: Container(),
        ));
  }
}
