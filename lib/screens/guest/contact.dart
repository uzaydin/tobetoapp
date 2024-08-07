import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:tobetoapp/bloc/auth/auth_drawer/drawer_manager.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';
import 'package:tobetoapp/widgets/common_app_bar.dart';
import 'package:tobetoapp/widgets/common_footer.dart';
import 'package:tobetoapp/widgets/guest/contact_info.dart';
import 'package:tobetoapp/widgets/user/contact_functions.dart';
import 'package:tobetoapp/widgets/user/recaptcha.dart';
import 'package:tobetoapp/widgets/validation_video_controller.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late WebViewControllerPlus _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isRecaptchaVerified = false;

  void _updateRecaptchaStatus(bool status) {
    setState(() {
      _isRecaptchaVerified = status;
    });
  }

  final ContactInfo contact = ContactInfo(
      companyName: "TOBETO",
      companyTitle:
          "Avez Elektronik İletişim Eğitim Danışmanlığı Ticaret Anonim Şirketi",
      taxOffice: "Beykoz",
      taxNo: "1050250859",
      phone: "(0216) 331 48 00",
      email: "	info@tobeto.com",
      address:
          "Kavacık, Rüzgarlıbahçe Mah. Çampınarı Sok. No:4 Smart Plaza B Blok Kat:3 34805, Beykoz/İstanbul",
      ikPhone: "(0216) 969 22 40",
      ikEmail: "istanbulkodluyor@tobeto.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      drawer: DrawerManager(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.tobetoMoru,
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Center(
                child: Text("İletişime Geçin",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
            Text(
              "İletişim Bilgileri",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
            Container(
              padding: EdgeInsets.all(AppConstants.paddingSmall),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppConstants.br10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildContactInfo("Firma Adı: ", contact.companyName),
                  buildContactInfo("Firma Unvan: ", contact.companyTitle),
                  buildContactInfo("Vergi Dairesi: ", contact.taxOffice),
                  buildContactInfo("Vergi No: ", contact.taxNo),
                  buildContactInfo("Telefon: ", contact.phone),
                  buildContactInfo("E-Posta: ", contact.email),
                  buildContactInfo("Adres: ", contact.address),
                  buildContactInfo(
                      "İstanbul Kodluyor Telefon: ", contact.ikPhone),
                  buildContactInfo(
                      "İstanbul Kodluyor E-Posta: ", contact.ikEmail),
                  SizedBox(height: AppConstants.sizedBoxHeightSmall),
                ],
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightXXLarge),
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            Container(
              color: AppColors.tobetoMoru,
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Center(
                child: Text("Mesaj Bırakın",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxHeightMedium),
            Text(
              "İletişim Formu",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightXLarge),
            Container(
              padding: EdgeInsets.all(AppConstants.paddingSmall),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppConstants.br10),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameSurnameController,
                        decoration: const InputDecoration(
                            labelText: "Adınız Soyadınız"),
                        validator: (value) => validation(
                            value, 'Lütfen adınızı ve soyadınızı girin'),
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        validator: (value) =>
                            validation(value, 'Lütfen email adresinizi girin'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      TextFormField(
                        controller: _messageController,
                        decoration:
                            const InputDecoration(labelText: "Mesajınız"),
                        validator: (value) =>
                            validation(value, 'Lütfen bir mesaj girin'),
                        maxLines: 4,
                      ),
                      SizedBox(height: AppConstants.sizedBoxHeightLarge),
                      RichText(
                          text: TextSpan(
                              text:
                                  "Yukarıdaki form ile toplanan kişisel verileriniz Enocta tarafından talebinize dair işlemlerin yerine getirilmesi ve paylaşmış olduğunuz iletişim adresi üzerinden tanıtım, bülten ve pazarlama içerikleri gönderilmesi amacıyla ",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                              text: "Aydınlatma Metni",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 163, 77, 233)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    launchURL();
                                  });
                                },
                            ),
                            const TextSpan(
                              text: " çerçevesinde işlenebilecektir.",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            )
                          ])),
                      SizedBox(height: AppConstants.sizedBoxHeightMedium),
                      Recaptcha(onVerified: _updateRecaptchaStatus),
                      SizedBox(height: AppConstants.sizedBoxHeightSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            submitForm(
                                formKey: _formKey,
                                context: context,
                                nameSurnameController: _nameSurnameController,
                                emailController: _emailController,
                                messageController: _messageController);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              AppColors.tobetoMoru,
                            ),
                          ),
                          child: const Text(
                            "Gönder",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const CommonFooter(),
          ],
        ),
      ),
    );
  }
}
