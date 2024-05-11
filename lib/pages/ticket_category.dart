import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_ticketing/models/match_model.dart';
import 'package:sports_ticketing/models/stadium_model.dart';
import 'package:sports_ticketing/pages/seat_selection.dart';

class TicketCategory extends ConsumerStatefulWidget {
  final MatchModel match;
  final Stadium stadium;
  const TicketCategory({super.key, required this.match, required this.stadium});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TicketCategoryState();
}

class _TicketCategoryState extends ConsumerState<TicketCategory>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets Categories'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'VVIP'),
            Tab(text: 'VIPA'),
            Tab(text: 'VIPB'),
            Tab(text: 'VIPC'),
            Tab(text: 'ORANGE'),
            Tab(text: 'ROUND'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList('VVIP'),
          _buildCategoryList('VIPA'),
          _buildCategoryList('VIPB'),
          _buildCategoryList('VIPC'),
          _buildCategoryList('ORANGE'),
          _buildCategoryList('ROUND'),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String category) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        String blockName = '$category block A${index + 1}';
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
            ),
          ),
          child: ListTile(
            title: Text(blockName),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeatSelectionPage(
                  blockName: blockName,
                  stadium: widget.stadium,
                  index: index,
                  category: category,
                  match: widget.match,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
