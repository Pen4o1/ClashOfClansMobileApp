# 🏰 Clash of Clans Mobile App

A comprehensive mobile application for Clash of Clans and Brawl Stars players, built with Flutter and Node.js.

## 📱 Features

### 🎮 Game Integration
- **Clash of Clans Player Search**: Look up player statistics, achievements, and clan information
- **Brawl Stars Player Search**: Find player profiles, trophies, and brawler data
- **Real-time Data**: Live data from official Supercell APIs
- **Player Details**: Comprehensive player information and statistics

### 🎨 User Interface
- **Modern Design**: Clean, intuitive Flutter UI
- **Cross-platform**: Works on iOS and Android
- **Responsive Layout**: Optimized for different screen sizes
- **Dark/Light Theme**: User preference support

### 🔧 Backend Services
- **RESTful API**: Node.js/Express backend
- **API Integration**: Supercell API integration for both games
- **Error Handling**: Robust error management and user feedback
- **Testing**: Comprehensive test suite with Jest

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Node.js 20+
- npm or yarn
- Supercell API keys for Clash of Clans and Brawl Stars

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ClashOfClansMobileApp
   ```

2. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   ```

3. **Environment Configuration**
   ```bash
   cp .env.example .env
   ```
   
   Add your API keys to `.env`:
   ```env
   COC_API_KEY=Bearer your_clash_of_clans_api_key
   BRAWL_STARS_API_KEY=Bearer your_brawl_stars_api_key
   ```

4. **Run the backend server**
   ```bash
   npm start
   ```
   
   The API will be available at `http://localhost:3000`
   or alternatively use ngrok to test on a real device

### Frontend Setup

1. **Install Flutter dependencies**
   ```bash
   cd frontend
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Frontend Tests
```bash
cd frontend
flutter test
```

## 📚 API Documentation

### Clash of Clans Endpoints

#### Get Player Information
```http
GET /api/coc/player/{tag}
```

**Parameters:**
- `tag` (string): Player tag (without #)

**Response:**
```json
{
  "tag": "#P0LYGON",
  "name": "PlayerName",
  "townHallLevel": 14,
  "expLevel": 200,
  "trophies": 5000,
  "bestTrophies": 5500,
  "warStars": 1000,
  "attackWins": 500,
  "defenseWins": 300,
  "clan": {
    "tag": "#CLAN123",
    "name": "ClanName",
    "level": 20
  }
}
```

### Brawl Stars Endpoints

#### Get Player Information
```http
GET /api/braw/player/{tag}
```

**Parameters:**
- `tag` (string): Player tag (without #)

**Response:**
```json
{
  "tag": "#P0LYGON",
  "name": "PlayerName",
  "trophies": 25000,
  "highestTrophies": 30000,
  "powerPlayPoints": 1000,
  "highestPowerPlayPoints": 1200,
  "expLevel": 200,
  "expPoints": 50000,
  "isQualifiedFromChampionshipChallenge": true,
  "3vs3Victories": 1000,
  "soloVictories": 500,
  "duoVictories": 300,
  "bestRoboRumbleTime": 120,
  "bestTimeAsBigBrawler": 90,
  "club": {
    "tag": "#CLUB123",
    "name": "ClubName"
  }
}
```

## 🏗️ Project Structure

```
ClashOfClansMobileApp/
├── backend/                 # Node.js API server
│   ├── routes/             # API route handlers
│   ├── services/           # External API integrations
│   ├── tests/              # Backend test suite
│   └── server.js           # Server entry point
├── frontend/               # Flutter mobile app
│   ├── lib/
│   │   ├── screens/        # App screens
│   │   ├── services/       # API client services
│   │   ├── widgets/        # Reusable UI components
│   │   └── config/         # App configuration
│   └── pubspec.yaml        # Flutter dependencies
└── .github/workflows/      # CI/CD workflows
```

## 🔧 Development

### Backend Development
- **Framework**: Express.js
- **Testing**: Jest + Supertest
- **API**: Supercell Developer API
- **Database**: Prisma (if needed for future features)

### Frontend Development
- **Framework**: Flutter
- **State Management**: Provider/Riverpod
- **HTTP Client**: Dio
- **UI**: Material Design 3

## 🚀 Deployment

### Backend Deployment
The backend can be deployed to:
- Heroku
- Vercel
- Railway
- AWS/GCP/Azure

### Frontend Deployment
The Flutter app can be:
- Published to App Store/Google Play
- Built for web deployment
- Distributed as APK/IPA files

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- [Supercell](https://supercell.com/) for providing the game APIs
- [Flutter](https://flutter.dev/) for the amazing cross-platform framework
- [Node.js](https://nodejs.org/) for the backend runtime
- [Express.js](https://expressjs.com/) for the web framework

## 📞 Support

If you encounter any issues or have questions:
- Open an issue on GitHub
- Check the documentation
- Review the test suite for examples

---

**Made with ❤️ for the Clash of Clans and Brawl Stars community** 
