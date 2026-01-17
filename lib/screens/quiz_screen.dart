import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masteryquiz/quiz_provider.dart';
import 'package:masteryquiz/services/board_data_service.dart';
import 'package:masteryquiz/main.dart';

class QuizScreen extends StatefulWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  final BoardDataService boardService = BoardDataService();
  late AnimationController _animationController;
  final List<String> encouragements = [
    '🚀 You\'re doing great! Keep it up!',
    '💡 Think carefully before answering',
    '⭐ Every question is a learning opportunity',
    '🎯 Focus on one question at a time',
    '📚 Knowledge is power - keep learning!',
    '✨ You\'ve got this! Trust your preparation',
  ];

  @override
  void initState() {
    super.initState();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<QuizProvider>(context, listen: false)
          .fetchQuestions(widget.topic);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.topic,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
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
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.isLoading) {
                final randomEncouragement = encouragements[
                    DateTime.now().millisecond % encouragements.length];
                return Center(
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 4,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Preparing your quiz...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            randomEncouragement,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (quizProvider.questions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 60,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No questions available.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            quizProvider.fetchQuestions(widget.topic);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final question =
                  quizProvider.questions[quizProvider.currentQuestionIndex];
              final progress = (quizProvider.currentQuestionIndex + 1) /
                  quizProvider.questions.length;

              return SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress Section with Timer
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Timer Display
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: quizProvider.secondsRemaining <= 10
                                                ? AppColors.danger
                                                    .withOpacity(0.1)
                                                : AppColors.primary
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: quizProvider
                                                          .secondsRemaining <=
                                                      10
                                                  ? AppColors.danger
                                                  : AppColors.primary,
                                            ),
                                          ),
                                          child: Text(
                                            '⏱ ${quizProvider.secondsRemaining}s',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: quizProvider
                                                          .secondsRemaining <=
                                                      10
                                                  ? AppColors.danger
                                                  : AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 8,
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade200,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Question Card
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSurface
                                    : AppColors.lightSurface,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.1),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Question',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          question['question'] ?? '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Options
                              ...(question['options'] as List?)
                                      ?.asMap()
                                      .entries
                                      .map<Widget>(
                                        (entry) {
                                          String option = entry.value;
                                          bool isSelected =
                                              quizProvider.selectedAnswers[
                                                  quizProvider
                                                      .currentQuestionIndex] ==
                                                  option;
                                          bool isCorrect =
                                              option == question['correctAnswer'];
                                          bool showFeedback = quizProvider
                                              .answerFeedback
                                              .containsKey(quizProvider
                                                  .currentQuestionIndex);

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: GestureDetector(
                                              onTap: showFeedback
                                                  ? null
                                                  : () {
                                                      quizProvider.selectAnswer(
                                                        quizProvider
                                                            .currentQuestionIndex,
                                                        option,
                                                      );
                                                      // Show snackbar feedback only
                                                      if (isCorrect) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              '✓ Correct Answer!',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .success,
                                                            duration:
                                                                const Duration(
                                                              seconds: 2,
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                8,
                                                              ),
                                                            ),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(16),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              '✗ Wrong Answer!',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .danger,
                                                            duration:
                                                                const Duration(
                                                              seconds: 2,
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                8,
                                                              ),
                                                            ),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(16),
                                                          ),
                                                        );
                                                      }
                                                    },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: showFeedback
                                                      ? isCorrect
                                                          ? AppColors.success
                                                              .withOpacity(0.2)
                                                          : isSelected
                                                              ? AppColors.danger
                                                                  .withOpacity(
                                                                  0.2)
                                                              : (Theme.of(context).brightness == Brightness.dark
                                                                  ? AppColors.darkSurface
                                                                  : AppColors.lightSurface)
                                                      : isSelected
                                                          ? AppColors.primary
                                                          : (Theme.of(context).brightness == Brightness.dark
                                                              ? AppColors.darkSurface
                                                              : AppColors.lightSurface),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: showFeedback
                                                        ? isCorrect
                                                            ? AppColors.success
                                                            : isSelected
                                                                ? AppColors
                                                                    .danger
                                                                : (Theme.of(context).brightness == Brightness.dark
                                                                    ? AppColors.darkBorder
                                                                    : Colors.grey.shade300)
                                                        : isSelected
                                                            ? AppColors.primary
                                                            : (Theme.of(context).brightness == Brightness.dark
                                                                ? AppColors.darkBorder
                                                                : Colors.grey.shade300),
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    if (isSelected && !showFeedback)
                                                      BoxShadow(
                                                        color: AppColors.primary
                                                            .withOpacity(0.2),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: showFeedback
                                                              ? isCorrect
                                                                  ? AppColors
                                                                      .success
                                                                  : isSelected
                                                                      ? AppColors
                                                                          .danger
                                                                      : (Theme.of(context).brightness == Brightness.dark
                                                                          ? Colors.grey.shade600
                                                                          : Colors.grey.shade400)
                                                              : isSelected
                                                                  ? Colors.white
                                                                  : (Theme.of(context).brightness == Brightness.dark
                                                                      ? Colors.grey.shade600
                                                                      : Colors.grey.shade400),
                                                          width: 2,
                                                        ),
                                                        color: showFeedback
                                                            ? isCorrect
                                                                ? AppColors
                                                                    .success
                                                                : isSelected
                                                                    ? AppColors
                                                                        .danger
                                                                    : Colors
                                                                        .transparent
                                                            : isSelected
                                                                ? AppColors
                                                                    .accent
                                                                : Colors
                                                                    .transparent,
                                                      ),
                                                      child: showFeedback
                                                          ? Icon(
                                                              isCorrect
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              size: 16,
                                                              color: Colors
                                                                  .white,
                                                            )
                                                          : isSelected
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  size: 16,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              : null,
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Text(
                                                        option,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: showFeedback
                                                              ? isCorrect
                                                                  ? AppColors
                                                                      .success
                                                                  : isSelected
                                                                      ? AppColors
                                                                          .danger
                                                                      : (Theme.of(context).brightness == Brightness.dark
                                                                          ? AppColors.darkTextSecondary
                                                                          : AppColors.lightTextPrimary)
                                                              : isSelected
                                                                  ? Colors.white
                                                                  : (Theme.of(context).brightness == Brightness.dark
                                                                      ? AppColors.darkTextPrimary
                                                                      : AppColors.lightTextPrimary),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      .toList() ??
                                  [],
                              const SizedBox(height: 24),

                              // Next Button - Disabled until answer selected
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: quizProvider.selectedAnswers
                                          .containsKey(quizProvider
                                              .currentQuestionIndex)
                                      ? () {
                                          quizProvider.nextQuestion(context);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: quizProvider.selectedAnswers
                                            .containsKey(quizProvider
                                                .currentQuestionIndex)
                                        ? AppColors.primary
                                        : Colors.grey[400],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    elevation: 2,
                                    disabledBackgroundColor:
                                        Colors.grey[400],
                                  ),
                                  child: Text(
                                    quizProvider.currentQuestionIndex ==
                                            quizProvider.questions.length - 1
                                        ? 'Submit Quiz'
                                        : 'Next Question',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
