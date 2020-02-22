import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_stackoverflow/model/question/question.dart';
import 'package:intl/intl.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  const QuestionWidget({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(48.0),
              child: Image.network(
                question.owner.profileImage,
                width: 48,
                height: 48,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        question.owner.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                question.creationDate * 1000),
                          ),
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    question.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(_truncateWithEllipsis(220, question.body)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}
