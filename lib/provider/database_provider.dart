import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roubou/models/Stock.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _stocks;

  Stream get allStocks => _firestore.collection("stocks").snapshots();

  Stream get latestDate => _firestore.collection("stocks")
      .orderBy("currentDate", descending: true).limit(1)
      .snapshots();

  /*
  Future<bool> addNewMovie(Movie m) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.add(
          {'name': m.movieName, 'poster': m.posterURL, 'length': m.length});
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeMovie(String movieId) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.doc(movieId).delete();
      return true;
    } catch (e) {
      print(e.message);
      return Future.error(e);
    }
  }

  Future<bool> editMovie(Movie m, String movieId) async {
    _movies = _firestore.collection('movies');
    try {
      await _movies.doc(movieId).update(
          {'name': m.movieName, 'poster': m.posterURL, 'length': m.length});
      return true;
    } catch (e) {
      print(e.message);
      return Future.error(e);
    }
  }

   */
}


final databaseProvider = Provider((ref) => Database());
