// ignore_for_file: depend_on_referenced_packages, unused_catch_stack

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/conversation.dart';
import '../../repository/chatRepository.dart';

part 'chat_blc_event.dart';
part 'chat_blc_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  ChatBloc({
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<ChatRequested>(_onChatRequestedToState);
  }

  FutureOr<void> _onChatRequestedToState(
    ChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoadInprogress());
      final chats = await chatRepository.getChats(loginUID: event.loginUID);
      emit(ChatLoadSuccess(chats: chats));
    } on Exception catch (e, trace) {
      emit(const ChatLoadFailure(message: 'unable to load chats'));
    }
  }
}

/*
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatRepository chatRepository = ChatRepository();

  ChatBloc() : super(ChatInitial()) {
    on<ChatRequested>(_onChatRequestedToState);
  }

  FutureOr<void> _onChatRequestedToState(
    ChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoadInprogress());
      final chats = await chatRepository.getChats(loginUID: event.loginUID);
      emit(ChatLoadSuccess(chats: chats));
    } on Exception catch (e, trace) {
      emit(const ChatLoadFailure(message: 'no se pueden cargar los chats'));
    }
  }
}
*/