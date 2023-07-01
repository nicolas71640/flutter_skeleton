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
    if (isFocused != _focused) {
      if (isFocused) {
        onTextChanged(target);
      }

      setState(() {
        target = "";
        _focused = isFocused;
      });
    }
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
                  onTextChanged: onTextChanged,
                  onSubmitted: onSubmitted),
              BlocConsumer<HomeBloc, HomeState>(
                  listenWhen: (previous, current) => current is PlaceDetails,
                  listener: (context, state) => widget
                      .onUpdate(Filter((state as PlaceDetails).suggestion)),
                  buildWhen: (previous, current) =>
                      current is SuggestionsUpdate,
                  builder: (context, state) {
                    if (state is SuggestionsUpdate && _focused) {
                      return SearchResult(
                          suggestions: state.suggestions,
                          onTap: onPlaceSelected);
                    } else {
                      return Container();
                    }
                  }),
            ])),
      ),
    );
  }

  void onTextChanged(String text) {
    if (text.isEmpty) {
      BlocProvider.of<HomeBloc>(context).add(ClearSearch());
    } else {
      BlocProvider.of<HomeBloc>(context).add(GetSuggestions(
          WidgetsBinding.instance.window.locale.countryCode ?? "fr",
          text,
          WidgetsBinding.instance.window.locale.languageCode));
    }
  }

  void onSubmitted(String text) {
    BlocProvider.of<HomeBloc>(context).add(
        FindPlace(text, WidgetsBinding.instance.window.locale.languageCode));
  }

  void onPlaceSelected(SuggestionEntity suggestion) {
    setState(() {
      FocusScope.of(context).unfocus();
      target = suggestion.description;
      _focused = false;
    });

    BlocProvider.of<HomeBloc>(context).add(PlaceSelected(
        suggestion, WidgetsBinding.instance.window.locale.languageCode));
  }
}

class SearchResult extends StatelessWidget {
  final void Function(SuggestionEntity) onTap;
  final List<SuggestionEntity> suggestions;

  const SearchResult({
    Key? key,
    required this.onTap,
    required this.suggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Builder(builder: (context) {
      if (suggestions.isNotEmpty) {
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(suggestions[index].description),
            onTap: () => onTap(suggestions[index]),
          ),
          itemCount: suggestions.length,
        );
      }
      return const Text("no result");
    }));
  }
}

class SearchField extends StatefulWidget {
  final String hintText;
  final GestureTapCallback? onTap;
  final Function(String) onTextChanged;
  final Function(String) onSubmitted;
  final bool focused;
  final String text;

  const SearchField(
      {super.key,
      required this.hintText,
      required this.onTap,
      required this.focused,
      required this.text,
      required this.onTextChanged,
      required this.onSubmitted});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController controller =
      TextEditingController(text: widget.text);
  @override
  Widget build(BuildContext context) {
    if (widget.text.isNotEmpty) {
      controller.text = widget.text;
    }
    return TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        controller: controller,
        onChanged: widget.onTextChanged,
        key: const Key("search_field"),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            focusColor: Colors.white,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              key: const Key("clear_search_button"),
              onPressed: () {
                controller.clear();
                widget.onTextChanged("");
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
