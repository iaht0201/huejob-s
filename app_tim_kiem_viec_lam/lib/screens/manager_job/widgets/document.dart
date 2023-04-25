import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../utils/constant.dart';
import '../../profile/widgets/button_arrow.dart';

class DocumentApply extends StatefulWidget {
  const DocumentApply({super.key, required this.urlFile, required this.title});
  final String urlFile;
  final String title;

  @override
  State<DocumentApply> createState() => _DocumentApplyState();
}

class _DocumentApplyState extends State<DocumentApply> {
  late PdfViewerController _pdfViewerController;
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#FFFFFF"),
          elevation: 0,
          leading: buttonArrow(context),
          title: Text(
            "${widget.title}",
            style: textTheme.semibold16(color: "#000000"),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _pdfViewerController.zoomLevel = 2;
              },
              icon: Icon(
                Icons.zoom_in,
                color: HexColor("#BB2649"),
              ),
            )
          ],
        ),
        body: SfPdfViewer.network(
          '${widget.urlFile}',
          controller: _pdfViewerController,
        ));
  }
}
