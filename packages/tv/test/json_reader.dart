import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('tv')) {
    return File('$dir/test/$name').readAsStringSync();
  }
  if (dir.endsWith('packages')) {
    return File('$dir/tv/test/$name').readAsStringSync();
  }
  return File('$dir/packages/tv/test/$name').readAsStringSync();
}
