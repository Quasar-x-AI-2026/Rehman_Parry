# Calm Compass - Mental Health & Preventive Wellness App

A Flutter mobile application designed to support mental health and preventive wellness through daily check-ins, AI-powered emotional support, risk monitoring, and wellness insights.

## 🎨 Design Philosophy

Calm Compass uses a clean, calming, and trustworthy UI suitable for healthcare applications:

- **Color Palette**: Calm blues, soft greens, and neutral tones
- **Typography**: High contrast, accessible fonts
- **Components**: Flutter Material 3 design system
- **User Experience**: Minimal, non-overwhelming interfaces

## 🌈 Color System

```
Primary (Calm Teal-Blue): #4A90A4
Secondary (Soft Green): #7FB685
Background: #F8FAFB
Surface: #FFFFFF
Error/High Risk: #E07A5F (Muted Coral)
Warning/Medium Risk: #F4A259 (Soft Amber)
Success/Low Risk: #81B29A (Sage Green)
Text Primary: #2D3748 (Charcoal)
Text Secondary: #718096 (Gray)
```

## 📱 Features

### 1. Daily Check-In Page
Collect structured wellness data for preventive health monitoring:
- Sleep hours tracker (0-12 hours slider)
- Stress level (1-5 scale)
- Mood selector (emoji-based, 5 options)
- Energy level (1-5 scale)
- Workload assessment (Low/Medium/High)
- Optional text notes with voice input button
- Progress indicator showing completion
- Validation and submission

**Key Widgets**:
- `Slider` for numeric inputs
- `SegmentedButton` for workload selection
- `Card` widgets for section organization
- `LinearProgressIndicator` for completion tracking

### 2. AI Mental Health Chatbot Page
Empathetic, non-diagnostic mental health support:
- Chat-style interface with message bubbles
- Text input with send button
- Microphone button for voice input (UI ready)
- Prominent disclaimer banner
- Privacy mode indicator
- System messages with supportive tone
- Timestamp for each message

**Key Widgets**:
- `ListView.builder` for message display
- `TextField` for message input
- `MaterialBanner` for disclaimer
- Custom `_MessageBubble` widget

### 3. Risk Monitoring Page
Clear visualization of burnout and stress risk:
- Large circular risk indicator (Low/Medium/High)
- Color-coded status (green/amber/coral)
- Plain-language risk explanation
- Trend analysis (up/down/steady)
- Mini chart showing weekly pattern
- Expandable "What can I do?" section with actionable tips
- Crisis resources card with hotline information

**Key Widgets**:
- `Container` with gradient for hero card
- `Icon` for status indicators
- Custom `_ActionItem` widget for recommendations
- `InkWell` for expandable sections

### 4. Wellness Dashboard Page
Visualize trends and promote self-awareness:
- Summary statistics cards (sleep, mood averages)
- Sleep trend line chart
- Dual-line chart for stress & mood
- Energy level bar chart
- Weekly/Monthly toggle
- Wellness score calculation
- Insight boxes with recommendations
- Access to settings/privacy controls

**Key Widgets**:
- `CustomPaint` for charts
- `SegmentedButton` for period selection
- Custom painters: `_LineChartPainter`, `_DualLineChartPainter`
- `_BarChart` widget

### 5. Privacy & Settings Page
User control over data usage:
- Toggle chatbot analysis on/off
- Toggle voice input permissions
- Delete all data option
- App information (version, privacy policy, terms)

**Key Widgets**:
- `SwitchListTile` for toggles
- `ListTile` for menu items
- `AlertDialog` for confirmations

## 🏗️ Project Structure

```
calm_compass/
├── lib/
│   ├── main.dart                          # App entry point & navigation
│   └── pages/
│       ├── daily_checkin_page.dart        # Daily wellness check-in
│       ├── chatbot_page.dart              # AI mental health chat
│       ├── risk_monitoring_page.dart      # Burnout risk display
│       ├── wellness_dashboard_page.dart   # Trends & insights
│       └── settings_page.dart             # Privacy controls
├── pubspec.yaml                           # Dependencies
└── README.md                              # This file
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio IDE

### Installation

1. **Clone or create the project**:
```bash
mkdir calm_compass
cd calm_compass
```

2. **Copy all the provided files into the project structure**

3. **Install dependencies**:
```bash
flutter pub get
```

4. **Run the app**:
```bash
# For Android emulator/device
flutter run

