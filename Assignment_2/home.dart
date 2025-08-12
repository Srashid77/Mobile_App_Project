import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/custom_background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int currentPage = 0;

  final List<Map<String, dynamic>> forecastData = [
    {
      'temp': '19°C',
      'icon': Icons.thunderstorm,
      'day': 'Mon',
      'hasWarning': false,
    },
    {'temp': '18°C', 'icon': Icons.cloud, 'day': 'Tue', 'hasWarning': false},
    {'temp': '18°C', 'icon': Icons.cloud, 'day': 'Wed', 'hasWarning': false},
    {
      'temp': '19°C',
      'icon': Icons.thunderstorm,
      'day': 'Thu',
      'hasWarning': false,
    },
    {'temp': '20°C', 'icon': Icons.wb_sunny, 'day': 'Fri', 'hasWarning': false},
    {'temp': '17°C', 'icon': Icons.grain, 'day': 'Sat', 'hasWarning': false},
    {'temp': '21°C', 'icon': Icons.wb_sunny, 'day': 'Sun', 'hasWarning': false},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _pageController = PageController(viewportFraction: 0.25, initialPage: 0);

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildHeader(),
                  SizedBox(height: 30),
                  _buildCurrentWeather(),
                  SizedBox(height: 30),
                  _buildForecastSection(),
                  SizedBox(height: 30),
                  _buildAirQualitySection(),
                  SizedBox(height: 30),
                  _buildBottomInfo(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
          ),
          child: Icon(Icons.menu, color: Colors.white, size: 24),
        ),
        Column(
          children: [
            Text(
              '1:41',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Icon(Icons.wifi, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Icon(Icons.battery_full, color: Colors.white, size: 18),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    return Center(
      child: Column(
        children: [
          Text(
            'North America',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Max: 24°  Min:18°',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection() {
    return Column(
      children: [
        Center(
          child: Text(
            '7-Days Forecasts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 140,
          child: Stack(
            children: [
              // Main content with padding for arrows
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildForecastCard(
                        forecastData[currentPage]['temp'],
                        forecastData[currentPage]['icon'],
                        forecastData[currentPage]['day'],
                        forecastData[currentPage]['hasWarning'],
                      ),
                      _buildForecastCard(
                        forecastData[currentPage + 1]['temp'],
                        forecastData[currentPage + 1]['icon'],
                        forecastData[currentPage + 1]['day'],
                        forecastData[currentPage + 1]['hasWarning'],
                      ),
                      _buildForecastCard(
                        forecastData[currentPage + 2]['temp'],
                        forecastData[currentPage + 2]['icon'],
                        forecastData[currentPage + 2]['day'],
                        forecastData[currentPage + 2]['hasWarning'],
                      ),
                      _buildForecastCard(
                        forecastData[currentPage + 3]['temp'],
                        forecastData[currentPage + 3]['icon'],
                        forecastData[currentPage + 3]['day'],
                        forecastData[currentPage + 3]['hasWarning'],
                      ),
                    ],
                  ),
                ),
              ),

              // Left arrow - always visible but disabled when at start
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: currentPage > 0
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentPage > 0
                            ? Colors.white.withOpacity(0.25)
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentPage > 0
                              ? Colors.white.withOpacity(0.4)
                              : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: currentPage > 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: currentPage > 0
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),

              // Right arrow - always visible but disabled when at end
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: currentPage < forecastData.length - 4
                        ? () {
                            setState(() {
                              currentPage++;
                            });
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentPage < forecastData.length - 4
                            ? Colors.white.withOpacity(0.25)
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentPage < forecastData.length - 4
                              ? Colors.white.withOpacity(0.4)
                              : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: currentPage < forecastData.length - 4
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: currentPage < forecastData.length - 4
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(
    String temp,
    IconData icon,
    String day,
    bool hasWarning,
  ) {
    return Container(
      width: 70,
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasWarning)
            Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.warning, color: Colors.yellow, size: 12),
            ),
          Text(
            temp,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Icon(icon, color: Colors.white, size: 22),
          SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualitySection() {
    return WeatherCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.air, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'AIR QUALITY',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '3-Low Health Risk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Handle "See more" tap
              _showAirQualityDetails();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'See more',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.8),
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAirQualityDetails() {
    // Show a dialog or navigate to air quality details page
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          title: Row(
            children: [
              Icon(Icons.air, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Air Quality Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Air Quality: 3 - Low Health Risk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Air quality is acceptable for most people. Sensitive individuals should consider limiting prolonged outdoor exertion.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PM2.5: 12 μg/m³',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'PM10: 18 μg/m³',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'O3: 45 μg/m³',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'GOOD',
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomInfo() {
    return Row(
      children: [
        Expanded(
          child: WeatherCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'SUNRISE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '5:28 AM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sunset: 7:25 PM',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: WeatherCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'UV INDEX',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Moderate',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Assuming WeatherCard is defined in your widgets/custom_background.dart or elsewhere
class WeatherCard extends StatelessWidget {
  final Widget child;

  const WeatherCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
