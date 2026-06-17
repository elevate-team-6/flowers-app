import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (!mounted) return;

            Navigator.pop(context, PaymentResult.noInternet);
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('allOrders')) {
              Navigator.pop(context, PaymentResult.success);
              return NavigationDecision.prevent;
            }

            if (url.contains('/cart')) {
              Navigator.pop(context, PaymentResult.cancelled);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.of(context).pop(PaymentResult.backPressed);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.payment)),
        body: Stack(children: [WebViewWidget(controller: _controller)]),
      ),
    );
  }
}

enum PaymentResult { success, cancelled, noInternet, backPressed }
