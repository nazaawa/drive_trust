import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    
    // Listen for auth state changes and show errors
    ref.listen<AsyncValue<void>>(
      authNotifierProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          },
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Un email de réinitialisation a été envoyé'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/login');
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  const Icon(
                    Icons.lock_reset_outlined,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Réinitialiser le mot de passe',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Entrez votre adresse email pour recevoir un lien de réinitialisation de mot de passe',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Email field
                  CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Entrez votre email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleResetPassword(
                      context, 
                      ref, 
                      formKey, 
                      emailController,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Reset password button
                  AuthButton(
                    text: 'Envoyer le lien',
                    isLoading: isLoading,
                    onPressed: () => _handleResetPassword(
                      context, 
                      ref, 
                      formKey, 
                      emailController,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Back to login
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Retour à la connexion'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetPassword(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
  ) {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    // Validate form
    if (formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).resetPassword(
        emailController.text.trim(),
      );
    }
  }
}
