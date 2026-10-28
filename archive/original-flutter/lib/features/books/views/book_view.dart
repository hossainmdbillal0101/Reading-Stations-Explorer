import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class BookView extends ConsumerStatefulWidget {
  const BookView({
    Key? key,
    required this.bookurl,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookViewState();
  final String bookurl;
}

class _BookViewState extends ConsumerState<BookView> {
  bool _isLoaded = false;
  String remotePDFpath = "";
  int? pages = 0;
  bool isReady = false;
  int? currentPage = 0;
  String errorMessage = '';
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl(widget.bookurl).then((f) {
      setState(() {
        remotePDFpath = f.path;
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (_isLoaded)
            PDFView(
              filePath: remotePDFpath,
              autoSpacing: false,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                setState(() {
                  pages = pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {},
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page;
                });
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (errorMessage.isEmpty)
            !isReady
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          else
            Center(
              child: Text(errorMessage),
            )
        ],
      ),
    );
  }

  Future<File> createFileOfPdfUrl(String url) async {
    final Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      final File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
