import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:pmsn_06/screens/carrito_rentas_screen.dart';
import 'package:pmsn_06/services/firestore_carrito_service.dart';

Widget buildCarritoIconButton(BuildContext context) {
  final FirestoreCarritoService _firestoreCarritoService =
      FirestoreCarritoService();
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _firestoreCarritoService.getcarrito(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container();
      } else if (snapshot.hasError) {
        return Container();
      } else {
        int carritoLength = snapshot.data!.length;
        return badges.Badge(
          badgeContent: Text('$carritoLength'),
          position: badges.BadgePosition.bottomStart(bottom: -5, start: -5),
          showBadge: true,
          ignorePointer: false,
          badgeAnimation: const badges.BadgeAnimation.fade(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          child: IconButton(
            icon: Icon(Icons.shop),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarritoScreen(),
                ),
              );
            },
          ),
        );
      }
    },
  );
}
