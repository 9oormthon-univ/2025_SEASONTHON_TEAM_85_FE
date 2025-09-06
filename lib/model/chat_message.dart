// 메시지의 속성을 정의하는 데이터 클래스
class ChatMessage {
  final String text;
  final bool isUserMessage;
  final String? followupQuestion; // 챗봇의 후속 질문 (파란색 링크 텍스트)

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    this.followupQuestion,
  });
}
