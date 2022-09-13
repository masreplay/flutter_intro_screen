import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_intro_screen/flutter_intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // read from shared preference or data base
    bool showIntroScreen = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: showIntroScreen ? const IntroScreen() : const MyHomePage(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    const colors = IntroColors(
      button: Color(0xfff39c12),
      text: Colors.white,
      background: Color(0xff0d3352),
    );

    return Scaffold(
      body: FlutterIntroScreen(
        onCompletePressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const MyHomePage();
              },
            ),
          );
        },
        colors: colors,
        appLogo: _buildAppLogo(),
        pageData: _buildPageData(),
        centerWidget: Text(
          "swap left to continue",
          style: GoogleFonts.raleway(),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.house,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Text(
          "Example App",
          style: GoogleFonts.yesevaOne(fontSize: 24),
        ),
      ],
    );
  }

  List<IntroPageData> _buildPageData() {
    final titleStyle = GoogleFonts.yesevaOne(fontSize: 24);
    final descriptionStyle = GoogleFonts.raleway(fontSize: 16);
    return <IntroPageData>[
      IntroPageData(
        title: Text(
          "Find it",
          style: titleStyle,
        ),
        description: Text(
          "filters, maps, and search",
          textAlign: TextAlign.center,
          style: descriptionStyle,
        ),
        image: const IntroAssetsImage(path: "assets/images/intro-1.jpg"),
      ),
      IntroPageData(
        title: Text(
          "Tour it.",
          style: titleStyle,
        ),
        description: Text(
          "read all the details about the property",
          textAlign: TextAlign.center,
          style: descriptionStyle,
        ),
        image: const IntroAssetsImage(path: "assets/images/intro-2.jpg"),
      ),
      IntroPageData(
        title: Text(
          "Own it.",
          style: titleStyle,
        ),
        description: Text(
          "Direct contact with the owner of the property",
          textAlign: TextAlign.center,
          style: descriptionStyle,
        ),
        image: const IntroAssetsImage(path: "assets/images/intro-3.jpg"),
      ),
    ];
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Flutter Demo Home Page'),
      ),
    );
  }
}