# For iOS simulator (macOS only)
flutter run -d ios

# For web (development)
flutter run -d chrome
```

## 🎯 Navigation Structure

The app uses a `BottomNavigationBar` with 4 main tabs:

1. **Check-In** (Home) - Calendar icon
2. **Chat** - Chat bubble icon  
3. **Risk** - Shield icon
4. **Insights** - Graph icon

Users can access Settings from the Wellness Dashboard page (gear icon in AppBar).

## 🔧 Key Implementation Details

### Theme Configuration
- Material 3 design system
- Custom color scheme from seed color
- Consistent card styling (12px border radius, elevation 2)
- Slider theme with custom colors
- Button styling for 52px height CTAs

### State Management
- Uses `StatefulWidget` for local state
- Form data stored in page-level state
- Simulated data for demo purposes

### Responsive Design
- Uses `MediaQuery` for responsive sizing
- Flexible layouts with `Expanded` and `Flexible`
- Scrollable content with `SingleChildScrollView`
- Safe areas for notch handling

### Accessibility
- High contrast ratios (WCAG AA compliant)
- Semantic labels on interactive elements
- Readable font sizes (minimum 12px)
- Color not used as sole indicator

## 🎨 Design Patterns Used

### Cards with Icons
Each major section uses cards with colored icon badges:
```dart
Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Icon(icon, color: color),
)
```

### Sliders with Labels
Sliders show current value and min/max labels:
```dart
Column(
  children: [
    Text(value),
    Slider(...),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('Min'), Text('Max')],
    ),
  ],
)
```

### Message Bubbles
Chat uses aligned containers with rounded corners:
```dart
Align(
  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
    decoration: BoxDecoration(
      color: bubbleColor,
      borderRadius: BorderRadius.only(...),
    ),
  ),
)
```

## 📊 Data Models

### Message Model (Chat)
```dart
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
}
```

### Risk Level Enum
```dart
enum RiskLevel { low, medium, high }
```

## 🎭 Demo Features

The current implementation includes:

- **Simulated AI responses** - Keyword-based chatbot responses
- **Mock wellness data** - Hardcoded charts and trends
- **Form validation** - Progress tracking on check-in
- **Interactive UI** - All buttons and interactions work
- **Dialog modals** - Info dialogs, confirmations, alerts

## 🚧 Production Considerations

To make this production-ready, you would need to:

1. **Backend Integration**
   - API endpoints for data persistence
   - User authentication
   - Real-time chat with AI model
   - Analytics and risk calculation engine

2. **Data Persistence**
   - Local storage (SharedPreferences, Hive, SQLite)
   - Cloud sync
   - Offline support

3. **AI Integration**
   - Connect to actual LLM API (OpenAI, Claude, etc.)
   - Implement proper prompt engineering
   - Add conversation context management

4. **Voice Features**
   - Speech-to-text integration
   - Audio recording permissions
   - Voice activity detection

5. **Charts & Visualization**
   - Use production charting library (fl_chart, charts_flutter)
   - Real data aggregation
   - Export capabilities

6. **Security & Compliance**
   - HIPAA compliance (if in US)
   - End-to-end encryption
   - Secure authentication
   - Data anonymization

7. **Testing**
   - Unit tests for business logic
   - Widget tests for UI
   - Integration tests
   - Accessibility testing

## 🎨 Customization

### Changing Colors
Modify the color scheme in `main.dart`:
```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFF4A90A4), // Change this
  ...
)
```

### Adding New Check-In Fields
In `daily_checkin_page.dart`, add new `Card` widgets following the pattern:
```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Field Label'),
        // Input widget here
      ],
    ),
  ),
)
```

### Customizing Risk Thresholds
Modify the `_getRiskExplanation()` method in `risk_monitoring_page.dart`.

## 📝 License

This is a hackathon project and demonstration app. Adapt as needed for your use case.

## 🤝 Contributing

This is a reference implementation. Feel free to fork and customize for your needs.

## 📞 Support & Resources

- Flutter Documentation: https://flutter.dev/docs
- Material Design 3: https://m3.material.io
- Mental Health Resources: 988 (US), findahelpline.com (International)

## ⚠️ Disclaimer

This app is a demonstration and should not be used as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of qualified health providers with questions regarding medical conditions.

---

**Built with Flutter 💙 for Mental Health Awareness**
