// Comprehensive Pakistani Education System Data
// This file contains all boards, grades, disciplines, subjects, and chapters

class Chapter {
  final String name;
  final String number;
  final List<String> topics;

  Chapter({
    required this.name,
    required this.number,
    required this.topics,
  });
}

class Subject {
  final String name;
  final String code;
  final List<Chapter> chapters;

  Subject({
    required this.name,
    required this.code,
    required this.chapters,
  });
}

class Discipline {
  final String name;
  final String code;
  final List<Subject> subjects;

  Discipline({
    required this.name,
    required this.code,
    required this.subjects,
  });
}

class Grade {
  final String name; // e.g., "Grade 9", "F.Sc", "B.S"
  final String code; // e.g., "grade_9", "fsc", "bs"
  final List<Discipline> disciplines;

  Grade({
    required this.name,
    required this.code,
    required this.disciplines,
  });
}

class Board {
  final String name;
  final String code;
  final String description;
  final List<Grade> grades;

  Board({
    required this.name,
    required this.code,
    required this.description,
    required this.grades,
  });
}

class BoardDataService {
  static final BoardDataService _instance = BoardDataService._internal();

  factory BoardDataService() {
    return _instance;
  }

  BoardDataService._internal();

  // Get all available boards
  List<Board> getAllBoards() {
    return [
      _getFBISEBoard(),
      _getBISELahore(),
      _getBISEGujranwala(),
      _getBISEMultan(),
      _getBISEKarachi(),
      _getBISEPeshawar(),
      _getBISEHyderabad(),
      _getBISEIslamabad(),
      _getBISEFaisalabad(),
      _getBISESargodha(),
      _getBISEQuetta(),
      _getBISERawalpindi(),
    ];
  }

