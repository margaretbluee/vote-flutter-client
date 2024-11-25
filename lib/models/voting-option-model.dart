class VotingOption {
  final int optionId;
  final String optionText;
  final int voteCount;

  VotingOption({required this.optionId, required this.optionText, required this.voteCount});

  factory VotingOption.fromJson(Map<String, dynamic> json) {
    return VotingOption(
      optionId: json['optionId'],
      optionText: json['optionText'],
      voteCount: json['voteCount'],
    );
  }
}
