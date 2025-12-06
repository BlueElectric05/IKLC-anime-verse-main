import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/anime.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _userCollection() {
    return _firestore.collection('users');

  }

  Stream<List<Anime>> getFavoriteStream(String userId){
    return _userCollection().doc(userId).collection('favorites').snapshots().map((snapshot){
      return snapshot.docs.map((doc) => Anime.fromFavoritesJson(doc.data())).toList();
    });
  }

  Future<void> addFavorite(String userId, Anime anime) async {
    await _userCollection()
        .doc(userId)
        .collection('favorites')
        .doc(anime.malId.toString())
        .set(anime.toJson());
  }

  Future<void> removeFavorite(String userId, int malId) async {
    await _userCollection().doc(userId).collection('favorites').doc(malId.toString()).delete();

  }

}