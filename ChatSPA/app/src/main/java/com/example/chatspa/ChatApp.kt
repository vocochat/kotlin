import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun ChatApp() {
    var messages by remember { mutableStateOf(listOf<ChatMessage>()) }
    var currentInput by remember { mutableStateOf("") }
    var expandedImageUrl by remember { mutableStateOf<String?>(null) }

    MaterialTheme {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            CategorySection(
                categories = listOf("General", "Support", "FAQ", "Products"),
                onCategorySelected = { category ->
                    messages = messages + ChatMessage(
                        text = "Selected category: $category",
                        type = MessageType.SYSTEM
                    )
                }
            )

            ChatMessages(
                messages = messages,
                expandedImageUrl = expandedImageUrl,
                onImageClick = { url ->
                    expandedImageUrl = if (expandedImageUrl == url) null else url
                }
            )

            ChatInput(
                value = currentInput,
                onValueChange = { currentInput = it },
                onSend = {
                    if (currentInput.isNotEmpty()) {
                        messages = messages + ChatMessage(
                            text = currentInput,
                            type = MessageType.USER
                        )
                        currentInput = ""
                    }
                },
                onVoiceInput = {
                    // Implement voice input logic
                }
            )
        }
    }
}
