import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sports_ticketing/models/user_model.dart';
import 'package:sports_ticketing/pages/loading_page.dart';
import 'package:sports_ticketing/pages/pdf_preview.dart';
import 'package:sports_ticketing/providers/auth_provider.dart';
import 'package:sports_ticketing/providers/sales_provider.dart';
import 'package:sports_ticketing/providers/ticket_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/match_model.dart';
import '../models/stadium_model.dart';

class TicketPreview extends ConsumerWidget {
  const TicketPreview({
    Key? key,
    required this.blockName,
    required this.index,
    required this.stadium,
    required this.category,
    required this.seatNumber,
    required this.match,
  }) : super(key: key);
  final int seatNumber;
  final int index;
  final Stadium stadium;
  final String blockName;
  final String category;
  final MatchModel match;

  final Map<String, double> prices = const {
    "VVIP": 100000.00,
    "VIPA": 50000.00,
    "VIPB": 25000.00,
    "VIPC": 15000.00,
    "ORANGE": 10000.00,
    "ROUND": 5000,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String ticketNo = const Uuid().v1();
    final String matchToPlay = "${match.homeTeam} vs ${match.awayTeam}";
    final UserModel? user = ref.watch(currentUserDetailsProvider).value;
    final double totalPrice = prices[category] ?? 0.0;
    final formattedPrice = NumberFormat("#,##0.00", "en_US").format(totalPrice);
    final formattedTax =
        NumberFormat("#,##0.00", "en_US").format(totalPrice / 10);
    final bool isLoading = ref.watch(userTicketControllerProvider);
    final bool isLoadingSale = ref.watch(salesControllerProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(userTicketControllerProvider.notifier).buyTicket(
              match: match.matchId,
              amount: totalPrice,
              seatNo: seatNumber,
              seatType: blockName,
              ticketNo: ticketNo,
              userId: user!.uid,
              context: context);
          ref.read(salesControllerProvider.notifier).markAsSold(
              index: index,
              context: context,
              matchId: match.matchId,
              stadiumId: stadium.id,
              ticketNo: ticketNo,
              seatType: category,
              seatNo: seatNumber);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfPreviewPage(
                match: match,
                amount: totalPrice,
                seatNo: seatNumber,
                seatType: blockName,
                ticketNo: ticketNo,
                stadium: stadium,
                user: user,
              ),
            ),
          );
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Ticket Preview"),
      ),
      body: user == null || isLoading || isLoadingSale
          ? const Loader()
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Customer',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                user.username,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                user.email,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Column(
                      children: [
                        const SizedBox(height: 3),
                        const Text(
                          'Ticket Items',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 3),
                        const Divider(),
                        ListTile(
                          title: const Text("TicketNo:"),
                          trailing: Text(
                            ticketNo,
                          ),
                        ),
                        ListTile(
                          title: const Text("Match:"),
                          trailing: Text(
                            matchToPlay,
                          ),
                        ),
                        ListTile(
                          title: const Text("Date of Play:"),
                          trailing: Text(
                            "${match.timestamp.day}/${match.timestamp.month}/${match.timestamp.year}",
                          ),
                        ),
                        ListTile(
                          title: const Text("Time of Play:"),
                          trailing: Text(
                            'Time: ${match.timestamp.hour}:${match.timestamp.minute < 10 ? '0${match.timestamp.minute}' : match.timestamp.minute}',
                          ),
                        ),
                        ListTile(
                          title: const Text("Stadium:"),
                          trailing: Text(
                            stadium.name,
                          ),
                        ),
                        ListTile(
                          title: const Text("Seat Type:"),
                          trailing: Text(
                            blockName,
                          ),
                        ),
                        ListTile(
                          title: const Text("Seat Type:"),
                          trailing: Text(
                            seatNumber.toString(),
                          ),
                        ),
                        const Divider(),
                        DefaultTextStyle.merge(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Total Amount"),
                                  Text(
                                    formattedPrice,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("Total Tax"),
                                  Text(
                                    formattedTax,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
