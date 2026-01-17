import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masteryquiz/main.dart';
import 'package:masteryquiz/quiz_provider.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scorePercentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    
    Color scoreColor;
    String message;
    String detailedMessage;
    
    if (scorePercentage >= 95) {
      scoreColor = AppColors.success;
      message = 'Outstanding! Perfect Mastery! 🎓';
      detailedMessage = 'You demonstrated exceptional understanding. You\'re well-prepared for your exams!';
    } else if (scorePercentage >= 80) {
      scoreColor = AppColors.success;
      message = 'Excellent Performance! 🌟';
      detailedMessage = 'Great work! You have a strong grasp of the concepts. Keep practicing!';
    } else if (scorePercentage >= 70) {
      scoreColor = AppColors.primary;
      message = 'Good Job! 👍';
      detailedMessage = 'You\'re on the right track. Review weak areas to improve further.';
    } else if (scorePercentage >= 60) {
      scoreColor = AppColors.warning;
      message = 'Good Effort! Keep Improving! 💪';
      detailedMessage = 'You\'re making progress! Focus on the topics you missed and try again.';
    } else if (scorePercentage >= 40) {
      scoreColor = AppColors.warning;
      message = 'Room for Improvement 📈';
      detailedMessage = 'Review the concepts thoroughly. Don\'t give up - persistence pays off!';
    } else {
      scoreColor = AppColors.danger;
      message = 'Keep Learning! Never Give Up! 💡';
      detailedMessage = 'This is just the beginning of your learning journey. Practice makes perfect!';
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Trophy Icon with Scale Animation
                          ScaleTransition(
                            scale: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(
                                  0,
                                  0.6,
                                  curve: Curves.elasticOut,
                                ),
                              ),
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: scoreColor.withOpacity(0.1),
                                border: Border.all(
                                  color: scoreColor,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                size: 50,
                                color: scoreColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Score Message with Fade Animation
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(
                                  0.3,
                                  0.7,
                                  curve: Curves.easeIn,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: scoreColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    detailedMessage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Score Details Card with Slide Animation
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(
                                  0.4,
                                  0.8,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSurface
                                    : AppColors.lightSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Your Score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${widget.correctAnswers}/${widget.totalQuestions}',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: scoreColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: scorePercentage / 100,
                                      minHeight: 12,
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey.shade700
                                          : AppColors.lightBorder,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        scoreColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${scorePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: scoreColor,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Divider(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: AppColors.success
                                                    .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.success,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.check_circle,
                                                color: AppColors.success,
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Correct',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors.lightTextSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              widget.correctAnswers.toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.success,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 56,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: AppColors.danger
                                                    .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.danger,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.cancel,
                                                color: AppColors.danger,
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Incorrect',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors.lightTextSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              (widget.totalQuestions -
                                                      widget.correctAnswers)
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.danger,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Wrong Answers History Section
                          Consumer<QuizProvider>(
                            builder: (context, quizProvider, _) {
                              if (quizProvider.wrongAnswers.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.success.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.success,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Perfect Score!',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.success,
                                              ),
                                            ),
                                            Text(
                                              'You got all answers correct!',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors.lightTextSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Questions You Missed',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...quizProvider.wrongAnswers
                                      .asMap()
                                      .entries
                                      .map<Widget>((entry) {
                                    int index = entry.key;
                                    var wrongAnswer = entry.value;
                                    return FadeTransition(
                                      opacity: Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: _animationController,
                                          curve: Interval(
                                            index * 0.1,
                                            0.5 + index * 0.1,
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                      ),
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.3, 0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: _animationController,
                                            curve: Interval(
                                              index * 0.1,
                                              0.5 + index * 0.1,
                                              curve: Curves.easeOut,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColors.danger.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppColors.danger
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: AppColors.danger,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  'Question ${(wrongAnswer['questionIndex'] as int) + 1}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? AppColors.darkTextPrimary
                                                        : AppColors.lightTextPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            wrongAnswer['question'] as String,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.lightTextPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.danger
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.close,
                                                  color: AppColors.danger,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        'Your Answer:',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                      Text(
                                                        wrongAnswer[
                                                            'selectedAnswer'] as String? ?? 'Not Answered',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.success
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: AppColors.success,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        'Correct Answer:',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                      Text(
                                                        wrongAnswer[
                                                            'correctAnswer'] as String,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),                                      ),
                                      ),                                    );
                                  }),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 36),

                          // Buttons with Fade Animation
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(
                                  0.6,
                                  1,
                                  curve: Curves.easeIn,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _showToast('Returning to home');
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    icon: const Icon(Icons.home),
                                    label: const Text('Back to Home'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      _showToast('Starting new quiz');
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Try Again'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                      foregroundColor: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
