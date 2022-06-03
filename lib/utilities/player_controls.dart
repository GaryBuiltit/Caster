// ignore_for_file: prefer_const_constructors, unused_import, must_be_immutable, use_key_in_widget_constructors

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:caster/providers/podcast_search_data_provider.dart';
import 'package:caster/utilities/play_button.dart';
import 'package:flutter/material.dart';
import 'package:caster/providers/audio_player_controller_provider.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<PositionData>(
            stream: Provider.of<AudioPlayerController>(context, listen: true)
                .positionDataStream,
            builder: (context, snapshot) {
              final duration = snapshot.data;
              return IconButton(
                iconSize: 64,
                padding: EdgeInsets.only(right: 15),
                icon: Icon(
                  Icons.replay_30_rounded,
                ),
                onPressed: () {
                  Provider.of<AudioPlayerController>(context, listen: false)
                      .player
                      .seek(
                          Duration(seconds: duration!.position.inSeconds - 30));
                },
              );
            }),
        StreamBuilder<PlayerState>(
          stream: Provider.of<AudioPlayerController>(context, listen: false)
              .player
              .playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            return playerButton(
                playerState,
                Provider.of<AudioPlayerController>(context, listen: false)
                    .player);
          },
        ),
        IconButton(
          iconSize: 64,
          icon: Icon(
            Icons.skip_next,
          ),
          onPressed: () async {
            await Provider.of<SearchData>(context, listen: false)
                .podcastSearch();

            Provider.of<AudioPlayerController>(context, listen: false)
                .initPlayer(
              episodeURL: context.read<SearchData>().episodeURL,
              episodeTitle:
                  Provider.of<SearchData>(context, listen: false).episodeTitle,
              showTitle:
                  Provider.of<SearchData>(context, listen: false).showTitle,
              showPic: Provider.of<SearchData>(context, listen: false).showPic,
            );
          },
        ),
      ],
    );
  }
}
