
class ChatMessage{
  String? MessageContent;
  String? MessageSender;

  ChatMessage(
      this.MessageContent,
      this.MessageSender
      );

  factory ChatMessage.fromJson(json){
    return ChatMessage(json['MessageContent'], json['MessageSender']);
  }

  toJson(){
    Map<String , dynamic> json = Map<String , dynamic>();
    json['MessageContent'] = this.MessageContent;
    json['MessageSender'] = this.MessageSender;
  }
}