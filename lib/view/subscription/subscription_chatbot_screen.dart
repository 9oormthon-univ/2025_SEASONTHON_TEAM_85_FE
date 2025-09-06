import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/chat_message.dart';

class SubscriptionChatbotScreen extends StatefulWidget {
  const SubscriptionChatbotScreen({super.key});

  @override
  State<SubscriptionChatbotScreen> createState() =>
      _SubscriptionChatbotScreenState();
}

class _SubscriptionChatbotScreenState extends State<SubscriptionChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  // 메시지를 전송하고 챗봇 응답을 시뮬레이션하는 함수
  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
    });

    // 챗봇 응답 시뮬레이션 (1초 후)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text:
                '📜 청약통장을 가입하려고 하시는군요!\n청약통장은 은행 지점이나 모바일 앱에서 쉽게 가입할 수 있어요. 19세 이상이면 누구나 가입 가능해요.',
            isUserMessage: false,
            followupQuestion: '추가적으로 청약상품 추천드릴까요?',
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('청약챗봇'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 채팅 메시지 영역
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState() // 초기 화면
                : _buildMessageList(), // 메시지 목록
          ),
          // 하단 텍스트 입력 영역
          _buildTextComposer(),
        ],
      ),
    );
  }

  // 초기 상태 (메시지가 없을 때)
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        '안녕하세요!\n청약 관련 궁금한 점을 물어보세요',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Color(0xFF2F45B5)),
      ),
    );
  }

  // 메시지 목록
  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      reverse: true, // 리스트를 뒤집어서 새 메시지가 아래에 표시되도록 함
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  // 사용자/챗봇 메시지 버블
  Widget _buildMessageBubble(ChatMessage message) {
    // isUserMessage 값에 따라 정렬과 스타일을 다르게 함
    final isUser = message.isUserMessage;
    final alignment = isUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final color = isUser ? const Color(0xFF2F45B5) : Colors.white;
    final textColor = isUser ? Colors.white : Colors.black;
    final borderRadius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: color, borderRadius: borderRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RichText를 사용해 텍스트의 일부만 다른 스타일 적용
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                    ),
                    children: [
                      TextSpan(text: message.text),
                      if (message.followupQuestion != null) ...[
                        const TextSpan(text: '\n\n'),
                        TextSpan(
                          text: message.followupQuestion,
                          style: const TextStyle(
                            color: Color(0xFF007AFF),
                            fontWeight: FontWeight.bold,
                          ),
                          // recognizer: TapGestureRecognizer()..onTap = () { ... } // 탭 기능 추가
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 하단 텍스트 입력 UI
  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5EA))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF007AFF)),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: '청약 관련 정보를 물어보세요',
                  filled: true,
                  fillColor: const Color(0xFFF0F2F5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
