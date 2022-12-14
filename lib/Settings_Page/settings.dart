import 'package:flutter/material.dart';
import 'package:music_player/Settings_Page/privacy_policy.dart';
import 'package:music_player/Settings_Page/terms_and_conditions.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/app_bar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}
bool notificationSwitch = true;
class _SettingsState extends State<Settings> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: appBarWidget(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: songnametext,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy()));
                },
              ),
              ListTile(
                title: const Text(
                  'Terms and Conditions',
                  style: songnametext,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TermsAndConditions()));
                },
              ),
              const NotificationSwitch(),
              // ListTile(
              //   title: const Text(
              //     'Notifications',
              //     style: songnametext,
              //   ),
              //   trailing: Switch(
              //     inactiveTrackColor: Colors.white,
              //     value: notificationSwitch,
              //     onChanged: (value) {
              //       setState(() {
              //         notificationSwitch = value;
              //       });
              //     },
              //   ),
              //   onTap: () {},
              // ),
              ListTile(
                title: const Text(
                  'About',
                  style: songnametext,
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AboutPage()));
                },
              ),
            ],
          ),
          const Text(
            'Version \n 1.0 ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 190, 176, 176)),
          ),
        ],
      ),
    );
  }
}
class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text(
          'Notifications',
          style: songnametext,
        ),
        trailing: Switch(
          inactiveTrackColor: Colors.white,
          value: notificationSwitch,
          onChanged: (newValue) {
            // print(newValue);
            setState(() {
              notificationSwitch = newValue;
            });
            // print(notificationSwitch);
          },
        ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: 'MUSIX',
      applicationIcon: Image(
        image: AssetImage('assets/images/Logo.png'),
      ),
      applicationVersion: '1.0',
      applicationLegalese: 'Developed By \nAbdul Yazer N',
    );
  }
}
