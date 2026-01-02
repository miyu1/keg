/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/database_generator.dart';
import 'src/table_generator.dart';


export 'src/database_generator.dart';
export 'src/table_generator.dart';

Builder kegBuilder(BuilderOptions _) =>
    SharedPartBuilder([DatabaseGenerator(), TableGenerator()], "keg");
