/// Defines annotations for the Keg generator.
library;

import 'package:keg_annotation/src/annotations.dart';

export 'src/annotations.dart';

const table = Table();
const ignore = Ignore();
const unique = Index(unique: true);
const index = Index(unique: false);
