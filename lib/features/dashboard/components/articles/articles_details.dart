import 'package:fedha/data/models/articles/articles.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  late final WebViewController controller = WebViewController()
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
      Uri.parse(widget.article.url),
    );
  bool _isLoading = true;

  int loaded = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.close_rounded, color: AppColors.darkBlueColor),
        ),
        title: Text(
          widget.article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkBlueColor,
              ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withValues(alpha: 0.85),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 42,
                    width: 42,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primaryColor,
                      value: loaded > 0 ? loaded / 100 : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loaded > 0 ? 'Loading $loaded%' : 'Opening article…',
                    style: TextStyle(
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
