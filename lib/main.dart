import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final heightController = TextEditingController();
final weightController = TextEditingController();
final AdWidget adWidget = AdWidget(ad: myBanner);
final BannerAd myBanner = BannerAd( // test code ca-app-pub-3940256099942544/6300978111  my ad code ca-app-pub-1998790830353657/6395893202
  adUnitId: 'ca-app-pub-1998790830353657/6395893202',
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(),
);
bool adLoaded = false;

double bmi = 0;
var vki = '', status = '', ack = '';
int gender = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    myBanner.load();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          title: Text('Vücut Kitle Endeksi Hesaplama')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                controller: heightController,
                decoration: InputDecoration(hintText: 'Boyunuzu giriniz (cm)'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                controller: weightController,
                decoration: InputDecoration(hintText: 'Kilonuzu giriniz (kg)'),
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = int.parse(value.toString());
                              });
                            },
                          ),
                          SizedBox(width: 5),
                          Text('Erkek'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = int.parse(value.toString());
                              });
                            },
                          ),
                          SizedBox(width: 5),
                          Text('Kadın'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    status = 'Gerekli alanları doldurunuz.';
                    if (heightController.text.isNotEmpty &&
                        weightController.text.isNotEmpty) {
                      double height = double.parse(heightController.text);
                      double weight = double.parse(weightController.text);

                      double ideal_kilo = 0;
                      if (gender > 0) {
                        // Kadın
                        ideal_kilo = 45.5 + 2.3 * ((height / 2.54) - 60);
                      } else {
                        // Erkek
                        ideal_kilo = 50 + 2.3 * ((height / 2.54) - 60);
                      }

                      bmi = weight / ((height / 100) * (height / 100));
                      vki = bmi.toStringAsFixed(2);

                      if (bmi < 18.49) {
                        status = 'Zayıf';
                        ack =
                            'Durumunuz boyunuza göre uygun ağırlıkta olmadığınızı, zayıf olduğunuzu gösteriyor. Zayıflık, bazı hastalıklar için risk oluşturan ve istenmeyen bir durumdur. Boyunuza uygun ağırlığa erişmeniz için yeterli ve dengeli beslenmeli, beslenme alışkanlıklarınızı geliştirmeye özen göstermelisiniz.';
                      } else if (bmi <= 24.99) {
                        status = 'Normal';
                        ack =
                            'Durumunuz boyunuza göre uygun ağırlıkta olduğunuzu gösteriyor. Yeterli ve dengeli beslenerek ve düzenli fiziksel aktivite yaparak bu ağırlığınızı korumaya özen gösteriniz.';
                      } else if (bmi <= 29.9) {
                        status = 'Fazla kilolu';
                        ack =
                            'Durumunuz boyunuza göre vücut ağırlığınızın fazla olduğunu gösteriyor. Fazla kilolu olma durumu gerekli önlemler alınmadığı takdirde pek çok hastalık için risk faktörü olan obeziteye (şişmanlık) yol açar.';
                      } else if (bmi <= 34.9) {
                        status = 'Tip 1 obez';
                        ack =
                            'Durumunuz boyunuza göre vücut ağırlığınızın fazla olduğunu bir başka deyişle şişman olduğunuzu gösteriyor. Şişmanlık, kalp-damar hastalıkları, diyabet, hipertansiyon v.b. kronik hastalıklar için risk faktörüdür. Bir sağlık kuruluşuna başvurarak hekim / diyetisyen kontrolünde zayıflayarak normal ağırlığa inmeniz sağlığınız açısından çok önemlidir. Lütfen, sağlık kuruluşuna başvurunuz.';
                      } else if (bmi <= 40) {
                        status = 'Tip 2 obez';
                        ack =
                            'Durumunuz boyunuza göre vücut ağırlığınızın fazla olduğunu bir başka deyişle şişman olduğunuzu gösteriyor. Şişmanlık, kalp-damar hastalıkları, diyabet, hipertansiyon v.b. kronik hastalıklar için risk faktörüdür. Bir sağlık kuruluşuna başvurarak hekim / diyetisyen kontrolünde zayıflayarak normal ağırlığa inmeniz sağlığınız açısından çok önemlidir. Lütfen, sağlık kuruluşuna başvurunuz.';
                      } else {
                        status = 'Morbid obez';
                        ack =
                            'Durumunuz boyunuza göre vücut ağırlığınızın fazla olduğunu bir başka deyişle şişman olduğunuzu gösteriyor. Şişmanlık, kalp-damar hastalıkları, diyabet, hipertansiyon v.b. kronik hastalıklar için risk faktörüdür. Bir sağlık kuruluşuna başvurarak hekim / diyetisyen kontrolünde zayıflayarak normal ağırlığa inmeniz sağlığınız açısından çok önemlidir. Lütfen, sağlık kuruluşuna başvurunuz.';
                      }

                      status = 'Durum: ' +
                          status +
                          '\nVKİ: ' +
                          vki +'\nİdeal kilo: ' +
                          ideal_kilo.toStringAsFixed(0);

                      vki = bmi.toStringAsFixed(2);
                    } else {
                      vki = '';
                      ack = '';
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(status),
                  ));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text("Hesapla"),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  child: adWidget,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image(
                          width: 147,
                          height: 100,
                          image: AssetImage('images/detail.png'),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          Visibility(
                            visible: status.isNotEmpty,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(status,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: ack.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(ack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
