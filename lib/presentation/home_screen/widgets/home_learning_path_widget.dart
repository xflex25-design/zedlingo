import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class _LessonNode {
  final String id;
  final String title;
  final String subtitle;
  final bool isUnlocked;
  final bool isCompleted;
  final int xpReward;
  final bool isSlang;

  const _LessonNode({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
    required this.isCompleted,
    required this.xpReward,
    this.isSlang = false,
  });
}

class _UnitData {
  final String unitNumber;
  final String unitTitle;
  final List<_LessonNode> lessons;
  final bool isUnlocked;

  const _UnitData({
    required this.unitNumber,
    required this.unitTitle,
    required this.lessons,
    required this.isUnlocked,
  });
}

class HomeLearningPathWidget extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLessonTap;
  final bool isTablet;

  const HomeLearningPathWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLessonTap,
    required this.isTablet,
  });

  @override
  State<HomeLearningPathWidget> createState() => _HomeLearningPathWidgetState();
}

class _HomeLearningPathWidgetState extends State<HomeLearningPathWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late List<Animation<double>> _nodeAnimations;

  static const List<_UnitData> _units = [
    _UnitData(
      unitNumber: 'UNIT 1',
      unitTitle: 'Greetings',
      isUnlocked: true,
      lessons: [
        _LessonNode(
          id: 'l1',
          title: 'Muli shani?',
          subtitle: '3/3 completed',
          isUnlocked: true,
          isCompleted: true,
          xpReward: 10,
        ),
        _LessonNode(
          id: 'l2',
          title: 'Muli bwanji?',
          subtitle: '2/3 completed',
          isUnlocked: true,
          isCompleted: false,
          xpReward: 10,
        ),
        _LessonNode(
          id: 'l3',
          title: 'Formal Greetings',
          subtitle: '0/3 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 15,
        ),
      ],
    ),
    _UnitData(
      unitNumber: 'UNIT 2',
      unitTitle: 'Introductions',
      isUnlocked: false,
      lessons: [
        _LessonNode(
          id: 'l4',
          title: 'My Name Is',
          subtitle: '0/4 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 10,
        ),
        _LessonNode(
          id: 'l5',
          title: 'Where Are You From?',
          subtitle: '0/4 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 10,
        ),
      ],
    ),
    _UnitData(
      unitNumber: 'UNIT 3',
      unitTitle: 'Common Phrases',
      isUnlocked: false,
      lessons: [
        _LessonNode(
          id: 'l6',
          title: 'Market Talk',
          subtitle: '0/5 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 20,
        ),
        _LessonNode(
          id: 'l7',
          title: 'Kopala Slang Basics',
          subtitle: '0/5 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 25,
          isSlang: true,
        ),
        _LessonNode(
          id: 'l8',
          title: 'Market Bargaining',
          subtitle: '0/5 completed',
          isUnlocked: false,
          isCompleted: false,
          xpReward: 20,
          isSlang: true,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final totalNodes = _units.fold<int>(0, (sum, u) => sum + u.lessons.length);
    _nodeAnimations = List.generate(totalNodes, (index) {
      final start = (index * 0.08).clamp(0.0, 0.7);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        widget.isTablet ? 80 : 20,
        16,
        widget.isTablet ? 80 : 20,
        120, // space for floating nav
      ),
      itemCount: _units.length,
      itemBuilder: (context, unitIndex) {
        final unit = _units[unitIndex];
        return _UnitSection(
          unit: unit,
          nodeAnimations: _nodeAnimations,
          nodeOffset: _units
              .take(unitIndex)
              .fold<int>(0, (sum, u) => sum + u.lessons.length),
          onLessonTap: widget.onLessonTap,
        );
      },
    );
  }
}

class _UnitSection extends StatelessWidget {
  final _UnitData unit;
  final List<Animation<double>> nodeAnimations;
  final int nodeOffset;
  final ValueChanged<String> onLessonTap;

  const _UnitSection({
    required this.unit,
    required this.nodeAnimations,
    required this.nodeOffset,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Unit header
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: unit.isUnlocked ? AppTheme.primary : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(64),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unit.isUnlocked ? '🌿' : '🔒',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.unitNumber,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: unit.isUnlocked
                          ? Colors.white.withAlpha(204)
                          : const Color(0xFF6B6B6B),
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    unit.unitTitle,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: unit.isUnlocked
                          ? Colors.white
                          : const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Lesson nodes
        ...List.generate(unit.lessons.length, (lessonIndex) {
          final lesson = unit.lessons[lessonIndex];
          final globalIndex = nodeOffset + lessonIndex;
          final animation = globalIndex < nodeAnimations.length
              ? nodeAnimations[globalIndex]
              : const AlwaysStoppedAnimation(1.0);

          // Alternate left/right positioning for path effect
          final isLeft = lessonIndex % 2 == 0;

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: animation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - animation.value) * 20),
                  child: child,
                ),
              );
            },
            child: _LessonNodeWidget(
              lesson: lesson,
              isLeft: isLeft,
              isLast: lessonIndex == unit.lessons.length - 1,
              onTap: lesson.isUnlocked ? () => onLessonTap(lesson.id) : null,
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LessonNodeWidget extends StatelessWidget {
  final _LessonNode lesson;
  final bool isLeft;
  final bool isLast;
  final VoidCallback? onTap;

  const _LessonNodeWidget({
    required this.lesson,
    required this.isLeft,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: isLeft
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            // Path connector left side
            if (!isLeft)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: lesson.isUnlocked
                            ? AppTheme.primary.withAlpha(102)
                            : const Color(0xFFE0E0E0),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),

            // Node button
            GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  // Node circle
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lesson.isCompleted
                          ? AppTheme.primary
                          : lesson.isUnlocked
                          ? Colors.white
                          : const Color(0xFFE8E8E8),
                      border: Border.all(
                        color: lesson.isCompleted
                            ? AppTheme.primaryDark
                            : lesson.isUnlocked
                            ? AppTheme.primary
                            : const Color(0xFFCCCCCC),
                        width: 3,
                      ),
                      boxShadow: lesson.isUnlocked
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(77),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: lesson.isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 32,
                            )
                          : lesson.isUnlocked
                          ? const Text('⭐', style: TextStyle(fontSize: 28))
                          : const Icon(
                              Icons.lock_rounded,
                              color: Color(0xFFAFAFAF),
                              size: 28,
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Lesson title below node
                  Container(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Column(
                      children: [
                        Text(
                          lesson.title,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: lesson.isUnlocked
                                ? AppTheme.zambiaBlack
                                : const Color(0xFFAFAFAF),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (lesson.isUnlocked) ...[
                          const SizedBox(height: 2),
                          Text(
                            lesson.subtitle,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: const Color(0xFF6B6B6B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (lesson.isSlang) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B1FA2).withAlpha(31),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF7B1FA2).withAlpha(102),
                              ),
                            ),
                            child: Text(
                              '🗣️ Kopala',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6A1B9A),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Path connector right side
            if (isLeft)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: lesson.isUnlocked
                            ? AppTheme.primary.withAlpha(102)
                            : const Color(0xFFE0E0E0),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Vertical path connector
        if (!isLast)
          Align(
            alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 2,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 35),
              color: AppTheme.primary.withAlpha(77),
            ),
          ),
      ],
    );
  }
}
