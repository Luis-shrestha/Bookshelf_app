import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteManager with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _favorites = [];
  List<String> get favorites => _favorites;

  FavoriteManager() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _favorites = List<String>.from(doc.data()?['favorites'] ?? []);
        notifyListeners();
      }
    }
  }

  Future<void> addFavorite(String id) async {
    if (!_favorites.contains(id)) {
      _favorites.add(id);
      await _updateFavorites();
    }
  }

  Future<void> removeFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
      await _updateFavorites();
    }
  }

  Future<void> _updateFavorites() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'favorites': _favorites,
      });
      notifyListeners();
    }
  }
}
