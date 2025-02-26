// transaction_model.dart
class Transaction {
  final String name;
  final String date;
  final double amount;
  final bool isPositive;

  Transaction({
    required this.name,
    required this.date,
    required this.amount,
    required this.isPositive,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'],
      date: json['date'],
      amount: json['amount'],
      isPositive: json['isPositive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'amount': amount,
      'isPositive': isPositive,
    };
  }
}