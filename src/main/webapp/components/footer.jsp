<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="bg-dark text-light pt-5 pb-3 mt-5">
    <div class="container">
        <div class="row">
            <div class="col-md-6 mb-3">
                <h5 class="text-uppercase text-warning fw-bold mb-3"><i class="fas fa-leaf me-2"></i>Fresh Food Store</h5>
                <p class="small text-secondary">Hệ thống cửa hàng cung cấp thực phẩm sạch, thịt mát chuẩn Châu Âu đầu tiên tại Việt Nam. Cam kết 100% tươi ngon mỗi ngày.</p>
            </div>
            <div class="col-md-6 mb-3">
                <h6 class="text-uppercase fw-bold mb-3">Kết nối với chúng tôi</h6>
                <p class="small text-secondary"><i class="fas fa-map-marker-alt me-2"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
                <p class="small text-secondary"><i class="fas fa-envelope me-2"></i> cskh@freshfood.vn</p>
            </div>
        </div>
        <hr class="border-secondary">
        <div class="text-center small text-secondary">
            &copy; 2026 Fresh Food Store. All rights reserved.
        </div>
    </div>
</footer>

<!-- Chatbot UI Widget -->
<style>
    .chatbot-toggler {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        background-color: #10B981;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        z-index: 1000;
        transition: transform 0.3s;
    }
    .chatbot-toggler:hover {
        transform: scale(1.1);
    }
    .chatbot-window {
        position: fixed;
        bottom: 100px;
        right: 30px;
        width: 350px;
        max-width: 90vw;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        z-index: 1000;
        display: none;
        flex-direction: column;
        overflow: hidden;
    }
    .chatbot-header {
        background: #10B981;
        color: white;
        padding: 15px;
        font-weight: bold;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .chatbot-body {
        height: 350px;
        padding: 15px;
        overflow-y: auto;
        background: #f8f9fa;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .chat-msg {
        max-width: 80%;
        padding: 10px 14px;
        border-radius: 15px;
        font-size: 0.9rem;
        line-height: 1.4;
        white-space: pre-wrap;
    }
    .chat-msg.bot {
        background: #e9ecef;
        color: #212529;
        align-self: flex-start;
        border-bottom-left-radius: 2px;
    }
    .chat-msg.user {
        background: #10B981;
        color: white;
        align-self: flex-end;
        border-bottom-right-radius: 2px;
    }
    .chat-chips {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 5px;
    }
    .chat-chip {
        background: #fff;
        border: 1px solid #10B981;
        color: #10B981;
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 0.8rem;
        cursor: pointer;
        transition: all 0.2s;
    }
    .chat-chip:hover {
        background: #10B981;
        color: white;
    }
    .chatbot-footer {
        padding: 10px;
        border-top: 1px solid #eee;
        display: flex;
        background: #fff;
    }
    .chatbot-input {
        flex: 1;
        border: 1px solid #ddd;
        padding: 8px 12px;
        border-radius: 20px;
        outline: none;
    }
    .chatbot-send {
        background: #10B981;
        color: white;
        border: none;
        width: 40px;
        border-radius: 50%;
        margin-left: 10px;
        cursor: pointer;
    }
</style>

<div class="chatbot-toggler" onclick="toggleChat()" id="chatToggler">
    <i class="fas fa-comment-dots fs-3"></i>
</div>

<div class="chatbot-window" id="chatWindow">
    <div class="chatbot-header">
        <span><i class="fas fa-robot me-2"></i> Trợ lý FFS</span>
        <i class="fas fa-times" style="cursor:pointer;" onclick="toggleChat()"></i>
    </div>
    <div class="chatbot-body" id="chatBody">
        <!-- Messages will appear here -->
    </div>
    <div class="chatbot-footer">
        <input type="text" id="chatInput" class="chatbot-input" placeholder="Tôi muốn tìm..." onkeypress="handleChatKey(event)">
        <button class="chatbot-send" onclick="sendChatMessage()"><i class="fas fa-paper-plane"></i></button>
    </div>
</div>

<script>
    let chatOpened = false;
    let initialGreetingDone = false;

    function toggleChat() {
        const win = document.getElementById('chatWindow');
        const toggler = document.getElementById('chatToggler');
        if (win.style.display === 'flex') {
            win.style.display = 'none';
            toggler.innerHTML = '<i class="fas fa-comment-dots fs-3"></i>';
        } else {
            win.style.display = 'flex';
            toggler.innerHTML = '<i class="fas fa-times fs-3"></i>';
            if (!initialGreetingDone) {
                showBotMessage("Xin chào! 👋 Mình là trợ lý ảo của Fresh Food Store. Bạn cần tìm hiểu thông tin gì hôm nay?", true);
                initialGreetingDone = true;
            }
        }
    }

    function showBotMessage(text, showChips = false) {
        const body = document.getElementById('chatBody');
        
        // Add text message
        const msgDiv = document.createElement('div');
        msgDiv.className = 'chat-msg bot';
        
        // Parse basic markdown like **bold** in bot response
        let formattedText = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        msgDiv.innerHTML = formattedText;
        body.appendChild(msgDiv);

        if (showChips) {
            const chipsDiv = document.createElement('div');
            chipsDiv.className = 'chat-chips bot';
            chipsDiv.innerHTML = `
                <div class="chat-chip" onclick="sendChipMessage('Xem danh mục')">Xem danh mục</div>
                <div class="chat-chip" onclick="sendChipMessage('Liên hệ')">Liên hệ</div>
                <div class="chat-chip" onclick="sendChipMessage('Giá thịt heo')">Giá thịt heo</div>
            `;
            body.appendChild(chipsDiv);
        }

        body.scrollTop = body.scrollHeight;
    }

    function showUserMessage(text) {
        const body = document.getElementById('chatBody');
        const msgDiv = document.createElement('div');
        msgDiv.className = 'chat-msg user';
        msgDiv.textContent = text;
        body.appendChild(msgDiv);
        body.scrollTop = body.scrollHeight;
    }

    function sendChipMessage(text) {
        processMessage(text);
    }

    function handleChatKey(e) {
        if (e.key === 'Enter') {
            sendChatMessage();
        }
    }

    function sendChatMessage() {
        const input = document.getElementById('chatInput');
        const text = input.value.trim();
        if (!text) return;
        input.value = '';
        processMessage(text);
    }

    function processMessage(text) {
        showUserMessage(text);
        
        // Show loading indicator
        const body = document.getElementById('chatBody');
        const loadingDiv = document.createElement('div');
        loadingDiv.className = 'chat-msg bot loading';
        loadingDiv.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i> Đang tìm...';
        body.appendChild(loadingDiv);
        body.scrollTop = body.scrollHeight;

        fetch('${pageContext.request.contextPath}/api/chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: text })
        })
        .then(res => res.json())
        .then(data => {
            // Remove loading
            body.removeChild(loadingDiv);
            showBotMessage(data.reply);
        })
        .catch(err => {
            body.removeChild(loadingDiv);
            showBotMessage("Hệ thống mất kết nối. Vui lòng thử lại sau!");
            console.error(err);
        });
    }
</script>