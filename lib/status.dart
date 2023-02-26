import 'package:equatable/equatable.dart';
import 'package:whatsapp_status/status_item.dart';

class Status extends Equatable {
  final String username;
  final String profilePicture;

  final List<StatusItem> items;

  const Status({
    required this.username,
    required this.profilePicture,
    required this.items,
  });

  @override
  List<Object?> get props => [username, profilePicture, items];
}
