import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Map<String, dynamic>> cocAccounts = [];
  List<Map<String, dynamic>> brawlAccounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cocAccounts = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('coc_accounts') ?? '[]')
            .map((x) => Map<String, dynamic>.from(x))
      );
      brawlAccounts = List<Map<String, dynamic>>.from(
        jsonDecode(prefs.getString('brawl_accounts') ?? '[]')
            .map((x) => Map<String, dynamic>.from(x))
      );
      isLoading = false;
    });
  }

  Future<void> _saveAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('coc_accounts', jsonEncode(cocAccounts));
    await prefs.setString('brawl_accounts', jsonEncode(brawlAccounts));
  }

  Future<void> _addAccount(String game) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController tagController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${game == 'coc' ? 'Clash of Clans' : 'Brawl Stars'} Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Account Name',
                hintText: 'Enter a name for this account',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                labelText: 'Player Tag',
                hintText: 'Enter player tag (e.g., 2RR28G9J)',
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && tagController.text.isNotEmpty) {
                setState(() {
                  if (game == 'coc') {
                    cocAccounts.add({
                      'name': nameController.text,
                      'tag': tagController.text.replaceAll('#', ''),
                    });
                  } else {
                    brawlAccounts.add({
                      'name': nameController.text,
                      'tag': tagController.text.replaceAll('#', ''),
                    });
                  }
                });
                _saveAccounts();
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(String game, int index) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (game == 'coc') {
                  cocAccounts.removeAt(index);
                } else {
                  brawlAccounts.removeAt(index);
                }
              });
              _saveAccounts();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Accounts')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Accounts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Clash of Clans'),
              Tab(text: 'Brawl Stars'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAccountsList('coc'),
            _buildAccountsList('brawl'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addAccount(
            DefaultTabController.of(context).index == 0 ? 'coc' : 'brawl',
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAccountsList(String game) {
    final accounts = game == 'coc' ? cocAccounts : brawlAccounts;
    
    if (accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              game == 'coc' ? Icons.shield : Icons.sports_esports,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No ${game == 'coc' ? 'Clash of Clans' : 'Brawl Stars'} accounts added',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _addAccount(game),
              child: Text('Add Account'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(
              game == 'coc' ? Icons.shield : Icons.sports_esports,
              size: 32,
            ),
            title: Text(account['name']),
            subtitle: Text('#${account['tag']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteAccount(game, index),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                game == 'coc' ? '/player-details' : '/brawl-details',
                arguments: account,
              );
            },
          ),
        );
      },
    );
  }
} 