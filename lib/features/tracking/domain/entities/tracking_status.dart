enum TrackingStatus {
  pending,
  accepted,
  preparing,
  outForDelivery,
  delivered,
}

extension TrackingStatusX on TrackingStatus {
  int get completedStepsCount {
    return switch (this) {
      TrackingStatus.pending => 0,
      TrackingStatus.accepted => 1,
      TrackingStatus.preparing => 2,
      TrackingStatus.outForDelivery => 3,
      TrackingStatus.delivered => 4,
    };
  }

  bool isStepCompleted(int stepIndex) => stepIndex < completedStepsCount;
}
