import 'package:enitproject/const/color.dart';
import 'package:flutter/material.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({Key? key,
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  }) : super(key: key);

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

///사실 오디오 예시에 있는거 그대로 복붙해서 뭐가뭔지 잘 모름^^
class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///재생위치 시간
          SizedBox(
            width: 40,
            child: Text(durationToString(widget.currentPosition)),
          ),

          ///재생바
          Expanded(
            child: Slider(
              min: 0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: percent * widget.duration.inMilliseconds.toDouble(),
              inactiveColor: const Color(0xFFEFEFEF),
              activeColor: GREEN_MID_COLOR,
              onChangeEnd: (newValue) {
                setState(() {
                  listenOnlyUserInterraction = false;
                  widget.seekTo(_visibleValue);
                });
              },
              onChangeStart: (_) {
                setState(() {
                  listenOnlyUserInterraction = true;
                });
              },
              onChanged: (newValue) {
                setState(() {
                  final to = Duration(milliseconds: newValue.floor());
                  _visibleValue = to;
                });
              },
            ),
          ),

          ///음성 총 시간
          SizedBox(
            width: 40,
            child: Text(durationToString(widget.duration)),
          ),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
  twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
  twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
