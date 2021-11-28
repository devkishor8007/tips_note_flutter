import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/data/services/user_data_servce.dart';

final userDataRiverpod = Provider<UserDataService>((ref) => UserDataService());
