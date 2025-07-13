class SolutionStep {
  final int stepNumber;
  final String description;

  SolutionStep({required this.stepNumber, required this.description});

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'description': description,
  };

  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      stepNumber: json['stepNumber'],
      description: json['description'],
    );
  }
}
