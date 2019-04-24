enum Category { Other, Road, Vandal, Transport, Litter, Lights }

final categoryNames = [
  "Другое",
  "Дороги",
  "Вандализм",
  "Транспорт",
  "Мусор",
  "Освещение",
];

String intToCategory(int index) =>
    categoryNames[index ?? 0] ?? categoryNames[0];
