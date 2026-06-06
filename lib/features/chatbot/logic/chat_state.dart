part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, ready, sending, error, limitReached }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<AIChatMessage> messages;
  final String? errorMessage;
  final String? pendingUserMessage;
  final bool isPendingMessageError;
  final UiComponent? currentUi;
  final UiComponent? previousUi;
  final Map<String, dynamic>? currentStructuredReport;
  final String? currentRiskLevel;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.pendingUserMessage,
    this.isPendingMessageError = false,
    this.currentUi,
    this.previousUi,
    this.currentStructuredReport,
    this.currentRiskLevel,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<AIChatMessage>? messages,
    String? errorMessage,
    String? pendingUserMessage,
    bool clearPendingUserMessage = false,
    bool? isPendingMessageError,
    UiComponent? currentUi,
    bool clearCurrentUi = false,
    UiComponent? previousUi,
    bool clearPreviousUi = false,
    Map<String, dynamic>? currentStructuredReport,
    String? currentRiskLevel,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingUserMessage: clearPendingUserMessage ? null : (pendingUserMessage ?? this.pendingUserMessage),
      isPendingMessageError: isPendingMessageError ?? this.isPendingMessageError,
      currentUi: clearCurrentUi ? null : (currentUi ?? this.currentUi),
      previousUi: clearPreviousUi ? null : (previousUi ?? this.previousUi),
      currentStructuredReport: currentStructuredReport ?? this.currentStructuredReport,
      currentRiskLevel: currentRiskLevel ?? this.currentRiskLevel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        pendingUserMessage,
        isPendingMessageError,
        currentUi,
        previousUi,
        currentStructuredReport,
        currentRiskLevel,
      ];
}
