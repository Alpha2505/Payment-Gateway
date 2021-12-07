import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: themeData,
  ));
}

final ThemeData themeData = ThemeData(
  canvasColor: Colors.lightGreen,
  accentColor: Colors.redAccent,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.push(ctx, PageTwo());
          },
          child: MyHomePage(title: 'Slot Booking'),
        ),
      ),
    );
  }
}

class PageTwo extends MaterialPageRoute<Null> {
  PageTwo()
      : super(builder: (BuildContext ctx) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(ctx).canvasColor,
              elevation: 1.0,
            ),
            body: Center(
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(ctx, PageThree());
                },
                child: Text("Claim your Slot!!!"),
                color: Colors.amber,
              ),
            ),
          );
        });
}

class PageThree extends MaterialPageRoute<Null> {
  PageThree()
      : super(builder: (BuildContext ctx) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Last Page!"),
              backgroundColor: Theme.of(ctx).accentColor,
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                )
              ],
            ),
            body: Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.popUntil(
                      ctx, ModalRoute.withName(Navigator.defaultRouteName));
                },
                child: Text("Go Home!"),
              ),
            ),
          );
        });
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_kOmQ6n4iunyQhQ',
      'amount': 100,
      'name': 'CHARGEMe!!',
      'Description': 'Test Payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'SUCCESS: ' + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'ERROR: ' + response.code.toString() + '-' + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'EXTERNAL WALLET: ' + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FlatButton.icon(
          onPressed: () {
            openCheckout();
          },
          icon: Icon(Icons.payment),
          label: Text(
            "Make Payment",
            style: TextStyle(fontSize: 25),
          ),
          color: Colors.amber,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.help),
        backgroundColor: Colors.lightGreen[600],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
