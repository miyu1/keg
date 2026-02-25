import 'package:test/test.dart';

import 'common.dart';

// to run debug for generators
void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('testGenerator function', () async {
      await testGenerator('index_test');
      //print('testGenerator output: ${output.join('\n')}');
    });
  });

}

/*
Future<List<String>> testGenerator(String name) async {
  // You can add shared setup code for multiple tests here.
  final readerwriter = TestReaderWriter(rootPackage: 'a');
  // get pubspec info from this package
  // to resolve annotation package
  await readerwriter.testing.loadIsolateSources();

  final dbGenerator = DatabaseGenerator();
  final tableGenerator = TableGenerator();
  final builder = SharedPartBuilder([dbGenerator, tableGenerator], 'keg');
  // final combine = combiningBuilder();

  final dataFile = File('test/$name.dart');
  final src = await dataFile.readAsString();
  final result = await testBuilder(builder, {
    'a|$name.dart': src,
  }, readerWriter: readerwriter);
  expect(result.succeeded, true);

  expect(result.outputs.length, 1);
  var outputId = result.outputs[0];
  //print('outputId: $outputId');
  expect(outputId.toString(), 'a|$name.keg.g.part');

  final content = readContent(outputId, result);
  //print('output content: <--\n$content\n-->');

  final outFile = File('test/$name.g.dart');
  await outFile.writeAsString('part of \'$name.dart\';\n\n');
  await outFile.writeAsString(content, mode: FileMode.append);

  final dart = await ProcessRunner.start('dart', [
    'run',
    'test/$name.dart',
  ]);
  final exitCode = await dart.waitForExit();

  for(final line in dart.stdout) {
    print('stdout: $line');
  }
  for(final line in dart.stderr) {
    print('stderr: $line');
  }

  expect(exitCode, 0);
  
  // final lastStdout = dart.stdout.last;
  // expect(lastStdout, 'success');

  return dart.stdout;
}

String readContent(AssetId id, TestBuilderResult result) {
  final reader = result.readerWriter.testing;

  if (reader.exists(id)) {
    return reader.readString(id);
  }

  // copied from build_test checkOutputs()
  final mappedAssetId = AssetId(
    //(result.readerWriter as ReaderWriter).rootPackage,
    id.package,
    '.dart_tool/build/generated/${id.package}/${id.path}',
  );

  return reader.readString(mappedAssetId);
}

class ProcessRunner {
  final String executable;
  final List<String> arguments;
  Process process;
  List<String> stdout = [];
  List<String> stderr = [];
  int exitCode = 0;

  // do not use
  ProcessRunner._(this.executable, this.arguments, this.process) {
    final stdoutStream = process.stdout.transform(systemEncoding.decoder);
    //.transform(const LineSplitter())
    final stderrStream = process.stderr.transform(systemEncoding.decoder);

    stdoutStream.listen((value) {
      if (stdout.isNotEmpty) {
        final last = stdout.last;
        if (value.startsWith(last)) {
          value = value.substring(last.length);
        }
      }
      if (value.isNotEmpty) {
        if (value.endsWith('\n')) {
          value = value.substring(0, value.length - 1);
        }
        stdout.add(value);
      }
    });

    stderrStream.listen((value) {
      if (value.isNotEmpty) {
        if (value.endsWith('\n')) {
          value = value.substring(0, value.length - 1);
        }
        stderr.add(value);
      }

    });
  }

  static Future<ProcessRunner> start(
    String executable,
    List<String> arguments,
  ) async {
    final process = await Process.start(executable, arguments);
    final ret = ProcessRunner._(executable, arguments, process);
    return ret;
  }

  Future<int> waitForExit() async {
    exitCode = await process.exitCode;
    return exitCode;
  }

  void clearStdout() {
    stdout = [];
  }
}
*/