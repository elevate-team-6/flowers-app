import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setDefaults({AppStrings.deliveryDays: 2});

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: Duration(minutes: 30),
      ),
    );

    await _remoteConfig.fetchAndActivate();
  }

  int get deliveryDays => _remoteConfig.getInt('delivery_days');
}
