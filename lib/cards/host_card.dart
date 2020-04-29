import 'package:craftycontroller/CraftyAPI/static/models/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HostStatCard extends StatelessWidget {
  final HostStatData stat;

  const HostStatCard({Key key, this.stat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceAround,
      children: <Widget>[
        _StatItem(),
        _StatItem(),
        _StatItem(),
        _StatItem(),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black54,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.cyan),
            child: Icon(
              Icons.computer,
              size: 40,
            ),
          ),
          Text(
            "CPU 100% \n 0.8 Ghz / 2.7 Ghz",
            style: TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
