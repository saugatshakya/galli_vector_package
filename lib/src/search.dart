import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:galli_vector_package/galli_vector_package.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class GalliSearchWidget extends StatefulWidget {
  const GalliSearchWidget(
      {super.key,
      this.height = 48,
      this.width,
      // this.animate = true,
      // this.leading,
      // this.trailing,
      required this.authToken,
      required this.mapController,
      this.hint = "Search",
      this.onAutoCompleteResultTap});
  final double height;
  final double? width;
  // final bool animate;
  // final Widget? leading;
  // final Widget? trailing;
  final String hint;
  final String authToken;
  final MapLibreMapController mapController;
  final Function(Map data)? onAutoCompleteResultTap;
  @override
  State<GalliSearchWidget> createState() => _GalliSearchWidgetState();
}

class _GalliSearchWidgetState extends State<GalliSearchWidget> {
  late bool expanded;
  final TextEditingController _query = TextEditingController();
  bool loading = false;
  List<Map<String, dynamic>> autoCompleteResults = [];
  Timer? _debounce;

  void _onQueryChanged(String newText) {
    if (_debounce?.isActive == true) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchAutoCompleteData(newText);
    });
  }

  Future<void> _fetchAutoCompleteData(String query) async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      try {
        autoCompleteResults.clear();
        setState(() {});
        LatLng? latlng = await widget.mapController.requestMyLocationLatLng();
        if (latlng == null) return;
        var data = await GalliMethods(widget.authToken)
            .autoComplete(query, latlng = latlng);
        if (data != null) {
          for (Map rawData in data["data"]) {
            if (autoCompleteResults.length < 10 && rawData["name"] != "") {
              autoCompleteResults.add({
                "name": rawData["name"],
                "distance":
                    (double.parse(rawData["distance"])).toStringAsFixed(2)
              });
              setState(() {});
              await Future.delayed(const Duration(milliseconds: 10));
            }
          }
        }
      } catch (error) {
        log("error: $error");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> search() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      LatLng? location = await widget.mapController.requestMyLocationLatLng();
      try {
        var data =
            await GalliMethods(widget.authToken).search(_query.text, location!);
        autoCompleteResults = [];
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
        LatLng latlng = LatLng(
            data["data"]["features"].first["geometry"]["coordinates"][1],
            data["data"]["features"].first["geometry"]["coordinates"][0]);
        widget.mapController.animateCamera(CameraUpdate.newLatLng(latlng),
            duration: const Duration(milliseconds: 500));
      } catch (e) {
        log("error: $e");
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: _query.text.isNotEmpty && autoCompleteResults.isNotEmpty
          ? Colors.white
          : Colors.transparent,
      width: width,
      height: _query.text.isNotEmpty && autoCompleteResults.isNotEmpty
          ? height
          : widget.height + 48,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: widget.width ?? width * 0.64,
              height: widget.height,
              child: Stack(children: [
                Container(
                  width: widget.width ?? width * 0.64,
                  height: widget.height,
                  decoration: BoxDecoration(
                      color: const Color(0xffE2DFD2),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff454545).withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                            spreadRadius: 3),
                        BoxShadow(
                            color: const Color(0xff454545).withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(-1, -1),
                            spreadRadius: 3)
                      ],
                      border:
                          Border.all(width: 2, color: const Color(0xff121212)),
                      borderRadius: BorderRadius.circular(24)),
                  // padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: TextField(
                    controller: _query,
                    cursorHeight: 12,
                    cursorWidth: 2,
                    onChanged: _onQueryChanged,
                    onSubmitted: (val) {
                      search();
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
                        border: InputBorder.none,
                        hintText: widget.hint,
                        hintStyle: const TextStyle(fontSize: 14)),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Color(0xff212121)),
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_query.text.isNotEmpty) {
                          _query.clear();
                        } else {
                          autoCompleteResults.clear();
                        }
                      });
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                          color: const Color(0xffE2DFD2),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xff454545).withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(1, 1),
                                spreadRadius: 3),
                            BoxShadow(
                                color: const Color(0xff454545).withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(-1, -1),
                                spreadRadius: 3)
                          ],
                          border: Border.all(
                              width: 1, color: const Color(0xff121212)),
                          shape: BoxShape.circle),
                      child: Center(
                        child: loading
                            ? const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : _query.text.isEmpty
                                ? const Icon(
                                    Icons.search,
                                    color: Color(0xff121212),
                                  )
                                : const Icon(
                                    Icons.clear,
                                    color: Color(0xff121212),
                                  ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var data in autoCompleteResults)
                      ListTile(
                        onTap: () {
                          _query.text = data["name"];
                          setState(() {});
                          search();
                          if (widget.onAutoCompleteResultTap != null) {
                            widget.onAutoCompleteResultTap!(data);
                          }
                        },
                        title: Text(
                          data["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(data["distance"] + "KM"),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
