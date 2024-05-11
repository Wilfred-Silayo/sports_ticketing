import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_ticketing/apis/stadium_api.dart';
import 'package:sports_ticketing/models/stadium_model.dart';

final stadiumControllerProvider =
    StateNotifierProvider<StadiumController, bool>(
  (ref) => StadiumController(
    stadiumAPI: ref.watch(stadiumAPIProvider),
  ),
);

final getStadiumProvider = StreamProvider.family(
  (ref, String id) =>
      ref.watch(stadiumControllerProvider.notifier).getStadiums(id),
);

class StadiumController extends StateNotifier<bool> {
  final StadiumAPI _stadiumAPI;
  StadiumController({required StadiumAPI stadiumAPI})
      : _stadiumAPI = stadiumAPI,
        super(false);

  Stream<Stadium> getStadiums(String id) {
    return _stadiumAPI.getStadiums(id);
  }
}
