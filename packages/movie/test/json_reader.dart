import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('movie')) {
    return File('$dir/test/$name').readAsStringSync();
  }
  if (dir.endsWith('packages')) {
    return File('$dir/movie/test/$name').readAsStringSync();
  }
  return File('$dir/packages/movie/test/$name').readAsStringSync();
}