  // Helper method to create common science subjects
  List<Subject> _getScienceSubjects() {
    return [
      Subject(
        name: 'Physics',
        code: 'physics',
        chapters: [
          Chapter(name: 'Measurements', number: '1', topics: ['SI Units', 'Errors and Uncertainties', 'Dimensions', 'Significant Figures']),
          Chapter(name: 'Motion and Force', number: '2', topics: ['Kinematics', 'Dynamics', 'Newton\'s Laws', 'Friction']),
          Chapter(name: 'Work and Energy', number: '3', topics: ['Work', 'Kinetic Energy', 'Potential Energy', 'Conservation']),
          Chapter(name: 'Rotational Motion', number: '4', topics: ['Angular Motion', 'Torque', 'Angular Momentum', 'Moment of Inertia']),
          Chapter(name: 'Gravitation', number: '5', topics: ['Newton\'s Law of Gravitation', 'Orbital Motion', 'Satellites', 'Escape Velocity']),
          Chapter(name: 'Oscillations', number: '6', topics: ['Simple Harmonic Motion', 'Pendulum', 'Energy in SHM', 'Damping']),
          Chapter(name: 'Waves', number: '7', topics: ['Wave Motion', 'Sound Waves', 'Doppler Effect', 'Wave Interference']),
          Chapter(name: 'Fluids', number: '8', topics: ['Density and Pressure', 'Continuity Equation', 'Bernoulli\'s Theorem', 'Viscosity']),
          Chapter(name: 'Thermal Properties', number: '9', topics: ['Temperature', 'Heat', 'Specific Heat Capacity', 'Calorimetry']),
          Chapter(name: 'Thermodynamics', number: '10', topics: ['Laws of Thermodynamics', 'Heat Engines', 'Entropy', 'Internal Energy']),
          Chapter(name: 'Electrostatics', number: '11', topics: ['Electric Charge', 'Electric Field', 'Electric Potential', 'Capacitance']),
          Chapter(name: 'Current Electricity', number: '12', topics: ['Electric Current', 'Resistance', 'EMF and Internal Resistance', 'Circuits']),
        ],
      ),
      Subject(
        name: 'Chemistry',
        code: 'chemistry',
        chapters: [
          Chapter(name: 'Fundamental Concepts', number: '1', topics: ['Matter', 'Atomic Structure', 'Molar Mass', 'Stoichiometry']),
          Chapter(name: 'Atomic Structure', number: '2', topics: ['Bohr Model', 'Quantum Numbers', 'Electron Configuration', 'Periodic Table']),
          Chapter(name: 'Chemical Bonding', number: '3', topics: ['Ionic Bonding', 'Covalent Bonding', 'Metallic Bonding', 'Hydrogen Bonding']),
          Chapter(name: 'Chemical Energetics', number: '4', topics: ['Enthalpy', 'Entropy', 'Hess\'s Law', 'Gibbs Free Energy']),
          Chapter(name: 'Equilibrium', number: '5', topics: ['Dynamic Equilibrium', 'Equilibrium Constant', 'Le Chatelier\'s Principle', 'Calculation of Kc']),
          Chapter(name: 'Redox Reactions', number: '6', topics: ['Oxidation States', 'Balancing Equations', 'Electrochemistry', 'Half Reactions']),
          Chapter(name: 'Acid-Base Chemistry', number: '7', topics: ['pH and pOH', 'Buffers', 'Titrations', 'Salt Hydrolysis']),
          Chapter(name: 'Organic Chemistry', number: '8', topics: ['Functional Groups', 'Isomerism', 'Reaction Mechanisms', 'Nomenclature']),
          Chapter(name: 'Hydrocarbons', number: '9', topics: ['Alkanes', 'Alkenes', 'Alkynes', 'Aromatic Compounds']),
          Chapter(name: 'Biochemistry', number: '10', topics: ['Carbohydrates', 'Proteins', 'Lipids', 'Nucleic Acids']),
        ],
      ),
      Subject(
        name: 'Biology',
        code: 'biology',
        chapters: [
          Chapter(name: 'Introduction to Biology', number: '1', topics: ['Characteristics of Life', 'Organization of Life', 'Branches of Biology', 'Scientific Method']),
          Chapter(name: 'Cell Structure', number: '2', topics: ['Prokaryotic Cells', 'Eukaryotic Cells', 'Organelles', 'Cell Membrane']),
          Chapter(name: 'Cell Division', number: '3', topics: ['Mitosis', 'Meiosis', 'Binary Fission', 'Cell Cycle']),
          Chapter(name: 'Genetics', number: '4', topics: ['Mendelian Inheritance', 'DNA Structure', 'Gene Expression', 'Protein Synthesis']),
          Chapter(name: 'Homeostasis', number: '5', topics: ['Temperature Regulation', 'Osmoregulation', 'Feedback Mechanisms', 'Excretion']),
          Chapter(name: 'Nutrition', number: '6', topics: ['Photosynthesis', 'Cellular Respiration', 'Nutrient Cycles', 'Enzymes']),
          Chapter(name: 'Transport', number: '7', topics: ['Diffusion', 'Osmosis', 'Active Transport', 'Xylem and Phloem']),
          Chapter(name: 'Support and Movement', number: '8', topics: ['Skeletal System', 'Muscular System', 'Locomotion', 'Coordination']),
          Chapter(name: 'Coordination and Control', number: '9', topics: ['Nervous System', 'Endocrine System', 'Hormones', 'Reflex Arc']),
          Chapter(name: 'Reproduction', number: '10', topics: ['Sexual Reproduction', 'Human Reproduction', 'Fetal Development', 'Growth']),
        ],
      ),
      Subject(
        name: 'Mathematics',
        code: 'mathematics',
        chapters: [
          Chapter(name: 'Numbers', number: '1', topics: ['Complex Numbers', 'De Moivre\'s Theorem', 'Roots', 'Algebra of Complex Numbers']),
          Chapter(name: 'Sets', number: '2', topics: ['Set Theory', 'Operations on Sets', 'Venn Diagrams', 'Cardinality']),
          Chapter(name: 'Algebra', number: '3', topics: ['Quadratic Equations', 'Inequalities', 'Polynomials', 'Partial Fractions']),
          Chapter(name: 'Trigonometry', number: '4', topics: ['Trigonometric Functions', 'Identities', 'Equations', 'Applications']),
          Chapter(name: 'Vectors', number: '5', topics: ['Vector Operations', 'Dot Product', 'Cross Product', 'Vector Equations']),
          Chapter(name: 'Matrices', number: '6', topics: ['Matrix Operations', 'Determinants', 'Inverse', 'Linear Systems']),
          Chapter(name: 'Sequences', number: '7', topics: ['Arithmetic Sequence', 'Geometric Sequence', 'Series', 'Summation']),
          Chapter(name: 'Calculus I', number: '8', topics: ['Limits', 'Continuity', 'Derivatives', 'Differentiation Rules']),
          Chapter(name: 'Calculus II', number: '9', topics: ['Applications of Derivatives', 'Integration', 'Indefinite Integrals', 'Techniques']),
          Chapter(name: 'Calculus III', number: '10', topics: ['Definite Integrals', 'Differential Equations', 'Applications', 'Area and Volume']),
        ],
      ),
      Subject(
        name: 'Computer Science',
        code: 'computer_science',
        chapters: [
          Chapter(name: 'Introduction', number: '1', topics: ['What is Computer Science', 'Algorithms', 'Problem Solving', 'Data Structures']),
          Chapter(name: 'Programming Basics', number: '2', topics: ['Variables', 'Data Types', 'Operators', 'Input/Output']),
          Chapter(name: 'Control Structures', number: '3', topics: ['If-Else', 'Loops', 'Switch Statements', 'Exception Handling']),
          Chapter(name: 'Functions', number: '4', topics: ['Function Definition', 'Parameters', 'Return Values', 'Scope']),
          Chapter(name: 'Arrays and Lists', number: '5', topics: ['Arrays', 'Lists', 'Searching and Sorting', 'Algorithms']),
          Chapter(name: 'Strings', number: '6', topics: ['String Operations', 'Parsing', 'Regular Expressions', 'Text Processing']),
          Chapter(name: 'Object-Oriented Programming', number: '7', topics: ['Classes', 'Inheritance', 'Polymorphism', 'Encapsulation']),
          Chapter(name: 'Databases', number: '8', topics: ['SQL', 'Database Design', 'Queries', 'Normalization']),
          Chapter(name: 'Networking', number: '9', topics: ['Internet Basics', 'Protocols', 'Web Development', 'HTTP/HTTPS']),
          Chapter(name: 'Security', number: '10', topics: ['Cryptography', 'Hacking Prevention', 'Data Protection', 'Authentication']),
        ],
      ),
    ];
  }

