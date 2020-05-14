import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

class WadahUtama {
  String key;
  dynamic value;

  WadahUtama(this.value);

  WadahUtama.fromSnapShot(DataSnapshot snapshot)
      : key = 'Wadahutama',
        value = snapshot.value;

  toJson() {
    return {
      "value": value,
    };
  }
}
