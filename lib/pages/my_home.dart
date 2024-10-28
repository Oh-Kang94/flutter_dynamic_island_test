import 'dart:async';

import 'package:dynamic_island_timer/model/timer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/url_scheme_data.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  // StreamSubscription<UrlSchemeData>? urlSchemeSubscription;
  TimerModel? _timerModel;

  String timerName = 'No Name';
  late TextEditingController timerNameController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _liveActivitiesPlugin.init(
        appGroupId: 'group.ohkang.dynisland',
      );
    });

    timerNameController = TextEditingController(text: timerName);

    _liveActivitiesPlugin.activityUpdateStream.listen((event) {
      event.map(
        active: (ActiveActivityUpdate activity) {
          // token
          debugPrint('--------------------------------');
          debugPrint('Live Activity updated: ${activity.activityId}');
          debugPrint('--------------------------------');
        },
        ended: (EndedActivityUpdate activity) {
          debugPrint('Live Activity ended: $activity');
        },
        stale: (StaleActivityUpdate activity) {
          debugPrint('Live Activity stale: $activity');
        },
        unknown: (UnknownActivityUpdate event) {
          debugPrint('Live Activity unknown: $event');
        },
      );
      debugPrint('Live Activity updated: $_latestActivityId');
    });
  }

  @override
  void dispose() {
    _liveActivitiesPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Timer Name"),
              TextField(
                controller: timerNameController,
              ),
              CupertinoButton(
                child: const Text(
                  "SetTimer 3 Minutes",
                ),
                onPressed: () async {
                  TimerModel timerModel = TimerModel(
                    matchStartDate: DateTime.now(),
                    matchEndDate:
                        DateTime.now().add(const Duration(minutes: 3)),
                    timerName: timerNameController.text,
                  );

                  _createActivity(timerModel);
                },
              ),
              _latestActivityId != null
                  ? ElevatedButton(
                      onPressed: () {
                        _liveActivitiesPlugin.endActivity(_latestActivityId!);
                        setState(() => _latestActivityId = null);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('End the Live Activity'),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createActivity(TimerModel activity) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final activityId = await _liveActivitiesPlugin.createActivity(
          activity.toMap(),
        );
        setState(() => _latestActivityId = activityId);
      });
      debugPrint(
          "${await _liveActivitiesPlugin.getActivityState(_latestActivityId!)}");
      debugPrint(
          "${await _liveActivitiesPlugin.getPushToken(_latestActivityId!)}");
      debugPrint("${await _liveActivitiesPlugin.getAllActivities()}");
    } catch (e) {
      debugPrint('Error creating activity: $e');
    }
  }
}
