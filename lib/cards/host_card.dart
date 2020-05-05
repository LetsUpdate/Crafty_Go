import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HostStatCard extends StatelessWidget {
  final HostStat stat;
  final GestureTapCallback onTapSettings;

  const HostStatCard({Key key, this.stat, this.onTapSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        _StatItem(
          icon: Icons.computer,
          text: stat != null
              ? "CPU ${stat.cpuUsage}%\n${(stat.cpuCurFreq / 100).round() /
              10}Ghz/${(stat.cpuMaxFreq / 100).round() / 10}Ghz\ncores: ${stat
              .cpuCores}"
              : "CPI",
          color: Colors.cyan,
        ),
        _StatItem(
          icon: Icons.memory,
          color: Colors.green,
          text: stat != null
              ? "RAM ${stat.memPercent}%\n ${stat.memUsage}/${stat.memTotal}"
              : "RAM",
        ),
        _StatItem(
          icon: Icons.storage,
          color: Colors.deepOrangeAccent,
          text: stat != null
              ? "Root Disk\n ${stat.diskPercent}%\n ${stat.diskUsage}/${stat
              .diskTotal}"
              : "Storages",
        ),
        GestureDetector(
          onTap: onTapSettings,
          child: _StatItem(
            icon: Icons.settings,
            color: Colors.lightGreenAccent,
            text: "",
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatItem({Key key, this.icon, this.text, this.color})
      : super(key: key);

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
                color: color),
            child: Icon(
              icon,
              size: 40,
            ),
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
