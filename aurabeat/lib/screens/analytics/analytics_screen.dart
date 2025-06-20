// lib/screens/analytics/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/analytics_provider.dart';
import '../../models/analytics_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    final provider = context.read<AnalyticsProvider>();
    await provider.loadAnalyticsSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          'Analytics Dashboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadAnalytics,
            icon: Icon(Icons.refresh, color: AppColors.primaryColor),
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Events'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(provider),
              _buildEventsTab(provider),
              _buildInsightsTab(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(AnalyticsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Stats Cards
          _buildSummaryStatsGrid(provider),
          
          const SizedBox(height: 24),
          
          // Activity Chart
          _buildActivityChart(provider),
          
          const SizedBox(height: 24),
          
          // Top Events
          _buildTopEventsCard(provider),
        ],
      ),
    );
  }

  Widget _buildSummaryStatsGrid(AnalyticsProvider provider) {
   // final summary = provider.loadAnalyticsSummary;
    final summary = provider.summary;
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Events',
          summary?.totalEvents.toString() ?? '0',
          Icons.analytics,
          AppColors.primaryColor,
        ),
        _buildStatCard(
          'Tracks Played',
          summary?.tracksPlayed.toString() ?? '0',
          Icons.play_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Remixes Created',
          summary?.remixesCreated.toString() ?? '0',
          Icons.tune,
          Colors.orange,
        ),
        _buildStatCard(
          'Active Users',
          summary?.uniqueUsers.toString() ?? '0',
          Icons.people,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(AnalyticsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Activity Timeline',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Simple activity visualization
          Container(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = (index * 15 + 30).toDouble();
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.7),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getDayLabel(index),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayLabel(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  Widget _buildTopEventsCard(AnalyticsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Top Events',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Top events list
          ...List.generate(5, (index) {
            final events = [
              {'name': 'Track Played', 'count': 234, 'icon': Icons.play_circle},
              {'name': 'Remix Created', 'count': 89, 'icon': Icons.tune},
              {'name': 'Stems Extracted', 'count': 56, 'icon': Icons.graphic_eq},
              {'name': 'Lyrics Generated', 'count': 34, 'icon': Icons.lyrics},
              {'name': 'AI Track Generated', 'count': 12, 'icon': Icons.auto_awesome},
            ];
            
            final event = events[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      event['icon'] as IconData,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event['name'] as String,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${event['count']}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventsTab(AnalyticsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event filters
          _buildEventFilters(),
          
          const SizedBox(height: 16),
          
          // Events list
          _buildEventsList(provider),
        ],
      ),
    );
  }

  Widget _buildEventFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Events',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('All Events', true),
              _buildFilterChip('Track Played', false),
              _buildFilterChip('Remix Created', false),
              _buildFilterChip('Stems Extracted', false),
              _buildFilterChip('Lyrics Generated', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Handle filter selection
      },
      backgroundColor: AppColors.backgroundColor,
      selectedColor: AppColors.primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryColor : AppColors.textSecondary.withOpacity(0.3),
      ),
    );
  }

  Widget _buildEventsList(AnalyticsProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(10, (index) {
          return _buildEventItem(index);
        }),
      ),
    );
  }

  Widget _buildEventItem(int index) {
    final events = [
      {'type': 'track_played', 'time': '2 minutes ago', 'details': 'Summer Vibes.mp3'},
      {'type': 'remix_created', 'time': '5 minutes ago', 'details': 'Chill Remix'},
      {'type': 'stems_extracted', 'time': '10 minutes ago', 'details': 'Beat Drop.wav'},
      {'type': 'lyrics_generated', 'time': '15 minutes ago', 'details': 'Sunset Song'},
      {'type': 'track_played', 'time': '20 minutes ago', 'details': 'Electronic Dreams.mp3'},
    ];
    
    final event = events[index % events.length];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getEventColor(event['type'] as String).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getEventIcon(event['type'] as String),
              color: _getEventColor(event['type'] as String),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEventTitle(event['type'] as String),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['details'] as String,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event['time'] as String,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType) {
      case 'track_played':
        return Icons.play_circle;
      case 'remix_created':
        return Icons.tune;
      case 'stems_extracted':
        return Icons.graphic_eq;
      case 'lyrics_generated':
        return Icons.lyrics;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(String eventType) {
    switch (eventType) {
      case 'track_played':
        return Colors.green;
      case 'remix_created':
        return Colors.orange;
      case 'stems_extracted':
        return Colors.blue;
      case 'lyrics_generated':
        return Colors.purple;
      default:
        return AppColors.primaryColor;
    }
  }

  String _getEventTitle(String eventType) {
    switch (eventType) {
      case 'track_played':
        return 'Track Played';
      case 'remix_created':
        return 'Remix Created';
      case 'stems_extracted':
        return 'Stems Extracted';
      case 'lyrics_generated':
        return 'Lyrics Generated';
      default:
        return 'Event';
    }
  }

  Widget _buildInsightsTab(AnalyticsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usage insights
          _buildUsageInsights(),
          
          const SizedBox(height: 24),
          
          // Performance metrics
          _buildPerformanceMetrics(),
          
          const SizedBox(height: 24),
          
          // Recommendations
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildUsageInsights() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Usage Insights',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildInsightItem(
            'Peak Usage Time',
            '2:00 PM - 4:00 PM',
            Icons.access_time,
            'Most activity occurs during afternoon hours',
          ),
          
          _buildInsightItem(
            'Most Popular Feature',
            'Track Remixing',
            Icons.tune,
            '65% of users create remixes weekly',
          ),
          
          _buildInsightItem(
            'Average Session',
            '24 minutes',
            Icons.timer,
            'Users spend quality time creating music',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, IconData icon, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Performance Metrics',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Avg Processing Time', '2.3s', Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard('Success Rate', '98.7%', Colors.green),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('API Response Time', '150ms', Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard('Error Rate', '0.3%', Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildRecommendationItem(
            'Optimize Peak Hours',
            'Consider server scaling during 2-4 PM peak usage',
            Icons.trending_up,
            Colors.blue,
          ),
          
          _buildRecommendationItem(
            'Feature Promotion',
            'Promote AI generation feature to increase engagement',
            Icons.auto_awesome,
            Colors.purple,
          ),
          
          _buildRecommendationItem(
            'User Retention',
            'Send notifications to users inactive for 7+ days',
            Icons.notifications,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}