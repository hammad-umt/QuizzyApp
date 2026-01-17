import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masteryquiz/quiz_provider.dart';
import 'package:masteryquiz/services/board_data_service.dart';
import 'package:masteryquiz/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chapter_mcq_selection_screen.dart';
import 'about_me_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final BoardDataService boardService = BoardDataService();
  late AnimationController _animationController;
  
  Board? selectedBoard;
  Grade? selectedGrade;
  Discipline? selectedDiscipline;
  Subject? selectedSubject;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
  Widget build(BuildContext context) {
    final boards = boardService.getAllBoards();
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MasteryQuiz',
            style: TextStyle(
              fontSize: 24,
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
          elevation: 1,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: 'Account Settings',
                child: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => _showSettingsDialog(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: 'Logout',
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () => _showLogoutDialog(context, null),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                _buildWelcomeSection(context),
                const SizedBox(height: 24),

                // Daily Tip
                _buildDailyTipCard(context),
                const SizedBox(height: 24),

                // Step 1: Board Selection
                _buildSectionHeader(context, '📚 Step 1: Select Your Board'),
                const SizedBox(height: 12),
                if (selectedBoard == null)
                  _buildBoardsGrid(context, boards)
                else
                  _buildSelectedCard(
                    context,
                    selectedBoard!.name,
                    selectedBoard!.description,
                    onEdit: () {
                      setState(() {
                        selectedBoard = null;
                        selectedGrade = null;
                        selectedDiscipline = null;
                        selectedSubject = null;
                      });
                    },
                  ),
                const SizedBox(height: 24),

                // Step 2: Grade Selection
                if (selectedBoard != null) ...[
                  _buildSectionHeader(context, '🏫 Step 2: Select Your Grade/Class'),
                  const SizedBox(height: 12),
                  if (selectedGrade == null)
                    _buildGradesGrid(context)
                  else
                    _buildSelectedCard(
                      context,
                      selectedGrade!.name,
                      'Selected grade',
                      onEdit: () {
                        setState(() {
                          selectedGrade = null;
                          selectedDiscipline = null;
                          selectedSubject = null;
                        });
                      },
                    ),
                  const SizedBox(height: 24),
                ],

                // Step 3: Discipline Selection
                if (selectedBoard != null && selectedGrade != null) ...[
                  _buildSectionHeader(context, '🎓 Step 3: Select Discipline'),
                  const SizedBox(height: 12),
                  if (selectedDiscipline == null)
                    _buildDisciplinesGrid(context)
                  else
                    _buildSelectedCard(
                      context,
                      selectedDiscipline!.name,
                      'Selected discipline',
                      onEdit: () {
                        setState(() {
                          selectedDiscipline = null;
                          selectedSubject = null;
                        });
                      },
                    ),
                  const SizedBox(height: 24),
                ],

                // Step 4: Subject Selection
                if (selectedBoard != null && selectedGrade != null && selectedDiscipline != null) ...[
                  _buildSectionHeader(context, '📖 Step 4: Select Subject'),
                  const SizedBox(height: 12),
                  if (selectedSubject == null)
                    _buildSubjectsGrid(context)
                  else
                    _buildSelectedCard(
                      context,
                      selectedSubject!.name,
                      '${selectedSubject!.chapters.length} chapters',
                      onEdit: () {
                        setState(() {
                          selectedSubject = null;
                        });
                      },
                    ),
                  const SizedBox(height: 24),

                  // Start Quiz Button
                  _buildStartQuizButton(context),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email?.split('@').first ?? 'Student';
    // Capitalize first letter of name
    final userName = userEmail.isNotEmpty 
        ? userEmail[0].toUpperCase() + userEmail.substring(1) 
        : 'Student';
    
    return FadeTransition(
      opacity: _animationController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome, ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                TextSpan(
                  text: userName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: '! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Master Pakistani curriculum with AI-powered quizzes',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // MCQ Learning Benefits
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.success.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '✨ MCQs are the easiest and most effective way to remember concepts!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTipCard(BuildContext context) {
    final tips = boardService.getStudyTips();
    final randomTip = tips[(DateTime.now().millisecond % tips.length)];

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.lightbulb, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Tip',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    randomTip,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildBoardsGrid(BuildContext context, List<Board> boards) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: boards.length,
      itemBuilder: (context, index) {
        return _buildAnimatedBoardCard(context, boards[index], index);
      },
    );
  }

  Widget _buildAnimatedBoardCard(BuildContext context, Board board, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.05, 0.5 + index * 0.05, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(index * 0.05, 0.5 + index * 0.05, curve: Curves.easeOut),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedBoard = board;
              selectedDiscipline = null;
              selectedSubject = null;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedBoard = board;
                    selectedDiscipline = null;
                    selectedSubject = null;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      board.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${board.grades.length} grades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradesGrid(BuildContext context) {
    final grades = selectedBoard!.grades;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: grades.length,
      itemBuilder: (context, index) {
        final grade = grades[index];
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(index * 0.1, 0.7 + index * 0.1, curve: Curves.easeOut),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedGrade = grade;
                selectedDiscipline = null;
                selectedSubject = null;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.3),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      selectedGrade = grade;
                      selectedDiscipline = null;
                      selectedSubject = null;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        size: 32,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        grade.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDisciplinesGrid(BuildContext context) {
    if (selectedGrade == null) return const SizedBox.shrink();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: selectedGrade!.disciplines.length,
      itemBuilder: (context, index) {
        final discipline = selectedGrade!.disciplines[index];
        return _buildAnimatedDisciplineCard(context, discipline, index);
      },
    );
  }

  Widget _buildAnimatedDisciplineCard(
      BuildContext context, Discipline discipline, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.08, 0.6 + index * 0.08, curve: Curves.easeOut),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDiscipline = discipline;
            selectedSubject = null;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedDiscipline = discipline;
                  selectedSubject = null;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDisciplineEmoji(discipline.name),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    discipline.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context) {
    if (selectedDiscipline == null) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: selectedDiscipline!.subjects.length,
      itemBuilder: (context, index) {
        final subject = selectedDiscipline!.subjects[index];
        return _buildAnimatedSubjectCard(context, subject, index);
      },
    );
  }

  Widget _buildAnimatedSubjectCard(
      BuildContext context, Subject subject, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 0.7 + index * 0.1, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(index * 0.1, 0.7 + index * 0.1, curve: Curves.easeOut),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedSubject = subject;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.08),
                  AppColors.secondary.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedSubject = subject;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getSubjectEmoji(subject.name),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subject.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.chapters.length} chapters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCard(
    BuildContext context,
    String title,
    String subtitle, {
    required VoidCallback onEdit,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.success.withOpacity(0.1),
              AppColors.success.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.success.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartQuizButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () => _startQuiz(),
          icon: const Icon(Icons.play_arrow, size: 24),
          label: const Text(
            'Start Quiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  String _getDisciplineEmoji(String discipline) {
    switch (discipline.toLowerCase()) {
      case 'science':
        return '🔬';
      case 'arts':
        return '📚';
      case 'commerce':
        return '💼';
      default:
        return '📖';
    }
  }

  String _getSubjectEmoji(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return '⚛️';
      case 'chemistry':
        return '🧪';
      case 'biology':
        return '🧬';
      case 'mathematics':
        return '📐';
      case 'computer science':
        return '💻';
      case 'english':
        return '🔤';
      case 'urdu':
        return '🇵🇰';
      case 'pakistan studies':
        return '🏛️';
      case 'islamiyat':
        return '☪️';
      case 'tarjumatul quran':
        return '📖';
      case 'accounting':
        return '📊';
      case 'economics':
        return '💰';
      case 'business studies':
        return '🏢';
      default:
        return '📝';
    }
  }

  void _startQuiz() {
    if (selectedSubject == null) return;
    
    // Navigate to chapter selection screen instead of directly to quiz
    Navigator.push(
      context,
      SmoothPageTransition(
        page: ChapterMcqSelectionScreen(
          subject: selectedSubject!,
          boardName: selectedBoard?.name ?? 'Unknown',
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Account Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Version: 1.0.0'),
                const SizedBox(height: 16),
                const Text('Need help? Contact our support team.'),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      SmoothPageTransition(
                        page: const AboutMeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info, color: AppColors.primary),
                  label: const Text(
                    'About Us',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                // TextButton.icon(
                //   onPressed: () => _showLogoutDialog(context, dialogContext),
                //   icon: const Icon(Icons.logout, color: Colors.red),
                //   label: const Text(
                //     'Logout',
                //     style: TextStyle(color: Colors.red),
                //   ),
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, BuildContext? dialogContext) {
    showDialog(
      context: context,
      builder: (BuildContext logoutDialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout? Your quiz progress will be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(logoutDialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  Provider.of<QuizProvider>(context, listen: false).resetQuiz();
                  await FirebaseAuth.instance.signOut();
                  if (logoutDialogContext.mounted) Navigator.pop(logoutDialogContext);
                  if (dialogContext?.mounted ?? false) Navigator.pop(dialogContext!);
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                } catch (e) {
                  debugPrint('Logout error: $e');
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
