import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String stock, companyName;
  int RS_Rating;
  Timestamp currentDate;
  double ema200, weekHigh52, weekLow52;

  Stock(this.RS_Rating, this.companyName, this.currentDate, this.ema200, this.stock, this.weekHigh52, this.weekLow52);
}
