import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/items_provider.dart';
import '../widgets/item_card.dart';
import '../services/auth_service.dart';
import 'report_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temulik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ItemSearchDelegate(Provider.of<ItemsProvider>(context, listen: false).items),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await authService.signOut();
              if (mounted) {
                navigator.pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'User'),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                // Navigate to help screen
              },
            ),
          ],
        ),
      ),
      body: Consumer<ItemsProvider>(
        builder: (context, itemsProvider, child) {
          if (itemsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: itemsProvider.items.length,
            itemBuilder: (context, index) {
              final item = itemsProvider.items[index];
              return ItemCard(
                title: item.title,
                description: item.description,
                location: item.location,
                date: item.date.toString(),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'reportLost',
            child: const Icon(Icons.report_problem),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportItemScreen(isLostItem: true)),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'reportFound',
            child: const Icon(Icons.find_in_page),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportItemScreen(isLostItem: false)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ItemSearchDelegate extends SearchDelegate<String> {
  final List<Item> items;

  ItemSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items.where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ItemCard(
          title: item.title,
          description: item.description,
          location: item.location,
          date: item.date.toString(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items.where((item) =>
        item.title.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item.title),
          onTap: () {
            query = item.title;
            showResults(context);
          },
        );
      },
    );
  }
}