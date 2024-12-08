import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';

class PedometerState {
  final String status;
  final String steps;

  PedometerState({required this.status, required this.steps});
}

class PedometerNotifier extends StateNotifier<PedometerState> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  PedometerNotifier() : super(PedometerState(status: '?', steps: '0')) {
    _initPlatformState();
  }

  void _initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(_onPedestrianStatusChanged)
        .onError(_onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    state = PedometerState(status: state.status, steps: event.steps.toString());
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    state = PedometerState(status: event.status, steps: state.steps);
  }

  void _onPedestrianStatusError(error) {
    state = PedometerState(
        status: 'Pedestrian Status not available', steps: state.steps);
  }

  void _onStepCountError(error) {
    state =
        PedometerState(status: state.status, steps: 'Step Count not available');
  }

  static String getSteps(PedometerState state) {
    return state.steps;
  }

  static String getDistance(PedometerState state) {
    double distanceInMeters = int.parse(state.steps) * 0.7;
    if (distanceInMeters >= 1000) {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    } else {
      return "${distanceInMeters.toStringAsFixed(2)} m";
    }
  }

  static double getPercent(PedometerState state) {
    const goal = 10000;
    if (int.parse(state.steps) > goal) {
      return 1.0;
    } else {
      return int.parse(state.steps) / 10000;
    }
  }

  static String getPercentString(PedometerState state) {
    final goal = 10000;
    if (int.parse(state.steps) > goal) {
      return "100%";
    } else {
      return "${(int.parse(state.steps) / 10000 * 100).toStringAsFixed(1)}%";
    }
  }
}

final pedometerProvider =
    StateNotifierProvider<PedometerNotifier, PedometerState>((ref) {
  return PedometerNotifier();
});
