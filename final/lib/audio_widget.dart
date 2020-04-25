// Copyright (c) 2020 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
//     copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify,
//     merge, publish, distribute, sublicense, create a derivative work,
// and/or sell copies of the Software in any work that is designed,
// intended, or marketed for pedagogical or instructional purposes
// related to programming, coding, application development, or
// information technology. Permission for such use, copying,
//    modification, merger, publication, distribution, sublicensing,
//    creation of derivative works, or sale is expressly withheld.
//
// This project and source code may use libraries or frameworks
// that are released under various Open-Source licenses. Use of
// those libraries and frameworks are governed by their own
// individual licenses.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

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
    @required this.totalTime,
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
  bool _userIsMovingSlider;

  @override
  void initState() {
    super.initState();
    _sliderValue = _getSliderValue();
    _userIsMovingSlider = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_userIsMovingSlider) {
      _sliderValue = _getSliderValue();
    }
    return Container(
      color: Colors.transparent,
      height: 60,
      child: Row(
        children: [
          _buildPlayPauseButton(),
          _buildCurrentTimeLabel(),
          _buildSeekBar(),
          _buildTotalTimeLabel(),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  IconButton _buildPlayPauseButton() {
    return IconButton(
      icon: (widget.isPlaying) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      onPressed: () {
        if (widget.onPlayStateChanged != null) {
          widget.onPlayStateChanged(!widget.isPlaying);
        }
      },
    );
  }

  Text _buildCurrentTimeLabel() {
    return Text(
      _getTimeString(_sliderValue),
      style: TextStyle(
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }

  Expanded _buildSeekBar() {
    return Expanded(
      child: Slider(
        value: _sliderValue,
        activeColor: Theme.of(context).textTheme.body1.color,
        inactiveColor: Theme.of(context).disabledColor,
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
    );
  }

  Text _buildTotalTimeLabel() {
    return Text(
      _getTimeString(1.0),
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
    if (widget.currentTime == null) {
      return 0;
    }
    return widget.currentTime.inMilliseconds / widget.totalTime.inMilliseconds;
  }

  Duration _getDuration(double sliderValue) {
    final seconds = widget.totalTime.inSeconds * sliderValue;
    return Duration(seconds: seconds.toInt());
  }
}
