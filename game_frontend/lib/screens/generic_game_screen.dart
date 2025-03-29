import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'result_screen.dart';
import '../models/category.dart';
import '../widgets/guess_history_widget.dart';
import '../widgets/energy_category_widget.dart';
import '../config.dart';

class GenericGameScreen extends StatefulWidget {
  const GenericGameScreen({Key? key}) : super(key: key);

  @override
  _GenericGameScreenState createState() => _GenericGameScreenState();
}

class _GenericGameScreenState extends State<GenericGameScreen> {
  late final Dio _dio;
  late final CookieJar _cookieJar;
  Map<String, dynamic>? gameData;
  String? errorMessage;
  int attemptsLeft = 5;
  String? hintMessage;
  String? _correctAnswer;
  final List<GuessRecord> guessHistory = [];
  late Category category;
  bool isLoading = true;
  
  // For country suggestions
  final TextEditingController _searchController = TextEditingController();
  List<String> _countrySuggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    
    // Set up cookie jar for session management
    _cookieJar = CookieJar();
    
    _dio = Dio(BaseOptions(
      baseUrl: Config.apiUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status! < 500; // Accept all status codes less than 500
      }
    ));
    
    // Add cookie manager to handle session cookies
    _dio.interceptors.add(CookieManager(_cookieJar));
    
    // Add logging interceptor for debugging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        return handler.next(e);
      }
    ));
    
    // Listen for changes in the search field
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchCountrySuggestions(_searchController.text);
      } else {
        setState(() {
          _countrySuggestions = [];
        });
      }
    });
  }
  
  Future<void> _fetchCountrySuggestions(String prefix) async {
    try {
      final response = await _dio.get('/suggestions?prefix=$prefix');
      if (response.data is List) {
        setState(() {
          _countrySuggestions = List<String>.from(response.data);
        });
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      setState(() {
        _countrySuggestions = [];
      });
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Category) {
      category = args;
      if (isLoading) {
        startGame();
      }
    }
  }

  Future<void> startGame() async {
    if (!mounted) return;

    setState(() {
      gameData = null;
      errorMessage = null;
      guessHistory.clear();
      _searchController.clear();
      _countrySuggestions = [];
      isLoading = true;
      hintMessage = null;
      attemptsLeft = 5;
    });

    try {
      // Clear cookies before starting a new game to avoid session conflicts
      await _cookieJar.deleteAll();
      
      print('Starting new game...');
      final response = await _dio.get(
        '/start_game',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('Start game response status: ${response.statusCode}');
      print('Start game response data: ${response.data}');

      if (!mounted) return;

      if (response.data != null) {
        setState(() {
          if (category.name == 'Environment & Energy') {
            // For Energy category, use the special energy data format
            if (response.data.containsKey('energy_data')) {
              gameData = Map<String, dynamic>.from(response.data['energy_data']);
              // The country might be included in energy_data or at the top level
              _correctAnswer = gameData!.containsKey('country') ? gameData!.remove('country') : response.data['target'];
            } else {
              // Fallback if structure is different
              gameData = Map<String, dynamic>.from(response.data);
              _correctAnswer = response.data['target'];
            }
          } else {
            // Handle other categories
            gameData = Map<String, dynamic>.from(response.data);
            _correctAnswer = response.data['target'] ?? response.data['country'];
          }

          isLoading = false;
        });
      }
    } catch (e) {
      print("Error starting game: $e");
      if (e is DioError) {
        print("DioError type: ${e.type}, message: ${e.message}");
        print("DioError response: ${e.response?.data}");
      }
      if (!mounted) return;
      setState(() {
        errorMessage = "Server connection failed. Is the server running?";
        isLoading = false;
      });
    }
  }

  Future<void> submitGuess(String guess) async {
    if (guess.isEmpty) return;
    
    // Store the guess and clear the input field
    final String submittedGuess = guess.trim();
    _searchController.clear();
    setState(() {
      _countrySuggestions = [];
    });
    
    try {
      print('Submitting guess: $submittedGuess');
      
      final response = await _dio.post(
        '/guess',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'guess': submittedGuess,
        },
      );
      
      print('Guess response status: ${response.statusCode}');
      print('Guess response data: ${response.data}');

      if (!mounted) return;

      // Handle 400 error (invalid country, already guessed, etc.)
      if (response.statusCode == 400) {
        setState(() {
          hintMessage = response.data['message'] ?? 'Invalid guess, please try again';
        });
        return;
      }

      final data = response.data;
      final String target = data['target'] ?? _correctAnswer ?? 'Unknown';
      final bool gameOver = data['game_over'] ?? false;

      setState(() {
        hintMessage = data['message'];
        guessHistory.add(GuessRecord(submittedGuess, data['message']));

        if (gameOver || data['message'].toString().contains('Correct!')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                resultMessage: 'Correct! The answer was $target!',
              ),
            ),
          );
          return;
        }

        attemptsLeft--;
        if (attemptsLeft <= 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                resultMessage: 'Out of attempts! The answer was $target',
              ),
            ),
          );
        }
      });
    } catch (e) {
      print("Error during guess: $e");
      if (e is DioError) {
        print("DioError type: ${e.type}, message: ${e.message}");
        print("DioError response data: ${e.response?.data}");
      }
      setState(() {
        hintMessage = "Failed to submit guess. Please try again.";
      });
    }
  }
  
  Future<void> getHint() async {
    final guess = _searchController.text.trim();
    try {
      final response = await _dio.get('/hint?guess=$guess');
      if (response.statusCode == 200) {
        setState(() {
          hintMessage = response.data['message'];
        });
      }
    } catch (e) {
      print("Error getting hint: $e");
      setState(() {
        hintMessage = "Failed to get hint. Please try again.";
      });
    }
  }

  // Function to render appropriate data visualization based on category
  Widget _renderCategorySpecificWidget() {
    if (gameData == null) {
      return const Center(child: Text('No data available'));
    }

    switch (category.name) {
      case 'Environment & Energy':
        return EnergyCategoryWidget(energyData: gameData!);
      case 'Economy & Finance':
        // Placeholder for future implementation
        return const Center(child: Text('Economy data visualization coming soon'));
      case 'Health':
        // Placeholder for future implementation
        return const Center(child: Text('Health data visualization coming soon'));
      // Add more cases for other categories
      default:
        return Center(
          child: Text(
            'Data visualization for ${category.name} coming soon',
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: startGame,
          ),
        ],
      ),
      body: SafeArea(
        child: errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Main scrollable content area with improved padding
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  // Category-specific visualization widget
                                  _renderCategorySpecificWidget(),
                                  
                                  // Hint message when available
                                  if (hintMessage != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Text(
                                        hintMessage!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  
                                  // Attempts remaining indicator
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Attempts left: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: attemptsLeft > 2 ? Colors.green.shade100 : Colors.amber.shade100,
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            '$attemptsLeft',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: attemptsLeft > 2 ? Colors.green.shade800 : Colors.amber.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Previous guesses section with updated styling
                                  if (guessHistory.isNotEmpty)
                                    Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Previous Guesses',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Divider(),
                                            ...guessHistory.map(
                                              (record) => Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${record.guess}: ',
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      child: Text(record.feedback),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ).toList(),
                                          ],
                                        ),
                                      ),
                                    ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Improved input area at bottom
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, -1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text input with action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter country name',
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    ),
                                    style: const TextStyle(fontSize: 15),
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: submitGuess,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () => submitGuess(_searchController.text),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                  ),
                                  child: const Text('Guess'),
                                ),
                              ],
                            ),
                            
                            // Country suggestions dropdown
                            if (_countrySuggestions.isNotEmpty)
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                                ),
                                margin: const EdgeInsets.only(top: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _countrySuggestions.length,
                                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                                    itemBuilder: (context, index) => Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => submitGuess(_countrySuggestions[index]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                          child: Text(
                                            _countrySuggestions[index],
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
}
