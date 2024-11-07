import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun CategorySection(
    categories: List<String>,
    onCategorySelected: (String) -> Unit
) {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        contentPadding = PaddingValues(vertical = 8.dp)
    ) {
        items(categories) { category ->
            Button(onClick = { onCategorySelected(category) }) {
                Text(category)
            }
        }
    }
}

@Composable
fun ChatMessages(
    messages: List<ChatMessage>,
    expandedImageUrl: String?,
    onImageClick: (String) -> Unit
) {
    LazyColumn(
        modifier = Modifier.weight(1f),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        items(messages) { message ->
            ChatMessageItem(
                message = message,
                isExpanded = message.imageUrl == expandedImageUrl,
                onImageClick = onImageClick
            )
        }
    }
}

@Composable
fun ChatInput(
    value: String,
    onValueChange: (String) -> Unit,
    onSend: () -> Unit,
    onVoiceInput: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        TextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier.weight(1f)
        )

        IconButton(onClick = onSend) {
            Icon(Icons.Default.Send, contentDescription = "Send")
        }

        IconButton(onClick = onVoiceInput) {
            Icon(Icons.Default.Mic, contentDescription = "Voice Input")
        }
    }
}
