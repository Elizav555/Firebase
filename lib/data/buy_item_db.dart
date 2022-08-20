class BuyItemDB {
  final String name;
  final bool isPurchased;

  static const _kname = 'name';
  static const _kisPurchased = 'isPurchased';

  BuyItemDB({required this.name, this.isPurchased = false});

  factory BuyItemDB.fromJSON(Map<String, dynamic> json) => BuyItemDB(
      name: json[_kname]! as String, isPurchased: json[_kisPurchased]! as bool);

  Map<String, Object?> toJSON() => {_kname: name, _kisPurchased: isPurchased};
}