  List<Subject> _getArtsSubjects() {
    return [
      Subject(
        name: 'English',
        code: 'english',
        chapters: [
          Chapter(name: 'Reading Comprehension', number: '1', topics: ['Prose', 'Poetry', 'Drama', 'Literary Analysis']),
          Chapter(name: 'Essay Writing', number: '2', topics: ['Types of Essays', 'Structure', 'Style', 'Thesis Development']),
          Chapter(name: 'Grammar', number: '3', topics: ['Parts of Speech', 'Sentence Structure', 'Common Errors', 'Tenses']),
          Chapter(name: 'Vocabulary', number: '4', topics: ['Word Meanings', 'Synonyms and Antonyms', 'Usage', 'Etymology']),
          Chapter(name: 'Literary Devices', number: '5', topics: ['Metaphor', 'Simile', 'Alliteration', 'Personification']),
        ],
      ),
      Subject(
        name: 'Urdu',
        code: 'urdu',
        chapters: [
          Chapter(name: 'نثر', number: '1', topics: ['مختصر اہداف', 'غیر معمولی انسان', 'افسانہ', 'کہانی']),
          Chapter(name: 'نظم', number: '2', topics: ['علامہ اقبال', 'کلام کی خوبیاں', 'غالب', 'دوسری شاعری']),
          Chapter(name: 'سلام', number: '3', topics: ['لسانی نکات', 'شاعری کا تجزیہ', 'مختلف شاعر', 'تنقید']),
          Chapter(name: 'لسانیات', number: '4', topics: ['حروف کی تقسیم', 'اسمائے اعراب', 'قواعد', 'تراکیب']),
        ],
      ),
      Subject(
        name: 'Islamic Studies',
        code: 'islamicstudies',
        chapters: [
          Chapter(name: 'Quran', number: '1', topics: ['Verses', 'Meanings', 'Applications', 'Tafseer']),
          Chapter(name: 'Hadith', number: '2', topics: ['Traditions', 'Teachings', 'Life of Prophet', 'Sunnahs']),
          Chapter(name: 'Islamic History', number: '3', topics: ['Early Islam', 'Khulafa', 'Expansion', 'Golden Age']),
          Chapter(name: 'Islamic Law', number: '4', topics: ['Shariah', 'Fiqh', 'Principles', 'Application']),
        ],
      ),
      Subject(
        name: 'Pakistan Studies',
        code: 'pakistanstudies',
        chapters: [
          Chapter(name: 'History', number: '1', topics: ['Independence', 'Founders', 'Events', 'Key Figures']),
          Chapter(name: 'Geography', number: '2', topics: ['Location', 'Resources', 'Climate', 'Physical Features']),
          Chapter(name: 'Politics', number: '3', topics: ['Government', 'Constitution', 'Democracy', 'Institutions']),
          Chapter(name: 'Economy', number: '4', topics: ['Industries', 'Trade', 'Agriculture', 'Development']),
        ],
      ),
    ];
  }

