/// Набір готових аватарів із фіксованими HTTPS-посиланнями.
/// Завантаження власних файлів у сховище буде у ЛР-6.
abstract final class AvatarPresets {
  static const String _base = 'https://api.dicebear.com/9.x/adventurer/png';

  static const List<String> urls = [
    '$_base?seed=Meeple&size=256',
    '$_base?seed=Dice&size=256',
    '$_base?seed=Pawn&size=256',
    '$_base?seed=Rook&size=256',
    '$_base?seed=Joker&size=256',
    '$_base?seed=Token&size=256',
  ];
}
