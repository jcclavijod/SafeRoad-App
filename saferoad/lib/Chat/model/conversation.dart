import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../Auth/model/user_model.dart';
import '../utils/conversationKey.dart';

class Conversation extends Equatable {
  final String? id;
  final UserModel? creator;
  final UserModel? receiver;
  final List<String> members;
  const Conversation({
    this.id,
    required this.creator,
    required this.receiver,
    required this.members,
  });

  Conversation copyWith({
    String? id,
    UserModel? creator,
    UserModel? receiver,
    List<String>? members,
  }) {
    return Conversation(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      receiver: receiver ?? this.receiver,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ConversationKey.id: id,
      ConversationKey.creator: creator!.toMap(),
      ConversationKey.receiver: receiver!.toMap(),
      ConversationKey.members: members,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map[ConversationKey.id]?.toString(),
      creator: UserModel.fromMap(
          map[ConversationKey.creator] as Map<String, dynamic>),
      receiver: UserModel.fromMap(
        map[ConversationKey.receiver] as Map<String, dynamic>,
      ),
      members: List<String>.from(map[ConversationKey.members] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Conversation(id: $id, creator: $creator, receiver: $receiver, members: $members)';
  }

  @override
  List<Object> get props => [creator!, receiver!, members];
}
