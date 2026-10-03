import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  StorageService(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  Future<String> uploadRainPhoto(File file) async {
    final path = '${_uuid.v4()}.jpg';
    await _client.storage.from('rain-photos').upload(path, file);
    return _client.storage.from('rain-photos').getPublicUrl(path);
  }
}
