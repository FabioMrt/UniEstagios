import 'package:flutter/material.dart';
import 'package:uniestagios/screens/enterprise/candidates_list.dart';
import 'package:uniestagios/screens/enterprise/enterprise_page.dart';
import 'package:uniestagios/screens/profile/enterprise_profile/enterprise_profile.dart';

import 'package:uniestagios/theme.dart';

class EnterpriseNav extends StatefulWidget {
  const EnterpriseNav({Key? key}) : super(key: key);

  @override
  State<EnterpriseNav> createState() => _EnterpriseNavState();
}

class _EnterpriseNavState extends State<EnterpriseNav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    EnterprisePage(),
    CandidatesList(),
    EnterpriseProfileScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: kPrimaryColor,
        selectedItemColor: kSecondaryColor,
        unselectedLabelStyle: TextStyle(color: kPrimaryColor),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: "Candidatos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Perfil",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
