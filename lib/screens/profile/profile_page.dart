import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';

import 'package:tobetoapp/bloc/profile/profile_bloc.dart';
import 'package:tobetoapp/bloc/profile/profile_event.dart';
import 'package:tobetoapp/bloc/profile/profile_state.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/profile/applications_page.dart';
import 'package:tobetoapp/screens/profile/edit_profile_section_page.dart';
import 'package:tobetoapp/screens/profile/formscreens/edit_personal_info_page.dart';
import 'package:tobetoapp/screens/profile/settings_page.dart';
import 'package:tobetoapp/screens/profile/surveys_page.dart';
import 'package:tobetoapp/screens/profile/workflows_page.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late WebViewController webViewController;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserDetails());
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            canGoBack = await webViewController.canGoBack();
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://mediafiles.botpress.cloud/d1265f28-5638-4830-bb0c-86bd18db99bc/webchat/bot.html'));
  }

  void _showChatBotPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: AppColors.tobetoMoru,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: WebViewWidget(
                      controller: webViewController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      drawer: const DrawerManager(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: AppConstants.profileImageSize,
                      backgroundImage: user.profilePhotoUrl != null
                          ? NetworkImage(user.profilePhotoUrl!)
                          : const AssetImage('assets/images/profile_photo.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    Text(
                      '${user.firstName ?? ''} ${user.lastName ?? ''}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightSmall),
                    Text(
                      user.email ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    ElevatedButton(
                      onPressed: () {
                        if (user.role == UserRole.teacher ||
                            user.role == UserRole.admin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EditPersonalInfoPage(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSectionPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.br8),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingSmall,
                        ),
                        child: const Text(
                          'Profil Düzenle',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.sizedBoxHeightLarge),
                    const Divider(thickness: 1),
                    SizedBox(height: AppConstants.sizedBoxHeightMedium),
                    if (user.role == UserRole.student) ...[
                      _buildFeatureCard(
                        context,
                        'Başvurularım',
                        'assets/images/başvurular.png',
                        () {
                          // Navigate to Başvurularım page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ApplicationsPage(),
                          ));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        'Anketlerim',
                        'assets/images/anketler.png',
                        () {
                          // Navigate to Anketlerim page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SurveysPage(),
                          ));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        'İş Süreçleri',
                        'assets/images/iş_süreçleri.png',
                        () {
                          // Navigate to İş Süreçleri page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const WorkflowsPage(),
                          ));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        'Tobeto Chat',
                        'assets/images/tobetochat.png',
                        () {
                          _showChatBotPopup(context);
                        },
                      ),
                    ],
                    _buildFeatureCard(
                      context,
                      'Ayarlar',
                      'assets/images/ayarlar.png',
                      () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ));
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String imagePath,
      VoidCallback onTap) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.br10),
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppConstants.paddingSmall),
        leading: Image.asset(imagePath, width: 40, height: 40),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
        onTap: onTap,
      ),
    );
  }
}
