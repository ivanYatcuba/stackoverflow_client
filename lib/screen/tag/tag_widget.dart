import 'package:flutter/material.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';
import 'package:flutter_stackoverflow/util/stack_overflow_client_icons.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({Key key, @required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => {
          Navigator.of(context)
              .pushNamed('/question', arguments: [this.tag.name])
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        StackOverflowClient.android,
                        color: Colors.green,
                      ),
                    ),
                    visible: tag.name == "android",
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Text(tag.name),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(child: Text(tag.description ?? "")),
                ],
              ),
              SizedBox(height: 12),
              Text(
                S.of(context).label_tag_questions_count(tag.count.toString()),
                style: TextStyle(fontSize: 11.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
