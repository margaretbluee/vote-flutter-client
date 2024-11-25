class VotingData {
  static final VotingData _instance = VotingData._internal();
  factory VotingData() => _instance;

  VotingData._internal();

  String votingQuestion = '';
   int  id = 0;
  final List<String> votingOptions = [];

  int getId(){
    return id;
  }

  void setId(int inp_id){
   id=inp_id;
  }

  void setVotingQuestion(String question) {
    votingQuestion = question;
  }

  void addOption(String option) {
    votingOptions.add(option);
  }

  void removeOption(int index) {
    votingOptions.removeAt(index);
  }

  void clearData() {
    votingQuestion = '';
    votingOptions.clear();
  }
}
