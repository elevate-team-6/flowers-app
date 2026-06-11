import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await _remoteConfig.setDefaults({'delivery_days': 2});

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _remoteConfig.fetchAndActivate();
  }

  static int get deliveryDays => _remoteConfig.getInt('delivery_days');
}
