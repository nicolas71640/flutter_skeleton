// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stuff_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$StuffApiService extends StuffApiService {
  _$StuffApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = StuffApiService;

  @override
  Future<Response<BuiltList<GetStuffResponse>>> getStuff() {
    final $url = '/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<GetStuffResponse>, GetStuffResponse>($request);
  }
}
