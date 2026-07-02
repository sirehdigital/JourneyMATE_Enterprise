class KnowledgeState {
  const KnowledgeState({
    this.isLoading = false,
    this.graphLoaded = false,
    this.selectedNodeId,
    this.searchQuery = '',
    this.errorMessage,
  });

  final bool isLoading;
  final bool graphLoaded;
  final String? selectedNodeId;
  final String searchQuery;
  final String? errorMessage;

  KnowledgeState copyWith({
    bool? isLoading,
    bool? graphLoaded,
    String? selectedNodeId,
    String? searchQuery,
    String? errorMessage,
  }) {
    return KnowledgeState(
      isLoading: isLoading ?? this.isLoading,
      graphLoaded: graphLoaded ?? this.graphLoaded,
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
