import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  final String name;
  final String email;
  final String nid;
  final String phone;
  final String registerAs;
  final String registerAsSeller;
  final String registerAsSellerRole;
  final String registerAsServiceSeller;
  final String registerAsStoreSeller;
  final String image;
  final position;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.nid,
    required this.phone,
    required this.registerAs,
    required this.registerAsSeller,
    required this.registerAsSellerRole,
    required this.registerAsServiceSeller,
    required this.registerAsStoreSeller,
    required this.image,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nid': nid,
      'phone': phone,
      'registerAs': registerAs,
      'registerAsSeller': registerAsSeller,
      'registerAsSellerRole': registerAsSellerRole,
      'registerAsServiceSeller': registerAsServiceSeller,
      'registerAsStoreSeller': registerAsStoreSeller,
      'image': image,
      'position': position,
    };
  }

  CurrentUser.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.data()!["uid"],
        name = doc.data()!["name"],
        email = doc.data()!["email"],
        nid = doc.data()!["nid"],
        phone = doc.data()!["phone"],
        position = doc.data()!["position"],
        registerAs = doc.data()!["registerAs"],
        registerAsSeller = doc.data()!["registerAsSeller"],
        registerAsSellerRole = doc.data()!["registerAsSellerRole"],
        registerAsServiceSeller = doc.data()!["registerAsServiceSeller"],
        registerAsStoreSeller = doc.data()!["registerAsStoreSeller"],
        image = doc.data()!["image"];
}
