enum class MessageType {
    USER, SYSTEM
}

data class ChatMessage(
    val id: String = java.util.UUID.randomUUID().toString(),
    val text: String,
    val imageUrl: String? = null,
    val type: MessageType = MessageType.USER,
    val timestamp: Long = System.currentTimeMillis()
)
