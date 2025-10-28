class ApiConfig {
  // OpenRouter API key for AI recipe suggestions
  static const String openRouterApiKey = 'Your OpenRouter API key here';
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

