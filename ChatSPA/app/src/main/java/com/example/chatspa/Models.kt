data class ChatMessage(
    val text: String,
    val type: MessageType,
    val imageUrl: String? = null,
    val timestamp: Long = System.currentTimeMillis()
)

enum class MessageType {
    USER,
    SYSTEM,
    BOT
}
