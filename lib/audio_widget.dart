library audio_widget;

import 'dart:ui';

import 'package:flutter/material.dart';

/// AudioWidget is a UI component to allow users to interact with an audio
/// player. This widget does not play audio itself, but it can be used in
/// combination with any audio plugin.
class AudioWidget extends StatefulWidget {
  const AudioWidget({
    Key key,
    this.isPlaying = false,
    this.onPlayStateChanged,
    this.currentTime,
    this.onSeekBarMoved,
    this.totalTime,
  }) : super(key: key);

  /// When [isPlaying] is `true`, the play button displays a pause icon. When
  /// it is `false`, the button shows a play icon.
  final bool isPlaying;

  /// This is called when a user has pressed the play/pause button. You should
  /// update [isPlaying] and then rebuild the widget with the new value.
  final ValueChanged<bool> onPlayStateChanged;

  /// The [currentTime] is displayed between the play/pause button and the seek
  /// bar. This value also affects the current position of the seek bar in
  /// relation to the total time. An audio plugin can update this value as it
  /// is playing to let the user know the current time in the audio track.
  final Duration currentTime;

  /// This is called after the user has finished choosing a new position on
  /// the seek bar. You should use this new value with an audio plugin to seek
  /// to the appropriate location in the audio track.
  final ValueChanged<Duration> onSeekBarMoved;

  /// This is the total time length of the audio track that is being played.
  final Duration totalTime;

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  double _sliderValue;
  Duration _currentTime;
  bool _userIsMovingSlider;

  @override
  void initState() {
    super.initState();
    _sliderValue = _getSliderValue();
    _currentTime = widget.currentTime;
    _userIsMovingSlider = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTime != widget.currentTime && !_userIsMovingSlider) {
      _sliderValue = _getSliderValue();
      _currentTime = widget.currentTime;
    }
    return Container(
      color: Colors.black,
      height: 60,
      child: Row(
        children: [
          IconButton(
            icon:
                (widget.isPlaying)
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
            color: Colors.white,
            onPressed: () {
              if (widget.onPlayStateChanged != null) {
                widget.onPlayStateChanged(!widget.isPlaying);
              }
            },
          ),
          Text(
            _getTimeString(_sliderValue),
            style: TextStyle(
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Expanded(
            child: Slider(
              value: _sliderValue,
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              onChangeStart: (value) {
                _userIsMovingSlider = true;
              },
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                _userIsMovingSlider = false;
                if (widget.onSeekBarMoved != null) {
                  final currentTime = _getDuration(value);
                  widget.onSeekBarMoved(currentTime);
                }
              },
            ),
          ),
          Text(
            _getTimeString(1.0),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  // Adapted from [Duration.toString()].
  String _getTimeString(double sliderValue) {
    final time = _getDuration(sliderValue);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final minutes =
        twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));
    final seconds =
        twoDigits(time.inSeconds.remainder(Duration.secondsPerMinute));

    final hours = widget.totalTime.inHours > 0 ? '${time.inHours}:' : '';
    return "$hours$minutes:$seconds";
  }

  double _getSliderValue() {
    return widget.currentTime.inMilliseconds / widget.totalTime.inMilliseconds;
  }

  Duration _getDuration(double sliderValue) {
    final seconds = widget.totalTime.inSeconds * sliderValue;
    return Duration(seconds: seconds.toInt());
  }
}
