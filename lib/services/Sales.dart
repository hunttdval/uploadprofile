class Sales {
  final int quantity;
  final String name;
  final String colorVal;
  Sales(this.quantity,this.name,this.colorVal);

  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['quantity'] != null),
        assert(map['name'] != null),
        assert(map['colorVal'] != null),
        quantity = map['quantity'],
        colorVal = map['colorVal'],
        name=map['name'];

  @override
  String toString() => "Record<$quantity:$name:$colorVal>";
}