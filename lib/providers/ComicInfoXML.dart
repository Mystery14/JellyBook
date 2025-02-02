// the purpose of this file is to parse the ComicInfo.xml file used in comics to store metadata

import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:jellybook/variables.dart';
import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:jellybook/models/entry.dart';

Future<void> parseXML(Entry entry) async {
  // find the ComicInfo.xml file
  final files = Directory(entry.folderPath).listSync();
  File? xmlFile;
  for (var file in files) {
    if (file.path.toLowerCase().endsWith('comicinfo.xml')) {
      xmlFile = File(file.path);
      break;
    }
  }
  if (xmlFile == null) {
    logger.e('ComicInfo.xml file not found');
    return;
  }
  // confirm that its xs:complexType is ComicInfo
  final xmlFileContent = xml.XmlDocument.parse(xmlFile.readAsStringSync());
  if (xmlFileContent.rootElement.name.toString() != 'ComicInfo') {
    logger.e('ComicInfo.xml file is not of xs:complexType ComicInfo');
    return;
  }

  // add authors
  if (xmlFileContent.findAllElements('Writer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Writer');
    // add the author
    entry.writer = author.first.text;
    logger.d('writer: ${entry.writer}');
  }
  if (xmlFileContent.findAllElements('Penciller').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Penciller');
    // add the author
    entry.penciller = author.first.text;
    logger.d('penciller: ${entry.penciller}');
  }
  if (xmlFileContent.findAllElements('Inker').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Inker');
    // add the author
    entry.inker = author.first.text;
    logger.d('inker: ${entry.inker}');
  }
  if (xmlFileContent.findAllElements('Colorist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Colorist');
    // add the author
    entry.colorist = author.first.text;
    logger.d('colorist: ${entry.colorist}');
  }
  if (xmlFileContent.findAllElements('Letterer').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Letterer');
    // add the author
    entry.letterer = author.first.text;
    logger.d('letterer: ${entry.letterer}');
  }
  if (xmlFileContent.findAllElements('CoverArtist').isNotEmpty) {
    final author = xmlFileContent.findAllElements('CoverArtist');
    // add the author
    entry.coverArtist = author.first.text;
    logger.d('coverArtist: ${entry.coverArtist}');
  }
  if (xmlFileContent.findAllElements('Editor').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Editor');
    // add the author
    entry.editor = author.first.text;
    logger.d('editor: ${entry.editor}');
  }
  if (xmlFileContent.findAllElements('Publisher').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Publisher');
    // add the author
    entry.publisher = author.first.text;
    logger.d('publisher: ${entry.publisher}');
  }
  if (xmlFileContent.findAllElements('Imprint').isNotEmpty) {
    final author = xmlFileContent.findAllElements('Imprint');
    // add the author
    entry.imprint = author.first.text;
    logger.d('imprint: ${entry.imprint}');
  }

  // save to database
  final isar = Isar.getInstance();
  await isar!.writeTxn(() async {
    await isar.entrys.put(entry);
  }).catchError((dynamic error) {
    logger.e(error);
  }).onError((dynamic error, dynamic stackTrace) {
    logger.e(error);
  });
}
