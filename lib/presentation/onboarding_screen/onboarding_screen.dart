import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_account_widget.dart';
import './widgets/onboarding_language_selection_widget.dart';
import './widgets/onboarding_motivation_widget.dart';
import './widgets/onboarding_province_widget.dart';
import './widgets/onboarding_step_indicator_widget.dart';
import './widgets/onboarding_welcome_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _currentStep = 0;
  final int _totalSteps = 6;

  // Step 2: languages user speaks
  final Set<String> _spokenLanguages = {'Bemba'};
  // Step 3: language to learn
  String _languageToLearn = 'Nyanja';
  // Step 4: province
  String _selectedProvince = 'Lusaka';
  // Step 5: motivations
  final Set<String> _motivations = {'Family', 'Fun'};
  // Step 6: account
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _slideController.reset();
      setState(() => _currentStep++);
      _slideController.forward();
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.go(AppRoutes.homeScreen);
  }

  String _getStepLabel() {
    switch (_currentStep) {
      case 0:
        return 'Welcome';
      case 1:
        return 'What languages do you speak?\n(Select all that apply)';
      case 2:
        return 'What do you want\nto learn?\n(Choose one)';
      case 3:
        return 'Which Province\nare you from?\n(Select your province)';
      case 4:
        return 'Why do you want\nto learn?\n(Select all that apply)';
      case 5:
        return 'Create your account\nSign up to start your\nlearning journey';
      default:
        return '';
    }
  }

  String _getButtonLabel() {
    switch (_currentStep) {
      case 0:
        return 'Get Started';
      case 5:
        return 'Sign Up';
      default:
        return 'Next';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return OnboardingWelcomeWidget();
      case 1:
        return OnboardingLanguageSelectionWidget(
          title: 'What languages do you speak?',
          subtitle: '(Select all that apply)',
          selectedLanguages: _spokenLanguages,
          multiSelect: true,
          onChanged: (lang) {
            setState(() {
              if (_spokenLanguages.contains(lang)) {
                _spokenLanguages.remove(lang);
              } else {
                _spokenLanguages.add(lang);
              }
            });
          },
        );
      case 2:
        return OnboardingLanguageSelectionWidget(
          title: 'What do you want to learn?',
          subtitle: '(Choose one)',
          selectedLanguages: {_languageToLearn},
          multiSelect: false,
          onChanged: (lang) {
            setState(() => _languageToLearn = lang);
          },
        );
      case 3:
        return OnboardingProvinceWidget(
          selectedProvince: _selectedProvince,
          onChanged: (p) => setState(() => _selectedProvince = p),
        );
      case 4:
        return OnboardingMotivationWidget(
          selectedMotivations: _motivations,
          onChanged: (m) {
            setState(() {
              if (_motivations.contains(m)) {
                _motivations.remove(m);
              } else {
                _motivations.add(m);
              }
            });
          },
        );
      case 5:
        return OnboardingAccountWidget(
          emailController: _emailController,
          passwordController: _passwordController,
          onGoogleSignIn: _completeOnboarding,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 480 : double.infinity,
            ),
            child: Column(
              children: [
                // Step indicator
                if (_currentStep > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: OnboardingStepIndicatorWidget(
                      currentStep: _currentStep,
                      totalSteps: _totalSteps,
                    ),
                  )
                else
                  const SizedBox(height: 16),

                // Scrollable content
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildCurrentStep(),
                      ),
                    ),
                  ),
                ),

                // Bottom action button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _getButtonLabel(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (_currentStep == 5) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'or continue with',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: _completeOnboarding,
                            icon: const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 24,
                              color: Color(0xFF4285F4),
                            ),
                            label: Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFCCCCCC),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'By continuing, you agree to our Terms & Privacy Policy',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B6B6B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
