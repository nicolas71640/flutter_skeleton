import 'dart:convert';
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
dynamic fixtureJson(String name) => jsonDecode(File('test/fixtures/$name').readAsStringSync());
