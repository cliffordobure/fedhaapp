import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageWidget extends StatefulWidget {
  const WebPageWidget({Key? key, required this.route}) : super(key: key);
  final String route;

  @override
  State<WebPageWidget> createState() => _WebPageWidgetState();
}

class _WebPageWidgetState extends State<WebPageWidget> {
  late final WebViewController controller;
  bool _isLoading = true;

  int loaded = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            setState(() {
              _isLoading = true;
            });
          });
        },
        onProgress: (progress) {
          setState(() {
            loaded = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
        },
        onWebResourceError: (error) {},
      ))
      ..loadRequest(
        Uri.parse(widget.route),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          _isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: AlignmentDirectional.center,
                  decoration: const BoxDecoration(
                    color: Colors.white54,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Center(
                        child: SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: CircularProgressIndicator(
                            value: null,
                            strokeWidth: 7.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: Text(
                            "$loaded% loading.. please wait...",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      )),
    );
  }
}
