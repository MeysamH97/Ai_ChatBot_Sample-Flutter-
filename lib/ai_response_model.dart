class ContentResponse {
  String? id;
  String? object;
  String? model;
  List<Choice>? choices;

  ContentResponse({this.id, this.object, this.model, this.choices});

  ContentResponse.fromJson(Map<String,dynamic>json){
    id = json['id'];
    object = json['object'];
    model = json['model'];
    if(json['choices'] != null ){
      choices = <Choice>[];
      json['choices'].forEach((dynamic v) {
        choices!.add(Choice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['model'] = model;
    if(choices != null){
      data['choices'] = choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Choice {
  int? index;
  Delta? delta;
  String? finishReason;

  Choice({this.index, this.delta, this.finishReason});

  Choice.fromJson(Map<String, dynamic> json){
    index = json['index'];
    delta = json['delta'] != null ? Delta.fromJson(json['delta']) : null ;
    finishReason = json['finish_reason'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = <String, dynamic> {};
    data['index'] = index;
    if (delta != null) {
      data['delta'] = delta!.toJson();
    }
    data['finish_reason'] = finishReason;
    return data;
  }
}

class Delta {
  String? content;
  String? role;

  Delta({this.content, this.role});

  Delta.fromJson(Map<String, dynamic> json){
    content= json['content'];
    role= json['role'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['role'] = role;
    return data;
  }
}

class MessageStruct {
  String? role;
  String? content;
  DateTime? time;

  MessageStruct({this.role, this.content, this.time});
}