/// Hardcoded-дані замість відповідей сервера (бізнес-логіка буде в наступних ЛР).
abstract final class MockData {
  static const String userName = 'Vova';
  static const String userEmail = 'vova@example.com';
  static const String userInitials = 'VV';

  static const int totalGames = 12;
  static const int totalMatches = 48;

  static const RecentMatch recentMatch = RecentMatch(
    gameTitle: 'Wingspan',
    winnerName: 'Alex',
    winnerScore: 82,
    playersCount: 4,
    datePlayed: 'September 24, 2026',
  );

  static const TopGame topGame = TopGame(
    title: 'Wingspan',
    timesPlayed: 8,
    timesWon: 5,
  );
}

class RecentMatch {
  final String gameTitle;
  final String winnerName;
  final int winnerScore;
  final int playersCount;
  final String datePlayed;

  const RecentMatch({
    required this.gameTitle,
    required this.winnerName,
    required this.winnerScore,
    required this.playersCount,
    required this.datePlayed,
  });
}

class TopGame {
  final String title;
  final int timesPlayed;
  final int timesWon;

  const TopGame({
    required this.title,
    required this.timesPlayed,
    required this.timesWon,
  });
}
