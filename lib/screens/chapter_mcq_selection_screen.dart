import 'package:flutter/material.dart';
import 'package:masteryquiz/services/board_data_service.dart';
import 'package:masteryquiz/main.dart';
import 'quiz_screen.dart';

class ChapterMcqSelectionScreen extends StatefulWidget {
  final Subject subject;
  final String boardName;

  const ChapterMcqSelectionScreen({
    super.key,
    required this.subject,
    required this.boardName,
  });

  @override
  State<ChapterMcqSelectionScreen> createState() =>
      _ChapterMcqSelectionScreenState();
}

class _ChapterMcqSelectionScreenState extends State<ChapterMcqSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Chapter> chapters;
  List<Chapter> selectedChapters = [];
  int selectedMcqCount = 10;

  final mcqOptions = [5, 10, 15, 20, 25, 30, 50];

  @override
  void initState() {
    super.initState();
    chapters = widget.subject.chapters;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleChapter(Chapter chapter) {
    setState(() {
      if (selectedChapters.contains(chapter)) {
        selectedChapters.remove(chapter);
      } else {
        selectedChapters.add(chapter);
      }
    });
  }

  void _selectAllChapters() {
    setState(() {
      if (selectedChapters.length == chapters.length) {
        selectedChapters.clear();
      } else {
        selectedChapters = List.from(chapters);
      }
    });
  }

  void _startQuiz() {
    if (selectedChapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one chapter'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Create a topic string with selected chapters
    String topic =
        '${widget.subject.name} - ${selectedChapters.map((c) => c.name).join(", ")} - ${selectedMcqCount} MCQs';

    Navigator.push(
      context,
      SmoothPageTransition(page: QuizScreen(topic: topic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Chapters & MCQs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: FadeTransition(
          opacity: _animationController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Header
                _buildSubjectHeader(context),
                const SizedBox(height: 24),

                // MCQ Benefits Section
                _buildMcqBenefitsSection(context),
                const SizedBox(height: 24),

                // Select All Button
                _buildSelectAllButton(context),
                const SizedBox(height: 20),

                // Chapters Section
                _buildChaptersSection(context),
                const SizedBox(height: 32),

                // MCQ Count Selection
                _buildMcqCountSection(context),
                const SizedBox(height: 32),

                // Start Quiz Button
                _buildStartButton(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMcqBenefitsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Why MCQs Are The Best Way to Learn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildBenefitItem('📚 Active Recall', 'Retrieving information from memory strengthens learning'),
          _buildBenefitItem('🎯 Immediate Feedback', 'Know instantly if your answer is correct'),
          _buildBenefitItem('✨ Pattern Recognition', 'Spot common exam questions and patterns'),
          _buildBenefitItem('⚡ Time Efficiency', 'Practice in realistic exam conditions'),
          _buildBenefitItem('🧠 Memory Retention', 'MCQs improve long-term knowledge retention'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subject.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Board: ${widget.boardName}',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Available Chapters: ${chapters.length}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllButton(BuildContext context) {
    bool allSelected = selectedChapters.length == chapters.length;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _selectAllChapters,
          icon: Icon(allSelected ? Icons.check_circle : Icons.circle_outlined),
          label: Text(allSelected ? 'Deselect All' : 'Select All Chapters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: allSelected ? AppColors.success : AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChaptersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📖 Available Chapters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          chapters.length,
          (index) {
            final chapter = chapters[index];
            final isSelected = selectedChapters.contains(chapter);

            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
                  .animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.1 + (index * 0.05), 0.8 + (index * 0.05)),
                  )),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.1 + (index * 0.05), 0.8 + (index * 0.05)),
                    )),
                child: GestureDetector(
                  onTap: () => _toggleChapter(chapter),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chapter ${chapter.number}: ${chapter.name}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${chapter.topics.length} topics',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                            size: 24,
                          )
                        else
                          Icon(
                            Icons.radio_button_unchecked,
                            color: AppColors.primary.withOpacity(0.5),
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMcqCountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎯 Number of MCQs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0)
              .animate(CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.5, 1.0),
              )),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: mcqOptions.map((count) {
              bool isSelected = selectedMcqCount == count;

              return GestureDetector(
                onTap: () {
                  setState(() => selectedMcqCount = count);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$count MCQs',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    bool canStart = selectedChapters.isNotEmpty;

    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0)
          .animate(CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.6, 1.0),
          )),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: canStart ? _startQuiz : null,
          icon: const Icon(Icons.play_arrow_rounded, size: 24),
          label: Text(
            'Start Quiz (${selectedChapters.length} chapters)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: canStart ? AppColors.success : Colors.grey,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
