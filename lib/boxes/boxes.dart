import 'package:hive/hive.dart';
import 'package:spicyspoon/model/deal_model.dart';
import 'package:spicyspoon/model/menu_model.dart';

class Boxes {
  static Box<MenuModel> getData() => Hive.box<MenuModel>('pos');
  static Box<DealModel> getDealData() => Hive.box<DealModel>('posdeal');

  

}
