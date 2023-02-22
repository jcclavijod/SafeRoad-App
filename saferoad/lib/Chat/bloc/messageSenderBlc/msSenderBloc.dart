import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/message.dart';
import '../../repository/messageRepository.dart';

part 'msSenderEvent.dart';
part 'msSenderState.dart';

class MessageSenderBloc extends Bloc<MessageSenderEvent, MessageSenderState> {
  final MessageRepository messageRepository;

  MessageSenderBloc(
    this.messageRepository,
  ) : super(MessageInitial()) {
    on<MessageSent>(_onMessageSentToState);
  }

  FutureOr<void> _onMessageSentToState(
    MessageSent event,
    Emitter<MessageSenderState> emit,
  ) async {
    try {
      emit(MessageSentInprogress());
      await messageRepository.sendMessage(message: event.message);
      emit(MessageSentSuccess());
    } on Exception catch (e, stackTrace) {
      log('Issue while sending message ${e.toString()} $stackTrace');
      emit(MessageSentFailure(message: e.toString()));
    }
  }
}
