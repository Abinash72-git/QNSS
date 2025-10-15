import 'package:flutter/material.dart';
import 'package:soapy/util/style.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/dottedLine.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Dynamic job statuses based on current date
  late Map<DateTime, JobStatus> _jobStatuses;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initializeJobStatuses();
  }

  void _initializeJobStatuses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _jobStatuses = {};

    // Generate job statuses dynamically with randomization
    // Jobs from 15 days ago to 10 days in the future
    for (int i = -15; i <= 10; i++) {
      final date = today.add(Duration(days: i));
      
      // Use date-based seed for consistent but pseudo-random results
      final seed = date.day + date.month * 31 + date.year * 372;
      final random = (seed * 1103515245 + 12345) % 100; // Simple pseudo-random
      
      if (i < -5) {
        // Past jobs (more than 5 days ago)
        if (random % 4 == 0) {
          // 25% chance - Missed (forgot to complete)
          _jobStatuses[date] = JobStatus.missed;
        } else if (random % 3 != 0) {
          // ~66% chance - Finished
          _jobStatuses[date] = JobStatus.finished;
        }
        // ~9% no job scheduled
      } else if (i >= -5 && i < 0) {
        // Recent past jobs (last 5 days)
        if (random % 5 == 0) {
          // 20% chance - Finished (completed late)
          _jobStatuses[date] = JobStatus.finished;
        } else if (random % 2 == 0) {
          // 40% chance - Missed
          _jobStatuses[date] = JobStatus.missed;
        }
        // 40% no job scheduled
      } else if (i == 0) {
        // Today - Current Job (always have a job today)
        _jobStatuses[date] = JobStatus.currentJob;
      } else if (i > 0 && i <= 8) {
        // Next 8 days - Yet to Start
        if (random % 3 != 0) {
          // ~66% chance - Yet to Start
          _jobStatuses[date] = JobStatus.yetToStart;
        }
        // ~33% no job scheduled
      }
      // Days beyond 8 days in future have fewer jobs
    }
  }

  Color _getJobStatusColor(DateTime day) {
    final status = _jobStatuses[DateTime(day.year, day.month, day.day)];
    switch (status) {
      case JobStatus.yetToStart:
        return Colors.green;
      case JobStatus.finished:
        return Colors.grey;
      case JobStatus.missed:
        return Colors.red;
      case JobStatus.currentJob:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  Widget _buildJobDetails(DateTime day) {
    final status = _jobStatuses[DateTime(day.year, day.month, day.day)];
    if (status == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, color: Colors.grey.shade400, size: 28),
            const SizedBox(width: 12),
            Text(
              'No jobs scheduled',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getJobStatusColor(day).withOpacity(0.12),
            _getJobStatusColor(day).withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getJobStatusColor(day).withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getJobStatusColor(day),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(status),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.business, size: 18, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                'ABC Corporation',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textScaler: TextScaler.linear(1),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.location_on, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Building A, Floor 2',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textScaler: TextScaler.linear(1),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.access_time, size: 18, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                '09:00 AM - 05:00 PM',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textScaler: TextScaler.linear(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.yetToStart:
        return 'Yet to Start';
      case JobStatus.finished:
        return 'Finished';
      case JobStatus.missed:
        return 'Missed';
      case JobStatus.currentJob:
        return 'Current Job';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          "Job Calendar",
          style: Styles.textStyleButton(context, color: AppColor.loginText),
          textScaler: TextScaler.linear(1),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Qnss-bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 12,
              //   ),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.1),
                //       blurRadius: 8,
                //       offset: const Offset(0, 2),
                //     ),
                //   ],
                // ),
                // child: Row(
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.arrow_back, color: Colors.black),
                //       onPressed: () => Navigator.pop(context),
                //     ),
                //     const SizedBox(width: 8),
                //     const Text(
                //       'Job Calendar',
                //       style: TextStyle(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //       textScaler: TextScaler.linear(1),
                //     ),
                //   ],
                // ),
              // ),

              DottedLine(
                height: 1,
                color: Colors.white,
                dotRadius: 1,
                spacing: 2,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Status Legend
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColor.loginButton,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCompactLegendItem(
                                    Colors.green,
                                    'Yet to Start',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildCompactLegendItem(
                                    Colors.orange,
                                    'Current',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCompactLegendItem(
                                    Colors.grey,
                                    'Finished',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildCompactLegendItem(
                                    Colors.red,
                                    'Missed',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Calendar Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Calendar Header
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.loginButton,
                                    AppColor.loginButton.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _focusedDay = DateTime(
                                          _focusedDay.year,
                                          _focusedDay.month - 1,
                                        );
                                      });
                                    },
                                  ),
                                  Text(
                                    '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    textScaler: TextScaler.linear(1),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _focusedDay = DateTime(
                                          _focusedDay.year,
                                          _focusedDay.month + 1,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Calendar
                            TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              },
                              onFormatChanged: (format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: AppColor.loginButton.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: AppColor.loginButton,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.loginButton.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                markerDecoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                outsideDaysVisible: false,
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                weekendStyle: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              daysOfWeekHeight: 25,
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  return _buildCalendarDay(day, false, false);
                                },
                                selectedBuilder: (context, day, focusedDay) {
                                  return _buildCalendarDay(day, true, false);
                                },
                                todayBuilder: (context, day, focusedDay) {
                                  return _buildCalendarDay(day, false, true);
                                },
                              ),
                              headerVisible: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Selected Day Details
                      if (_selectedDay != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColor.loginButton,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDay!.day} ${_getMonthName(_selectedDay!.month)}, ${_selectedDay!.year}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textScaler: TextScaler.linear(1),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              _buildJobDetails(_selectedDay!),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, bool isSelected, bool isToday) {
    final color = _getJobStatusColor(day);
    final hasJob = color != Colors.transparent;

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.loginButton
            : (isToday
                  ? AppColor.loginButton.withOpacity(0.3)
                  : (hasJob ? color.withOpacity(0.2) : Colors.transparent)),
        shape: BoxShape.circle,
        border: hasJob && !isSelected
            ? Border.all(color: color, width: 2.5)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColor.loginButton.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isSelected || isToday ? Colors.white : Colors.black,
            fontWeight: hasJob ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
          textScaler: TextScaler.linear(1),
        ),
      ),
    );
  }

  Widget _buildCompactLegendItem(Color color, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.linear(1),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

enum JobStatus { yetToStart, finished, missed, currentJob }