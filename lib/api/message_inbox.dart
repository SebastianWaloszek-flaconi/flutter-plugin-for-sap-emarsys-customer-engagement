import 'package:emarsys_sdk/mappers/message_mapper.dart';
import 'package:emarsys_sdk/model/message.dart';
import 'package:flutter/services.dart';

class MessageInbox {
  final MethodChannel _channel;
  final MessageMapper _mapper;

  MessageInbox(this._channel, this._mapper);

  Future<List<Message>> fetchMessages() async {
    List<dynamic>? messages =
        await _channel.invokeMethod('inbox.fetchMessages');
    if (messages == null) {
      throw NullThrownError();
    }
    return _mapper.map(messages);
  }
}
