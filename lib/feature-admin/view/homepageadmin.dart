import 'package:flutter/material.dart';
import 'package:my_bh/routes/app_routing.dart';

import 'pages/AdvicePage.dart';
import 'pages/AnalyticsPage.dart';
import 'pages/actualitesBH.dart';
import 'pages/UsersPage.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  int _selectedIndex = 0; // Index pour la navigation dans le sidebar

  // Liste des pages correspondant aux options du sidebar
  final List<Widget> _pages = [
    const UsersPage(),
    const AdvicePage(),
    ActualitesBH(),
    const AnalyticsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Actions pour le menu déroulant
              if (value == 'deconnexion') {
                AppRoutes().goToEnd(AppRoutes.splash);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Déconnexion'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: 'deconnexion',
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Panneau d\'administration',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Utilisateurs'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context); // Ferme le drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text('Conseils'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notification_important_sharp),
              title: const Text('Actualités BH'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.analytics),
            //   title: const Text('Analytics'),
            //   selected: _selectedIndex == 3,
            //   onTap: () {
            //     _onItemTapped(3);
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.featured_play_list),
            //   title: const Text('Feature'),
            //   selected: _selectedIndex == 4,
            //   onTap: () {
            //     _onItemTapped(4);
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Affiche la page sélectionnée
    );
  }
}
