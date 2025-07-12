function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // /api/で始まるパスから/api/を削除
    if (uri.startsWith('/api/')) {
        request.uri = uri.substring(4); // '/api/'を削除
        // 削除後にルートパスになった場合は/healthにリダイレクト
        if (request.uri === '' || request.uri === '/') {
            request.uri = '/health';
        }
    }
    
    return request;
}