  // Commerce subjects
  List<Subject> _getCommerceSubjects() {
    return [
      Subject(
        name: 'English',
        code: 'english',
        chapters: [
          Chapter(name: 'Reading Comprehension', number: '1', topics: ['Prose', 'Poetry', 'Drama', 'Literary Analysis']),
          Chapter(name: 'Essay Writing', number: '2', topics: ['Business Writing', 'Report Writing', 'Professional Communication']),
          Chapter(name: 'Grammar', number: '3', topics: ['Parts of Speech', 'Sentence Structure', 'Common Errors', 'Tenses']),
          Chapter(name: 'Vocabulary', number: '4', topics: ['Business Terms', 'Synonyms and Antonyms', 'Usage']),
          Chapter(name: 'Communication Skills', number: '5', topics: ['Presentations', 'Correspondence', 'Professional Etiquette']),
        ],
      ),
      Subject(
        name: 'Urdu',
        code: 'urdu',
        chapters: [
          Chapter(name: 'نثر', number: '1', topics: ['مختصر اہداف', 'غیر معمولی انسان', 'افسانہ', 'کہانی']),
          Chapter(name: 'نظم', number: '2', topics: ['علامہ اقبال', 'کلام کی خوبیاں', 'غالب', 'دوسری شاعری']),
          Chapter(name: 'سلام', number: '3', topics: ['لسانی نکات', 'شاعری کا تجزیہ', 'مختلف شاعر', 'تنقید']),
          Chapter(name: 'لسانیات', number: '4', topics: ['حروف کی تقسیم', 'اسمائے اعراب', 'قواعد', 'تراکیب']),
        ],
      ),
      Subject(
        name: 'Islamic Studies',
        code: 'islamicstudies',
        chapters: [
          Chapter(name: 'Quran', number: '1', topics: ['Verses', 'Meanings', 'Applications', 'Tafseer']),
          Chapter(name: 'Hadith', number: '2', topics: ['Traditions', 'Teachings', 'Life of Prophet', 'Sunnahs']),
          Chapter(name: 'Islamic History', number: '3', topics: ['Early Islam', 'Khulafa', 'Expansion', 'Golden Age']),
          Chapter(name: 'Islamic Law', number: '4', topics: ['Shariah', 'Fiqh', 'Principles', 'Application']),
        ],
      ),
      Subject(
        name: 'Pakistan Studies',
        code: 'pakistanstudies',
        chapters: [
          Chapter(name: 'History', number: '1', topics: ['Independence', 'Founders', 'Events', 'Key Figures']),
          Chapter(name: 'Geography', number: '2', topics: ['Location', 'Resources', 'Climate', 'Physical Features']),
          Chapter(name: 'Politics', number: '3', topics: ['Government', 'Constitution', 'Democracy', 'Institutions']),
          Chapter(name: 'Economy', number: '4', topics: ['Industries', 'Trade', 'Agriculture', 'Development']),
        ],
      ),
      Subject(
        name: 'Principles of Accounting',
        code: 'accounting',
        chapters: [
          Chapter(name: 'Introduction to Accounting', number: '1', topics: ['Accounting Equation', 'Double Entry', 'Journal Entries', 'Ledger']),
          Chapter(name: 'Financial Statements', number: '2', topics: ['Income Statement', 'Balance Sheet', 'Cash Flow', 'Trial Balance']),
          Chapter(name: 'Advanced Accounting', number: '3', topics: ['Depreciation', 'Bad Debts', 'Provision', 'Adjustments']),
          Chapter(name: 'Partnership Accounts', number: '4', topics: ['Partnership Formation', 'Profit Distribution', 'Capital Accounts', 'Final Accounts']),
        ],
      ),
      Subject(
        name: 'Business Mathematics',
        code: 'business_math',
        chapters: [
          Chapter(name: 'Percentage and Profit Loss', number: '1', topics: ['Percentages', 'Profit Calculation', 'Loss Calculation', 'Markup']),
          Chapter(name: 'Simple and Compound Interest', number: '2', topics: ['Simple Interest', 'Compound Interest', 'Annuity', 'Present Value']),
          Chapter(name: 'Series and Progressions', number: '3', topics: ['Arithmetic Series', 'Geometric Series', 'Sum of Series']),
          Chapter(name: 'Logarithms and Algebra', number: '4', topics: ['Logarithm Laws', 'Quadratic Equations', 'Linear Equations']),
        ],
      ),
      Subject(
        name: 'Economics',
        code: 'economics',
        chapters: [
          Chapter(name: 'Microeconomics', number: '1', topics: ['Supply and Demand', 'Price Mechanism', 'Consumer Choice', 'Market Structures']),
          Chapter(name: 'Macroeconomics', number: '2', topics: ['National Income', 'Inflation', 'Unemployment', 'Economic Growth']),
          Chapter(name: 'International Trade', number: '3', topics: ['Comparative Advantage', 'Tariffs', 'Exchange Rates', 'Balance of Payments']),
          Chapter(name: 'Development Economics', number: '4', topics: ['Economic Development', 'Poverty', 'Inequality', 'Resources']),
        ],
      ),
    ];
  }

