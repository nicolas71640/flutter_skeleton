import 'package:avecpaulette/features/home/presentation/widgets/tile/expandable_widget.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool _focused = false;
  final GlobalKey<FormState> _searchFieldFrom = GlobalKey<FormState>();
  final GlobalKey<FormState> _serachFieldTo = GlobalKey<FormState>();

  void onFocusChanged(bool isFocused) {
    setState(() {
      _focused = isFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() {
        onFocusChanged(false);
        return Future.value(false);
      }),
      child: Container(
        color: (_focused) ? Colors.white : null,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Column(
            children: [
              SearchField(
                key: _searchFieldFrom,
                focused: _focused,
                onTap: () => onFocusChanged(true),
                hintText: "From",
                icon: const Icon(size: 17,Icons.circle_outlined, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              SearchField(
                key: _serachFieldTo,
                focused: _focused,
                onTap: () => onFocusChanged(true),
                hintText: "To",
                icon: const Icon(Icons.place, color: Colors.grey),
              ),
              if (_focused)
                SearchResult()
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(children: [Text("Yo")]),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final String hintText;
  final GestureTapCallback? onTap;
  final bool focused;
  final Icon icon;
  const SearchField(
      {super.key, required this.hintText, this.onTap, required this.focused, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
        onTap: onTap,
        onChanged: (text) {},
        key: const Key("search_field"),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            focusColor: Colors.white,
            prefixIcon: icon,
            hintText: hintText,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    BorderSide(color: (focused) ? Colors.grey : Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    BorderSide(color: (focused) ? Colors.grey : Colors.white)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    BorderSide(color: (focused) ? Colors.grey : Colors.white)),
            fillColor: Colors.white));
  }
}
