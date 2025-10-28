class ApiConfig {
  static const String openRouterApiKey = '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';
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String defaultModel = 'anthropic/claude-3-haiku';
  static const int maxTokens = 2000;
  static const double temperature = 0.7;
  static const int requestTimeoutSeconds = 30;
  
  static const Map<String, String> modelOptions = {
    'claude-3-haiku': 'anthropic/claude-3-haiku',
    'gpt-3.5-turbo': 'openai/gpt-3.5-turbo',
    'gpt-4o-mini': 'openai/gpt-4o-mini',
  };
  
  static Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer $openRouterApiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://recipe-meal-planner.app',
      'X-Title': 'Recipe Meal Planner',
    };
  }
}