  // Federal BISE
  Board _getFBISEBoard() {
    final scienceDisciplines = [
      Discipline(
        name: 'Science',
        code: 'science',
        subjects: _getScienceSubjects(),
      ),
    ];

    final artsDisciplines = [
      Discipline(
        name: 'Arts',
        code: 'arts',
        subjects: _getArtsSubjects(),
      ),
    ];

    final commerceDisciplines = [
      Discipline(
        name: 'Commerce',
        code: 'commerce',
        subjects: _getCommerceSubjects(),
      ),
    ];

    return Board(
      name: 'Federal Board (FBISE)',
      code: 'fbise',
      description: 'Federal BISE',
      grades: [
        Grade(
          name: 'F.Sc (Grade 11-12)',
          code: 'fsc',
          disciplines: scienceDisciplines + artsDisciplines + commerceDisciplines,
        ),
        Grade(
          name: 'S.Sc (Grade 9-10)',
          code: 'ssc',
          disciplines: scienceDisciplines + artsDisciplines + commerceDisciplines,
        ),
      ],
    );
  }

  Board _getBISELahore() {
    return Board(
      name: 'BISE Lahore',
      code: 'bise_lahore',
      description: 'BISE Lahore - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEGujranwala() {
    return Board(
      name: 'BISE Gujranwala',
      code: 'bise_gujranwala',
      description: 'BISE Gujranwala - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEMultan() {
    return Board(
      name: 'BISE Multan',
      code: 'bise_multan',
      description: 'BISE Multan - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEKarachi() {
    return Board(
      name: 'BISE Karachi',
      code: 'bise_karachi',
      description: 'BISE Karachi - Sindh',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEPeshawar() {
    return Board(
      name: 'BISE Peshawar',
      code: 'bise_peshawar',
      description: 'BISE Peshawar - KP',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEHyderabad() {
    return Board(
      name: 'BISE Hyderabad',
      code: 'bise_hyderabad',
      description: 'BISE Hyderabad - Sindh',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEIslamabad() {
    return Board(
      name: 'Federal Board Islamabad',
      code: 'bise_islamabad',
      description: 'BISE Islamabad - Federal Territory',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEFaisalabad() {
    return Board(
      name: 'BISE Faisalabad',
      code: 'bise_faisalabad',
      description: 'BISE Faisalabad - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISESargodha() {
    return Board(
      name: 'BISE Sargodha',
      code: 'bise_sargodha',
      description: 'BISE Sargodha - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISEQuetta() {
    return Board(
      name: 'BISE Quetta',
      code: 'bise_quetta',
      description: 'BISE Quetta - Balochistan',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  Board _getBISERawalpindi() {
    return Board(
      name: 'BISE Rawalpindi',
      code: 'bise_rawalpindi',
      description: 'BISE Rawalpindi - Punjab',
      grades: [
        Grade(
          name: 'Intermediate (FSc/FA)',
          code: 'intermediate',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
        Grade(
          name: 'Matric (SSC)',
          code: 'matric',
          disciplines: [
            Discipline(name: 'Science', code: 'science', subjects: _getScienceSubjects()),
            Discipline(name: 'Arts', code: 'arts', subjects: _getArtsSubjects()),
            Discipline(name: 'Commerce', code: 'commerce', subjects: _getCommerceSubjects()),
          ],
        ),
      ],
    );
  }

  List<String> getStudyTips() {
    return [
      '💡 Review notes before bed to improve memory retention',
      '🎯 Focus on one topic at a time for better understanding',
      '⏰ Use the Pomodoro technique: 25 min study, 5 min break',
      '📝 Write summaries to strengthen your memory',
      '🔄 Revise regularly to retain what you\'ve learned',
      '💭 Teach concepts to others to deepen understanding',
      '🌙 Get 7-8 hours of sleep for optimal brain function',
      '🏃 Exercise regularly for better concentration',
      '📚 Create mind maps to visualize connections',
      '✅ Track your progress to stay motivated',
    ];
  }
}
