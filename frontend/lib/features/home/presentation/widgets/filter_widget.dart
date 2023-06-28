import 'package:avecpaulette/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/suggestion_entity.dart';

class Filter {
  final SuggestionEntity suggestion;

  Filter(this.suggestion);
}

class FilterWidget extends StatefulWidget {
  final void Function(Filter) onUpdate;
  const FilterWidget({super.key, required this.onUpdate});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool _focused = false;
  final GlobalKey<FormState> _searchFieldFrom = GlobalKey<FormState>();
  String target = "";

  void onFocusChanged(bool isFocused) {
    setState(() {
      target = "";
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
            child: Column(children: [
              SearchField(
                key: _searchFieldFrom,
                focused: _focused,
                onTap: () => onFocusChanged(true),
                hintText: "Around...",
                text: target,
                icon: const Icon(size: 17, Icons.search, color: Colors.grey),
                onClear: () {
                  target = "";
                },
              ),
              if (_focused)
                SearchResult(onResult: (filter) {
                  setState(() {
                    target = filter.suggestion.description;
                    _focused = false;
                    FocusScope.of(context).unfocus();
                    widget.onUpdate(filter);
                  });
                })
            ])),
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  final void Function(Filter) onResult;
  const SearchResult({
    Key? key,
    required this.onResult,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
      if (state is PlaceDetails) {
        widget.onResult(Filter(state.suggestion));
      }
    }, builder: (context, state) {
      if (state is SuggestionsUpdate) {
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(state.suggestions[index].description),
            onTap: () {
              if (state.suggestions[index].latLng != null) {
                widget.onResult(Filter(state.suggestions[index]));
              } else {
                BlocProvider.of<HomeBloc>(context).add(GetPlaceDetails(
                    state.suggestions[index].placeId,
                    WidgetsBinding.instance.window.locale.languageCode));
              }
            },
          ),
          itemCount: state.suggestions.length,
        );
      }
      return const Text("no result");
    }));
  }
}

class SearchField extends StatefulWidget {
  final String hintText;
  final GestureTapCallback? onTap;
  final Function() onClear;
  final bool focused;
  final Icon icon;
  final String text;

  const SearchField(
      {super.key,
      required this.hintText,
      this.onTap,
      required this.focused,
      required this.icon,
      required this.text,
      required this.onClear});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController controller =
      TextEditingController(text: widget.text);
  @override
  Widget build(BuildContext context) {
    if (widget.text.isNotEmpty) controller.text = widget.text;
    return TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (text) {
          BlocProvider.of<HomeBloc>(context).add(FindPlace(
              text, WidgetsBinding.instance.window.locale.languageCode));
        },
        onTap: widget.onTap,
        controller: controller,
        onChanged: (text) {
          BlocProvider.of<HomeBloc>(context).add(GetSuggestions(
              WidgetsBinding.instance.window.locale.countryCode ?? "fr",
              text,
              WidgetsBinding.instance.window.locale.languageCode));
        },
        key: const Key("search_field"),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            focusColor: Colors.white,
            prefixIcon: widget.icon,
            suffixIcon: IconButton(
              onPressed: () {
                widget.onClear();
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            ),
            hintText: widget.hintText,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: (widget.focused) ? Colors.grey : Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: (widget.focused) ? Colors.grey : Colors.white)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: (widget.focused) ? Colors.grey : Colors.white)),
            fillColor: Colors.white));
  }
}
