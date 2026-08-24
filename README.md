# Trading App 021

A Flutter trading app with live mock market data, watchlists, holdings, and simulated order execution.

## Stack

* Flutter (stable channel)
* BLoC / Cubit (`flutter_bloc`)
* GoRouter
* `flutter_screenutil`
* `shared_preferences`
* `intl`

## Run Instructions

```markdown
No backend setup needed — the app uses an in-memory mock market feed.
```
```bash
flutter pub get
flutter run
```

## Features

* **Watchlist** — Create multiple watchlists, add, remove, and reorder stocks, view live prices, and tap stocks to trade.
* **Market Overview** — View 10 stocks with live price ticks and green/red price-change animations.
* **Buy/Sell Ticket** — Live LTP, quantity validation, balance and quantity checks, and order confirmation.
* **Holdings** — Live P&L, sortable holdings, aggregate summary, and empty state.

## Architecture

```text
lib/
├── core/          # Theme, constants, extensions
├── data/          # Models, mock feed, repositories
├── presentation/  # BLoCs, screens, widgets
├── router/        # GoRouter
└── di/            # Dependency injection
```

## Notes

* Prices are stored as integer paise (`1 = 100 paise`) to avoid floating-point precision issues.
* A single mock market feed broadcasts price updates to all screens through a `Stream`.
* All relevant data persists across app restarts.
* Uses 10 stocks: RELIANCE, TCS, INFY, HDFCBANK, ICICIBANK, SBIN, ITC, LT, BHARTIARTL, AXISBANK

## Video

[Watch the app demo](https://drive.google.com/file/d/1EUAfrjwEfgrsZjpgUtQZE-v1Z-HurehP/view?usp=sharing)
