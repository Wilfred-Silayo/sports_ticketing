import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_ticketing/apis/sales_api.dart';
import 'package:sports_ticketing/models/sales_model.dart';
import 'package:sports_ticketing/utils/utils.dart';

final salesControllerProvider = StateNotifierProvider<SalesController, bool>(
  (ref) => SalesController(
    saleAPI: ref.watch(salesAPIProvider),
  ),
);

final checkSeatAvailabilityProvider =
    StreamProvider.autoDispose.family<List<int>, String>((ref, id) {
  final salesController = ref.watch(salesControllerProvider.notifier);
  return salesController.checkSeatAvailability(id: id);
});

class SalesController extends StateNotifier<bool> {
  final SalesAPI _saleAPI;
  SalesController({required SalesAPI saleAPI})
      : _saleAPI = saleAPI,
        super(false);

  void markAsSold({
    required BuildContext context,
    required String matchId,
    required String stadiumId,
    required String ticketNo,
    required String seatType,
    required int index,
    required int seatNo,
  }) async {
    final String id = '$stadiumId-$matchId-$seatType-A$index';
    final Sales sale = Sales(
        id: id,
        ticketNo: [ticketNo],
        seatNo: [seatNo],
        seatType: seatType,
        matchId: matchId,
        stadiumId: stadiumId);
    final res = await _saleAPI.markSeatAsSold(sale);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void releaseSeat({
    required BuildContext context,
    required String matchId,
    required String ticketNo,
    required String stadiumId,
    required String seatType,
    required int seatNo,
  }) async {
    final String id = '$stadiumId-$matchId-$seatType';
    final Sales sale = Sales(
        id: id,
        ticketNo: [ticketNo],
        seatNo: [seatNo],
        seatType: seatType,
        matchId: matchId,
        stadiumId: stadiumId);
    final res = await _saleAPI.releaseSeat(sale);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<int>> checkSeatAvailability({
    required String id,
  }) {
    return _saleAPI.checkSeat(id);
  }
}
